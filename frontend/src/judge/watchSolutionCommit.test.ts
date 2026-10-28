import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import type { SolutionCommit, SubmissionResponse } from "@/types/submission";
import {
  SOLUTION_COMMIT_TIMING,
  awaitingSolutionCommit,
  watchSolutionCommit,
  type SolutionCommitDeps,
} from "./watchSolutionCommit";

const T0 = new Date("2026-10-28T12:00:00Z").getTime();
const { pollIntervalMs, maxPolls, graceMs } = SOLUTION_COMMIT_TIMING;

function accepted(solutionCommit: SolutionCommit | null, ageMs = 0): SubmissionResponse {
  return {
    id: 7,
    problemSlug: "two-sum",
    language: "python",
    status: "ACCEPTED",
    runtimeMs: 10,
    memoryKb: 100,
    sourceCode: "",
    results: [],
    createdAt: new Date(T0 - ageMs).toISOString(),
    notes: null,
    confidence: null,
    solveTimeSeconds: null,
    solutionCommit,
  };
}

const PENDING: SolutionCommit = { status: "PENDING", commitUrl: null };
const COMMITTED: SolutionCommit = { status: "COMMITTED", commitUrl: "https://github.com/u/r/commit/abc" };

function makeDeps(fetch: (call: number) => Promise<SubmissionResponse>) {
  let calls = 0;
  const getSubmission = vi.fn(() => fetch(calls++));
  const deps: SolutionCommitDeps = {
    getSubmission,
    now: () => Date.now(),
    setTimeout: (fn, ms) => setTimeout(fn, ms),
    clearTimeout: (handle) => clearTimeout(handle as ReturnType<typeof setTimeout>),
  };
  return { deps, getSubmission };
}

describe("awaitingSolutionCommit", () => {
  it("waits on a PENDING commit whatever the age", () => {
    expect(awaitingSolutionCommit(accepted(PENDING, graceMs * 10), T0)).toBe(true);
  });
  it("waits on a missing commit only within the grace after Accepted", () => {
    expect(awaitingSolutionCommit(accepted(null, graceMs - 1), T0)).toBe(true);
    expect(awaitingSolutionCommit(accepted(null, graceMs), T0)).toBe(false);
  });
  it("does not wait on a final commit or a non-Accepted submission", () => {
    expect(awaitingSolutionCommit(accepted(COMMITTED), T0)).toBe(false);
    expect(awaitingSolutionCommit({ ...accepted(null), status: "WRONG_ANSWER" }, T0)).toBe(false);
  });
});

describe("watchSolutionCommit", () => {
  let heard: (SolutionCommit | null)[];

  beforeEach(() => {
    vi.useFakeTimers();
    vi.setSystemTime(T0);
    heard = [];
  });
  afterEach(() => vi.useRealTimers());

  it("stops after 40 polls of a commit that stays PENDING", async () => {
    const { deps, getSubmission } = makeDeps(() => Promise.resolve(accepted(PENDING)));
    const watch = watchSolutionCommit({ id: 7 }, deps);
    watch.subscribe((c) => heard.push(c));

    await vi.advanceTimersByTimeAsync(pollIntervalMs * (maxPolls + 5));
    expect(getSubmission).toHaveBeenCalledTimes(maxPolls);
    expect(heard).toHaveLength(maxPolls);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("treats a missing commit as final once the grace has passed", async () => {
    // Accepted 59 s ago: the first poll, 3 s later, falls outside the grace.
    const { deps, getSubmission } = makeDeps(() => Promise.resolve(accepted(null, graceMs - 1000)));
    const watch = watchSolutionCommit({ id: 7 }, deps);
    watch.subscribe((c) => heard.push(c));

    await vi.advanceTimersByTimeAsync(pollIntervalMs * 3);
    expect(getSubmission).toHaveBeenCalledTimes(1);
    expect(heard).toEqual([null]);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("keeps polling a missing commit within the grace, and stops at the committed one", async () => {
    const { deps, getSubmission } = makeDeps((call) =>
      Promise.resolve(call < 2 ? accepted(null) : accepted(COMMITTED)),
    );
    const watch = watchSolutionCommit({ id: 7 }, deps);
    watch.subscribe((c) => heard.push(c));

    await vi.advanceTimersByTimeAsync(pollIntervalMs * 5);
    expect(getSubmission).toHaveBeenCalledTimes(3);
    expect(heard).toEqual([null, null, COMMITTED]);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("retries at the next tick after a failed fetch, without a word", async () => {
    const { deps, getSubmission } = makeDeps((call) =>
      call === 0 ? Promise.reject(new Error("network")) : Promise.resolve(accepted(COMMITTED)),
    );
    const watch = watchSolutionCommit({ id: 7 }, deps);
    watch.subscribe((c) => heard.push(c));

    await vi.advanceTimersByTimeAsync(pollIntervalMs);
    expect(heard).toEqual([]);
    await vi.advanceTimersByTimeAsync(pollIntervalMs);
    expect(getSubmission).toHaveBeenCalledTimes(2);
    expect(heard).toEqual([COMMITTED]);
  });

  it("stop silences it", async () => {
    const { deps, getSubmission } = makeDeps(() => Promise.resolve(accepted(PENDING)));
    const watch = watchSolutionCommit({ id: 7 }, deps);
    watch.subscribe((c) => heard.push(c));
    await vi.advanceTimersByTimeAsync(pollIntervalMs);
    watch.stop();
    await vi.advanceTimersByTimeAsync(pollIntervalMs * 5);
    expect(getSubmission).toHaveBeenCalledTimes(1);
    expect(heard).toHaveLength(1);
    expect(vi.getTimerCount()).toBe(0);
  });
});
