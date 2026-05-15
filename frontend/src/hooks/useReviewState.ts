import { useCallback, useEffect, useState } from "react";
import { getReviewState, setSubmissionReview } from "@/api/reviews";
import type { Confidence, ReviewState } from "@/types/review";

export function useReviewState(slug: string | undefined, enabled: boolean) {
  const [state, setState] = useState<ReviewState | null>(null);
  const [loading, setLoading] = useState(false);

  const fetchState = useCallback(async () => {
    if (!slug || !enabled) return;
    setLoading(true);
    try {
      const res = await getReviewState(slug);
      // 204 No Content arrives as "" (empty string body) per axios behavior
      if (res.status === 204 || res.data === "") {
        setState(null);
      } else {
        setState(res.data as ReviewState);
      }
    } catch {
      // ignore — caller will see state as null
    } finally {
      setLoading(false);
    }
  }, [slug, enabled]);

  useEffect(() => {
    fetchState();
  }, [fetchState]);

  const submit = useCallback(
    async (
      submissionId: number,
      confidence: Confidence,
      notes?: string | null,
    ) => {
      const res = await setSubmissionReview(submissionId, {
        confidence,
        notes: notes ?? undefined,
      });
      setState(res.data);
      return res.data;
    },
    [],
  );

  return { state, loading, submit, refetch: fetchState };
}
