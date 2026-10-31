import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { getProblems } from "../api/problems";
import type { ProblemListItem, Difficulty } from "../types/problem";
import type { PageResponse } from "../types/api";

export function useProblems(page: number, size: number, difficulty?: Difficulty, search?: string, sort?: string, tag?: string, curation?: string) {
  const { i18n } = useTranslation();
  const [data, setData] = useState<PageResponse<ProblemListItem> | null>(null);
  const [loading, setLoading] = useState(true);
  // A flag, not a message: the page owns the translated copy.
  const [error, setError] = useState(false);
  const [retryKey, setRetryKey] = useState(0);

  useEffect(() => {
    // Filters change faster than the API answers; only the latest request may land.
    let current = true;
    // eslint-disable-next-line react-hooks/set-state-in-effect -- Marks the fetch this effect starts as in flight.
    setLoading(true);
    getProblems(page, size, difficulty, search, sort, tag, curation)
      .then((res) => {
        if (!current) return;
        setData(res.data);
        setError(false);
      })
      .catch(() => {
        if (current) setError(true);
      })
      .finally(() => {
        if (current) setLoading(false);
      });
    return () => {
      current = false;
    };
  }, [page, size, difficulty, search, sort, tag, curation, i18n.language, retryKey]);

  const retry = () => setRetryKey((k) => k + 1);

  return { data, loading, error, retry };
}
