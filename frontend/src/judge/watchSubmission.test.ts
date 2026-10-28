import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { SubmissionResponse, SubmissionStatus } from "@/types/submission";
import {
  WATCH_TIMING,
  watchSubmission,
  type ResultStream,
  type WatchDeps,
  type WatchEvent,
} from "./watchSubmission";

function submission(status: SubmissionStatus): SubmissionResponse {
  return {
    id: 7,
    problemSlug: "two-sum",
    language: "python",
    status,
    runtimeMs: null,
    memoryKb: null,
    sourceCode: "",
    results: [],
    createdAt: "2026-10-28T00:00:00Z",
    notes: null,
    confidence: null,
    solveTimeSeconds: null,
    solutionCommit: null,
  };
}

const PENDING = submission("PENDING");
const ACCEPTED = submission("ACCEPTED");

class FakeStream implements ResultStream {
  resultCb: (() => void) | null = null;
  closedCb: (() => void) | null = null;
  closed = false;
  onResult(cb: () => void) {
    this.resultCb = cb;
  }
  onClosed(cb: () => void) {
    this.closedCb = cb;
  }
  close() {
    this.closed = true;
  }
  emitResult() {
    this.resultCb?.();
  }
  emitClosed() {
    this.closedCb?.();
  }
}

/** What `getSubmission` does on its n-th call (0-based). */
type Fetch = (call: number) => Promise<SubmissionResponse>;

const always = (s: SubmissionResponse): Fetch => () => Promise.resolve(s);
/** The listed responses in order; the last one repeats. */
const sequence =
  (...responses: SubmissionResponse[]): Fetch =>
  (call) =>
    Promise.resolve(responses[Math.min(call, responses.length - 1)]);

function makeDeps(openStream: WatchDeps["openStream"], fetch: Fetch) {
  let calls = 0;
  const getSubmission = vi.fn(() => fetch(calls++));
  const deps: WatchDeps = {
    getSubmission,
    openStream,
    now: () => Date.now(),
    setTimeout: (fn, ms) => setTimeout(fn, ms),
    clearTimeout: (handle) => clearTimeout(handle as ReturnType<typeof setTimeout>),
  };
  return { deps, getSubmission };
}

const streamOf = (stream: FakeStream) => () => Promise.resolve(stream);
const noStream = () => Promise.reject(new Error("404 no stream token"));

/** Lets queued promise callbacks run without moving the clock. */
const flush = () => vi.advanceTimersByTimeAsync(0);

describe("watchSubmission", () => {
  let events: WatchEvent[];

  beforeEach(() => {
    vi.useFakeTimers();
    events = [];
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("settles once from a stream result; a second announcement is ignored", async () => {
    const stream = new FakeStream();
    const { deps, getSubmission } = makeDeps(streamOf(stream), always(ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));
    await flush();

    stream.emitResult();
    stream.emitResult();
    await flush();

    expect(events).toEqual([{ type: "settled", submission: ACCEPTED }]);
    expect(getSubmission).toHaveBeenCalledTimes(1);
    expect(stream.closed).toBe(true);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("hands off to polling when the fetch after a stream result still says PENDING", async () => {
    const stream = new FakeStream();
    const { deps, getSubmission } = makeDeps(streamOf(stream), sequence(PENDING, ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));
    await flush();

    stream.emitResult();
    await flush();
    expect(getSubmission).toHaveBeenCalledTimes(1);
    expect(events).toEqual([]);

    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(2);
    expect(events).toEqual([{ type: "settled", submission: ACCEPTED }]);
  });

  it("polls at 500 ms when there is no stream token", async () => {
    const { deps, getSubmission } = makeDeps(noStream, always(ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));

    await vi.advanceTimersByTimeAsync(499);
    expect(getSubmission).not.toHaveBeenCalled();
    await vi.advanceTimersByTimeAsync(1);
    expect(getSubmission).toHaveBeenCalledTimes(1);
    expect(events).toEqual([{ type: "settled", submission: ACCEPTED }]);
  });

  it("falls back once when the stream closes, even if it closes twice", async () => {
    const stream = new FakeStream();
    const { deps, getSubmission } = makeDeps(streamOf(stream), sequence(PENDING, PENDING, ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));
    await flush();

    stream.emitClosed();
    stream.emitClosed();
    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(1);
    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(2);
    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(3);
    expect(events).toEqual([{ type: "settled", submission: ACCEPTED }]);
  });

  it("leaves a silent stream at 90 s and polls", async () => {
    const stream = new FakeStream();
    const { deps, getSubmission } = makeDeps(streamOf(stream), always(ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));
    await flush();

    await vi.advanceTimersByTimeAsync(WATCH_TIMING.sseMaxMs - 1);
    expect(stream.closed).toBe(false);
    expect(getSubmission).not.toHaveBeenCalled();

    await vi.advanceTimersByTimeAsync(1);
    expect(stream.closed).toBe(true);
    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(1);
    expect(events).toEqual([{ type: "settled", submission: ACCEPTED }]);
  });

  it("gives up as slow 60 s after polling started, then calls nothing", async () => {
    const { deps, getSubmission } = makeDeps(noStream, always(PENDING));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));

    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollMaxMs - 1);
    expect(events).toEqual([]);
    await vi.advanceTimersByTimeAsync(1);
    expect(events).toEqual([{ type: "failed", reason: "slow" }]);

    const callsAtFailure = getSubmission.mock.calls.length;
    expect(callsAtFailure).toBeGreaterThan(100);
    await vi.advanceTimersByTimeAsync(10 * WATCH_TIMING.pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(callsAtFailure);
    expect(events).toHaveLength(1);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("never overlaps an in-flight fetch while polling", async () => {
    const slowFetch: Fetch = (call) =>
      new Promise((resolve) => setTimeout(() => resolve(call === 0 ? PENDING : ACCEPTED), 1500));
    const { deps, getSubmission } = makeDeps(noStream, slowFetch);
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));

    await vi.advanceTimersByTimeAsync(500); // first fetch starts
    await vi.advanceTimersByTimeAsync(1000); // 1500: three intervals later, still in flight
    expect(getSubmission).toHaveBeenCalledTimes(1);
    await vi.advanceTimersByTimeAsync(500); // 2000: resolves PENDING, next tick queued
    expect(getSubmission).toHaveBeenCalledTimes(1);
    await vi.advanceTimersByTimeAsync(500); // 2500: second fetch
    expect(getSubmission).toHaveBeenCalledTimes(2);
    await vi.advanceTimersByTimeAsync(1500);
    expect(events).toEqual([{ type: "settled", submission: ACCEPTED }]);
  });

  it("opens nothing when stopped before the stream arrives", async () => {
    const stream = new FakeStream();
    let deliver: (s: ResultStream) => void = () => {};
    const openStream = () => new Promise<ResultStream>((resolve) => (deliver = resolve));
    const { deps, getSubmission } = makeDeps(openStream, always(ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));

    watch.stop();
    deliver(stream);
    await flush();

    expect(stream.closed).toBe(true);
    expect(stream.resultCb).toBeNull();
    expect(stream.closedCb).toBeNull();
    await vi.advanceTimersByTimeAsync(WATCH_TIMING.sseMaxMs + WATCH_TIMING.pollMaxMs);
    expect(getSubmission).not.toHaveBeenCalled();
    expect(events).toEqual([]);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("fails as unreachable on a rejected fetch and clears its timers", async () => {
    const { deps, getSubmission } = makeDeps(noStream, () => Promise.reject(new Error("network")));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));

    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(events).toEqual([{ type: "failed", reason: "unreachable" }]);
    expect(vi.getTimerCount()).toBe(0);

    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollMaxMs);
    expect(getSubmission).toHaveBeenCalledTimes(1);
    expect(events).toHaveLength(1);
  });

  it("fails as unreachable when the fetch after a stream result rejects", async () => {
    const stream = new FakeStream();
    const { deps } = makeDeps(streamOf(stream), () => Promise.reject(new Error("network")));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));
    await flush();

    stream.emitResult();
    await flush();
    expect(events).toEqual([{ type: "failed", reason: "unreachable" }]);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("stop is idempotent and silences a stream that keeps talking", async () => {
    const stream = new FakeStream();
    const { deps, getSubmission } = makeDeps(streamOf(stream), always(ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));
    await flush();

    watch.stop();
    watch.stop();
    expect(stream.closed).toBe(true);
    stream.emitResult();
    stream.emitClosed();
    await vi.advanceTimersByTimeAsync(WATCH_TIMING.sseMaxMs + WATCH_TIMING.pollMaxMs);
    expect(getSubmission).not.toHaveBeenCalled();
    expect(events).toEqual([]);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("an unsubscribed listener hears nothing; the others still hear the one event", async () => {
    const { deps } = makeDeps(noStream, always(ACCEPTED));
    const watch = watchSubmission(7, deps);
    const other: WatchEvent[] = [];
    const unsubscribe = watch.subscribe((ev) => events.push(ev));
    watch.subscribe((ev) => other.push(ev));
    unsubscribe();

    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(events).toEqual([]);
    expect(other).toEqual([{ type: "settled", submission: ACCEPTED }]);
  });

  it("a stream close during the confirming fetch does not start a second chain", async () => {
    const stream = new FakeStream();
    const { deps, getSubmission } = makeDeps(streamOf(stream), sequence(PENDING, ACCEPTED));
    const watch = watchSubmission(7, deps);
    watch.subscribe((ev) => events.push(ev));
    await flush();

    stream.emitResult();
    stream.emitClosed();
    await flush();
    expect(getSubmission).toHaveBeenCalledTimes(1);
    await vi.advanceTimersByTimeAsync(WATCH_TIMING.pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(2);
    expect(events).toEqual([{ type: "settled", submission: ACCEPTED }]);
    expect(vi.getTimerCount()).toBe(0);
  });
});
