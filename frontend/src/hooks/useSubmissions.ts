import { useCallback, useEffect, useState } from "react";
import { getSubmissionsByProblem, updateSubmissionNote } from "../api/submissions";
import type { SubmissionListItem } from "../types/submission";

export function useSubmissions(slug: string, enabled: boolean) {
  const [submissions, setSubmissions] = useState<SubmissionListItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [failed, setFailed] = useState(false);

  const fetch = useCallback(() => {
    if (!enabled) return;
    setLoading(true);
    setFailed(false);
    getSubmissionsByProblem(slug)
      .then((res) => setSubmissions(res.data))
      .catch(() => setFailed(true))
      .finally(() => setLoading(false));
  }, [slug, enabled]);

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect -- fetch() marks the request it starts as in flight.
    fetch();
  }, [fetch]);

  const updateNote = useCallback(async (id: number, notes: string) => {
    setSubmissions((prev) =>
      prev.map((s) => (s.id === id ? { ...s, notes } : s))
    );
    try {
      await updateSubmissionNote(id, notes);
    } catch {
      fetch();
    }
  }, [fetch]);

  return { submissions, loading, failed, refetch: fetch, updateNote };
}
