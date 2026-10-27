import { useCallback, useEffect, useState } from "react";
import { getProblemStats } from "../api/problems";
import type { ProblemStats } from "../types/problem";

export function useProblemStats(curation?: string) {
  const [stats, setStats] = useState<ProblemStats | null>(null);
  const [failed, setFailed] = useState(false);
  const [attempt, setAttempt] = useState(0);

  useEffect(() => {
    let current = true;
    getProblemStats(curation)
      .then((res) => {
        if (!current) return;
        setStats(res.data);
        setFailed(false);
      })
      .catch(() => current && setFailed(true));
    return () => {
      current = false;
    };
  }, [curation, attempt]);

  const retry = useCallback(() => {
    setFailed(false);
    setAttempt((n) => n + 1);
  }, []);

  return { stats, failed, retry };
}
