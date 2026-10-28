import type { TimerDeps } from "@/lib/timers";

export interface PollSchedule {
  intervalMs: number;
  /** Give up this long after polling started, whatever is in flight. */
  maxMs?: number;
  /** Give up once this many fetches have finished. */
  maxPolls?: number;
}

export type PollOutcome<T> = { type: "resolved"; value: T } | { type: "rejected"; error: unknown };

export interface Poll {
  /** Idempotent; nothing is called afterwards. */
  stop(): void;
}

/**
 * Calls `fetch` every `intervalMs`, each call scheduled only once the previous one has finished,
 * so at most one is in flight. `decide` sees every outcome and says whether to go on; `onGaveUp`
 * runs once if the schedule runs out first. After a stop, a "stop" decision or a give-up, neither
 * is called again.
 */
export function pollUntil<T>(
  fetch: () => Promise<T>,
  decide: (outcome: PollOutcome<T>) => "continue" | "stop",
  schedule: PollSchedule,
  timers: TimerDeps,
  onGaveUp: () => void = () => {},
): Poll {
  let done = false;
  let polls = 0;
  let tick: unknown = null;
  let deadline: unknown = null;

  const finish = () => {
    done = true;
    if (tick != null) timers.clearTimeout(tick);
    if (deadline != null) timers.clearTimeout(deadline);
    tick = deadline = null;
  };

  const giveUp = () => {
    if (done) return;
    finish();
    onGaveUp();
  };

  const settle = (outcome: PollOutcome<T>) => {
    if (done) return;
    polls += 1;
    if (decide(outcome) === "stop" || done) {
      finish();
      return;
    }
    if (schedule.maxPolls != null && polls >= schedule.maxPolls) {
      giveUp();
      return;
    }
    tick = timers.setTimeout(run, schedule.intervalMs);
  };

  const run = () => {
    tick = null;
    fetch().then(
      (value) => settle({ type: "resolved", value }),
      (error) => settle({ type: "rejected", error }),
    );
  };

  if (schedule.maxMs != null) deadline = timers.setTimeout(giveUp, schedule.maxMs);
  tick = timers.setTimeout(run, schedule.intervalMs);

  return { stop: finish };
}
