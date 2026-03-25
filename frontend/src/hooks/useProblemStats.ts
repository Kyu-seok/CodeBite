import { useEffect, useState } from "react";
import { getProblemStats } from "../api/problems";
import type { ProblemStats } from "../types/problem";

export function useProblemStats() {
  const [stats, setStats] = useState<ProblemStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getProblemStats()
      .then((res) => setStats(res.data))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  return { stats, loading };
}
