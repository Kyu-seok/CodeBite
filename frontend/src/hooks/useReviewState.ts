import { useCallback, useEffect, useState } from "react";
import { getReviewState, REVIEW_CHANGED_EVENT, setSubmissionReview } from "@/api/reviews";
import type { Confidence, ReviewState } from "@/types/review";

export function useReviewState(slug: string | undefined, enabled: boolean) {
  const [state, setState] = useState<ReviewState | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(false);
  const [loaded, setLoaded] = useState(false);

  const fetchState = useCallback(async () => {
    if (!slug || !enabled) return;
    setLoading(true);
    setError(false);
    try {
      const res = await getReviewState(slug);
      // 204 No Content arrives as "" (empty string body) per axios behavior
      if (res.status === 204 || res.data === "") {
        setState(null);
      } else {
        setState(res.data as ReviewState);
      }
      setLoaded(true);
    } catch {
      setError(true);
    } finally {
      setLoading(false);
    }
  }, [slug, enabled]);

  useEffect(() => {
    fetchState();
  }, [fetchState]);

  // A rating saved elsewhere on the page (Accepted prompt, submission detail) moves the schedule.
  useEffect(() => {
    if (!enabled) return;
    const onChange = () => fetchState();
    window.addEventListener(REVIEW_CHANGED_EVENT, onChange);
    return () => window.removeEventListener(REVIEW_CHANGED_EVENT, onChange);
  }, [enabled, fetchState]);

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

  return { state, loading, error, loaded, submit, refetch: fetchState };
}
