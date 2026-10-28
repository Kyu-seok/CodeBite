/** Timers as a parameter, so a machine can run under fake ones in tests. */
export interface TimerDeps {
  now(): number;
  setTimeout(fn: () => void, ms: number): unknown;
  clearTimeout(handle: unknown): void;
}

/** The window's timers: the one real implementation. */
export const browserTimers: TimerDeps = {
  now: () => Date.now(),
  setTimeout: (fn, ms) => window.setTimeout(fn, ms),
  clearTimeout: (handle) => window.clearTimeout(handle as number),
};
