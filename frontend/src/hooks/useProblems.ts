import { useEffect, useState } from "react";
import { getProblems } from "../api/problems";
import type { ProblemListItem, Difficulty } from "../types/problem";
import type { PageResponse } from "../types/api";

export function useProblems(page: number, size: number, difficulty?: Difficulty) {
  const [data, setData] = useState<PageResponse<ProblemListItem> | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    getProblems(page, size, difficulty)
      .then((res) => setData(res.data))
      .catch(() => setError("Failed to load problems"))
      .finally(() => setLoading(false));
  }, [page, size, difficulty]);

  return { data, loading, error };
}
