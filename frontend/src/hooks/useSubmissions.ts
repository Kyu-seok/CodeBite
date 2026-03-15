import { useCallback, useEffect, useState } from "react";
import { getSubmissionsByProblem } from "../api/submissions";
import type { SubmissionListItem } from "../types/submission";

export function useSubmissions(slug: string, enabled: boolean) {
  const [submissions, setSubmissions] = useState<SubmissionListItem[]>([]);
  const [loading, setLoading] = useState(false);

  const fetch = useCallback(() => {
    if (!enabled) return;
    setLoading(true);
    getSubmissionsByProblem(slug)
      .then((res) => setSubmissions(res.data))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [slug, enabled]);

  useEffect(() => {
    fetch();
  }, [fetch]);

  return { submissions, loading, refetch: fetch };
}
