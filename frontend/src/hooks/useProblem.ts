import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { getProblemBySlug } from "../api/problems";
import type { ProblemDetail } from "../types/problem";

export function useProblem(slug: string) {
  const { i18n } = useTranslation();
  const [problem, setProblem] = useState<ProblemDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setLoading(true);
    getProblemBySlug(slug)
      .then((res) => setProblem(res.data))
      .catch(() => setError("Problem not found"))
      .finally(() => setLoading(false));
  }, [slug, i18n.language]);

  return { problem, loading, error };
}
