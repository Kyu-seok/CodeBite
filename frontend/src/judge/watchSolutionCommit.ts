import type { SolutionCommit, SubmissionResponse } from "@/types/submission";
import type { TimerDeps } from "@/lib/timers";
import { pollUntil } from "./pollUntil";

export interface SolutionCommitDeps extends TimerDeps {
  getSubmission(id: number): Promise<SubmissionResponse>;
}

export interface SolutionCommitTiming {
  pollIntervalMs: number;
  maxPolls: number;
  /** After Accepted, how long a missing Solution Commit is "not recorded yet" rather than "none". */
  graceMs: number;
}

// The verdict arrives first; the Solution Commit reaches GitHub a little later (with retries,
// up to several seconds), so the detail view keeps asking while it is in flight.
export const SOLUTION_COMMIT_TIMING: SolutionCommitTiming = {
  pollIntervalMs: 3000,
  maxPolls: 40,
  graceMs: 60_000,
};

type CommitState = Pick<SubmissionResponse, "status" | "createdAt" | "solutionCommit">;

/** True while the Solution Commit may still change: it is PENDING, or Accepted so recently that none being recorded yet is not final. */
export function awaitingSolutionCommit(
  submission: CommitState,
  now: number,
  graceMs: number = SOLUTION_COMMIT_TIMING.graceMs,
): boolean {
  if (submission.solutionCommit?.status === "PENDING") return true;
  return (
    submission.status === "ACCEPTED" &&
    submission.solutionCommit == null &&
    now - new Date(submission.createdAt).getTime() < graceMs
  );
}

export interface SolutionCommitWatch {
  /** Hears the Solution Commit after every successful fetch, the last one included. */
  subscribe(listener: (commit: SolutionCommit | null) => void): () => void;
  stop(): void;
}

/**
 * Re-fetches a submission while its Solution Commit is in flight. Stops once the commit is final,
 * once a missing one has outlived the grace, or after `maxPolls`; a failed fetch is simply retried
 * at the next tick. After `stop()`, nothing is heard or called.
 */
export function watchSolutionCommit(
  submission: Pick<SubmissionResponse, "id">,
  deps: SolutionCommitDeps,
  timing: SolutionCommitTiming = SOLUTION_COMMIT_TIMING,
): SolutionCommitWatch {
  const listeners = new Set<(commit: SolutionCommit | null) => void>();
  const poll = pollUntil(
    () => deps.getSubmission(submission.id),
    (outcome) => {
      if (outcome.type === "rejected") return "continue";
      for (const listener of [...listeners]) listener(outcome.value.solutionCommit);
      return awaitingSolutionCommit(outcome.value, deps.now(), timing.graceMs) ? "continue" : "stop";
    },
    { intervalMs: timing.pollIntervalMs, maxPolls: timing.maxPolls },
    deps,
  );
  return {
    subscribe(listener) {
      listeners.add(listener);
      return () => {
        listeners.delete(listener);
      };
    },
    stop() {
      poll.stop();
      listeners.clear();
    },
  };
}
