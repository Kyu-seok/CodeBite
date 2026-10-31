import type { SubmissionStatus } from "@/types/submission";

/** A case that didn't pass. An unjudged custom case fails only when it crashed or timed out. */
export function caseFailed(r: { status: SubmissionStatus; judged?: boolean }): boolean {
  if (r.status === "ACCEPTED" || r.status === "PENDING") return false;
  if (r.judged === false) {
    return r.status === "RUNTIME_ERROR" || r.status === "TIME_LIMIT_EXCEEDED" || r.status === "COMPILATION_ERROR";
  }
  return true;
}
