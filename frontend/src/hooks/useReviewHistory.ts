import { useCallback, useEffect, useState } from "react";
import { getReviewHistory, REVIEW_CHANGED_EVENT } from "@/api/reviews";
import type { RatingHistoryItem } from "@/types/review";

export function useReviewHistory(slug: string | undefined, enabled: boolean) {
  const [history, setHistory] = useState<RatingHistoryItem[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchHistory = useCallback(async () => {
    if (!slug || !enabled) return;
    setLoading(true);
    try {
      const res = await getReviewHistory(slug);
      setHistory(res.data);
    } catch {
      // ignore — caller will see history as []
    } finally {
      setLoading(false);
    }
  }, [slug, enabled]);

  useEffect(() => {
    fetchHistory();
  }, [fetchHistory]);

  // Keep the Progression strip in step with ratings saved elsewhere on the page.
  useEffect(() => {
    if (!enabled) return;
    const onChange = () => fetchHistory();
    window.addEventListener(REVIEW_CHANGED_EVENT, onChange);
    return () => window.removeEventListener(REVIEW_CHANGED_EVENT, onChange);
  }, [enabled, fetchHistory]);

  return { history, loading, refetch: fetchHistory };
}
