import { useEffect, useState } from "react";
import { getProblems } from "../api/problems";
import type { ProblemListItem, Difficulty } from "../types/problem";
import type { PageResponse } from "../types/api";

export function useProblems(page: number, size: number, difficulty?: Difficulty, search?: string, sort?: string, tag?: string, curation?: string) {
  const [data, setData] = useState<PageResponse<ProblemListItem> | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    getProblems(page, size, difficulty, search, sort, tag, curation)
      .then((res) => setData(res.data))
      .catch(() => setError("Failed to load problems"))
      .finally(() => setLoading(false));
  }, [page, size, difficulty, search, sort, tag, curation]);

  return { data, loading, error };
}
