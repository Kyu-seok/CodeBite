import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { pollUntil, type PollOutcome } from "./pollUntil";

const timers = {
  now: () => Date.now(),
  setTimeout: (fn: () => void, ms: number) => setTimeout(fn, ms),
  clearTimeout: (handle: unknown) => clearTimeout(handle as ReturnType<typeof setTimeout>),
};

describe("pollUntil", () => {
  beforeEach(() => vi.useFakeTimers());
  afterEach(() => vi.useRealTimers());

  it("fetches every interval until told to stop, then never again", async () => {
    let n = 0;
    const fetch = vi.fn(() => Promise.resolve(++n));
    const outcomes: PollOutcome<number>[] = [];
    pollUntil(fetch, (o) => (outcomes.push(o), o.type === "resolved" && o.value === 3 ? "stop" : "continue"), { intervalMs: 100 }, timers);

    await vi.advanceTimersByTimeAsync(299);
    expect(fetch).toHaveBeenCalledTimes(2);
    await vi.advanceTimersByTimeAsync(1);
    expect(fetch).toHaveBeenCalledTimes(3);
    await vi.advanceTimersByTimeAsync(1000);
    expect(fetch).toHaveBeenCalledTimes(3);
    expect(outcomes).toHaveLength(3);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("schedules the next fetch only after the previous one finished", async () => {
    const fetch = vi.fn(() => new Promise<number>((resolve) => setTimeout(() => resolve(1), 250)));
    pollUntil(fetch, () => "continue", { intervalMs: 100 }, timers);

    await vi.advanceTimersByTimeAsync(100); // first fetch starts
    await vi.advanceTimersByTimeAsync(200); // 300: still in flight
    expect(fetch).toHaveBeenCalledTimes(1);
    await vi.advanceTimersByTimeAsync(50); // 350: resolved, next at 450
    await vi.advanceTimersByTimeAsync(99);
    expect(fetch).toHaveBeenCalledTimes(1);
    await vi.advanceTimersByTimeAsync(1);
    expect(fetch).toHaveBeenCalledTimes(2);
  });

  it("hands a rejection to decide instead of throwing", async () => {
    const fetch = vi.fn(() => Promise.reject(new Error("network")));
    const decide = vi.fn<(o: PollOutcome<never>) => "continue" | "stop">(() => "continue");
    pollUntil(fetch, decide, { intervalMs: 100 }, timers);
    await vi.advanceTimersByTimeAsync(200);
    expect(decide).toHaveBeenCalledTimes(2);
    expect(decide.mock.calls[0][0].type).toBe("rejected");
  });

  it("gives up after maxMs even while a fetch is in flight", async () => {
    const fetch = vi.fn(() => new Promise<number>(() => {}));
    const gaveUp = vi.fn();
    const decide = vi.fn(() => "continue" as const);
    pollUntil(fetch, decide, { intervalMs: 100, maxMs: 1000 }, timers, gaveUp);
    await vi.advanceTimersByTimeAsync(999);
    expect(gaveUp).not.toHaveBeenCalled();
    await vi.advanceTimersByTimeAsync(1);
    expect(gaveUp).toHaveBeenCalledTimes(1);
    expect(fetch).toHaveBeenCalledTimes(1);
    expect(decide).not.toHaveBeenCalled();
    expect(vi.getTimerCount()).toBe(0);
  });

  it("gives up after maxPolls finished fetches", async () => {
    const fetch = vi.fn(() => Promise.resolve(0));
    const gaveUp = vi.fn();
    pollUntil(fetch, () => "continue", { intervalMs: 100, maxPolls: 3 }, timers, gaveUp);
    await vi.advanceTimersByTimeAsync(1000);
    expect(fetch).toHaveBeenCalledTimes(3);
    expect(gaveUp).toHaveBeenCalledTimes(1);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("stop silences a fetch that resolves later", async () => {
    const fetch = vi.fn(() => new Promise<number>((resolve) => setTimeout(() => resolve(1), 50)));
    const decide = vi.fn(() => "continue" as const);
    const gaveUp = vi.fn();
    const poll = pollUntil(fetch, decide, { intervalMs: 100, maxMs: 500 }, timers, gaveUp);
    await vi.advanceTimersByTimeAsync(100);
    poll.stop();
    poll.stop();
    await vi.advanceTimersByTimeAsync(1000);
    expect(fetch).toHaveBeenCalledTimes(1);
    expect(decide).not.toHaveBeenCalled();
    expect(gaveUp).not.toHaveBeenCalled();
    expect(vi.getTimerCount()).toBe(0);
  });
});
