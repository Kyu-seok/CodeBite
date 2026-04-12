import { useEffect, useState } from "react";
import { getProblemStats } from "../api/problems";
import type { ProblemStats } from "../types/problem";

export function useProblemStats(curation?: string) {
  const [stats, setStats] = useState<ProblemStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    getProblemStats(curation)
      .then((res) => setStats(res.data))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [curation]);

  return { stats, loading };
}
