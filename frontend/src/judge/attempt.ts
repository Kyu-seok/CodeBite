import type { RunResponse, SubmissionResponse } from "@/types/submission";
import type { WatchFailure } from "./watchSubmission";

export type JudgeMode = "run" | "submit";

/**
 * Why an Attempt failed: the request itself was rejected (`message` carries the server's reason,
 * when it gave one), or the watch lost sight of a Submit's verdict (see `WatchFailure`).
 */
export type AttemptFailure = "rejected" | WatchFailure;

/**
 * One Run or Submit, from the learner's action to its verdict or its failure. There is only ever
 * one: starting a Run or a Submit replaces whatever the last one left behind.
 */
export type JudgeAttempt =
  | { kind: "idle" }
  | { kind: "judging"; mode: JudgeMode; startedAt: number; submissionId?: number }
  | { kind: "settled"; mode: "run"; result: RunResponse; startedAt: number }
  | { kind: "settled"; mode: "submit"; result: SubmissionResponse; startedAt: number }
  | { kind: "failed"; mode: JudgeMode; reason: AttemptFailure; message?: string };
