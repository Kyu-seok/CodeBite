import { useCallback, useEffect, useState } from "react";
import { getReviewHistory } from "@/api/reviews";
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

  return { history, loading, refetch: fetchHistory };
}
