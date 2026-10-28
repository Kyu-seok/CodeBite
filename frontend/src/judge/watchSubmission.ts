import type { SubmissionResponse } from "@/types/submission";
import type { TimerDeps } from "@/lib/timers";
import { pollUntil, type Poll, type PollOutcome } from "./pollUntil";

/**
 * What the browser hands the watch: the API, the result stream and timers. Tests pass fakes;
 * `hooks/useSubmissionWatch.ts` passes the real ones.
 */
export interface WatchDeps extends TimerDeps {
  getSubmission(id: number): Promise<SubmissionResponse>;
  /**
   * Opens the result stream for a submission. Rejects when it cannot be opened: no stream token
   * (SSE is off server-side), or no EventSource. The watch then polls instead.
   */
  openStream(id: number): Promise<ResultStream>;
}

/** A server-sent stream that announces the verdict; the watch still fetches the submission. */
export interface ResultStream {
  /** The server says the verdict is in. */
  onResult(cb: () => void): void;
  /** The stream has given up for good (EventSource retries by itself before that). */
  onClosed(cb: () => void): void;
  close(): void;
}

/**
 * Why the watch lost sight of the verdict. The row exists either way, so the Submissions tab
 * still shows it: to the user, "failed" means "refresh to see it".
 */
export type WatchFailure = "slow" | "unreachable";

export type WatchEvent =
  | { type: "settled"; submission: SubmissionResponse }
  | { type: "failed"; reason: WatchFailure };

export interface WatchTiming {
  pollIntervalMs: number;
  /** Counted from the moment polling starts, not from submit. */
  pollMaxMs: number;
  /** Below the server's 120 s emitter timeout, so the client leaves a silent stream first. */
  sseMaxMs: number;
}

export const WATCH_TIMING: WatchTiming = { pollIntervalMs: 500, pollMaxMs: 60_000, sseMaxMs: 90_000 };

export interface SubmissionWatch {
  /** Returns the unsubscribe function. A listener hears the one terminal event, if still subscribed. */
  subscribe(listener: (ev: WatchEvent) => void): () => void;
  /** Idempotent, and safe before anything has resolved: nothing is heard or called afterwards. */
  stop(): void;
}

/**
 * Waits for a submission's verdict: over the result stream first, then by polling.
 *
 * Exactly one terminal event per call, then nothing: no listener call and no dep call after
 * a terminal event or `stop()`. The path is stream → polling, never the reverse, and the handoff
 * happens once, on any of: the stream cannot be opened, it closes for good, it stays silent for
 * `sseMaxMs`, or it announces a result that the fetch still reports as PENDING. Polling is a
 * `setTimeout` chain with at most one `getSubmission` in flight. "slow" fires `pollMaxMs` after
 * polling started, so in the worst case `sseMaxMs + pollMaxMs` (150 s) after submit; "unreachable"
 * is a rejected `getSubmission`.
 */
export function watchSubmission(
  id: number,
  deps: WatchDeps,
  timing: WatchTiming = WATCH_TIMING,
): SubmissionWatch {
  // opening: waiting for the stream; streaming: listening to it; confirming: fetching after the
  // stream announced a result; polling: the fallback chain; done: terminal event or stop().
  type Phase = "opening" | "streaming" | "confirming" | "polling" | "done";
  let phase: Phase = "opening";
  let stream: ResultStream | null = null;
  let sseDeadline: unknown = null;
  let poll: Poll | null = null;
  const listeners = new Set<(ev: WatchEvent) => void>();

  const clearTimer = (handle: unknown) => {
    if (handle != null) deps.clearTimeout(handle);
  };

  const teardown = () => {
    clearTimer(sseDeadline);
    sseDeadline = null;
    poll?.stop();
    poll = null;
    stream?.close();
    stream = null;
  };

  const finish = (ev: WatchEvent) => {
    if (phase === "done") return;
    phase = "done";
    teardown();
    const heard = [...listeners];
    listeners.clear();
    for (const listener of heard) listener(ev);
  };

  /** One fetch's outcome: a verdict settles, a rejection fails, PENDING goes to `onPending`. */
  const judge = (outcome: PollOutcome<SubmissionResponse>, onPending: () => void) => {
    if (phase === "done") return;
    if (outcome.type === "rejected") finish({ type: "failed", reason: "unreachable" });
    else if (outcome.value.status === "PENDING") onPending();
    else finish({ type: "settled", submission: outcome.value });
  };

  const startPolling = () => {
    if (phase === "polling" || phase === "done") return;
    phase = "polling";
    clearTimer(sseDeadline);
    sseDeadline = null;
    stream?.close();
    stream = null;
    poll = pollUntil(
      () => deps.getSubmission(id),
      (outcome) => {
        judge(outcome, () => {});
        return phase === "done" ? "stop" : "continue";
      },
      { intervalMs: timing.pollIntervalMs, maxMs: timing.pollMaxMs },
      deps,
      () => finish({ type: "failed", reason: "slow" }),
    );
  };

  const onStreamResult = () => {
    if (phase !== "streaming") return;
    // The stream has done its job; a second announcement, or a close, changes nothing now.
    phase = "confirming";
    clearTimer(sseDeadline);
    sseDeadline = null;
    stream?.close();
    stream = null;
    deps.getSubmission(id).then(
      (value) => judge({ type: "resolved", value }, startPolling),
      (error) => judge({ type: "rejected", error }, startPolling),
    );
  };

  const onStreamClosed = () => {
    if (phase === "streaming") startPolling();
  };

  deps.openStream(id).then(
    (opened) => {
      if (phase !== "opening") {
        // Stopped before the stream arrived (StrictMode's first mount, a resubmit): open nothing.
        opened.close();
        return;
      }
      phase = "streaming";
      stream = opened;
      opened.onResult(onStreamResult);
      opened.onClosed(onStreamClosed);
      sseDeadline = deps.setTimeout(() => {
        if (phase === "streaming") startPolling();
      }, timing.sseMaxMs);
    },
    () => {
      if (phase === "opening") startPolling();
    },
  );

  return {
    subscribe(listener) {
      listeners.add(listener);
      return () => {
        listeners.delete(listener);
      };
    },
    stop() {
      if (phase === "done") return;
      phase = "done";
      teardown();
      listeners.clear();
    },
  };
}
