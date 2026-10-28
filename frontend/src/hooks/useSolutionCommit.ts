import { useEffect, useState } from "react";
import { getSubmission } from "@/api/submissions";
import { browserTimers } from "@/lib/timers";
import {
  awaitingSolutionCommit,
  watchSolutionCommit,
  type SolutionCommitDeps,
} from "@/judge/watchSolutionCommit";
import type { SolutionCommit, SubmissionResponse } from "@/types/submission";

const browserSolutionCommitDeps: SolutionCommitDeps = {
  getSubmission: (id) => getSubmission(id).then((res) => res.data),
  ...browserTimers,
};

/**
 * The submission's Solution Commit, kept current while it is in flight: the loaded value at
 * first, then whatever the watch reports. Only the commit moves, so an unsaved note edit on the
 * submission is never overwritten.
 */
export function useSolutionCommit(submission: SubmissionResponse | null): SolutionCommit | null {
  const [live, setLive] = useState<{ id: number; commit: SolutionCommit | null } | null>(null);
  const id = submission?.id;
  const commit =
    submission == null ? null : live?.id === submission.id ? live.commit : submission.solutionCommit;
  // The same clock the watch decides by, read once per render as the old inline poll did.
  const awaiting =
    submission != null &&
    awaitingSolutionCommit({ ...submission, solutionCommit: commit }, browserSolutionCommitDeps.now());

  useEffect(() => {
    if (!awaiting || id == null) return;
    const watch = watchSolutionCommit({ id }, browserSolutionCommitDeps);
    watch.subscribe((next) => setLive({ id, commit: next }));
    return watch.stop;
  }, [awaiting, id]);

  return commit;
}
