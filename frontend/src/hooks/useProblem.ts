import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { getProblemBySlug } from "../api/problems";
import type { ProblemDetail } from "../types/problem";

export function useProblem(slug: string) {
  const { i18n } = useTranslation();
  const [problem, setProblem] = useState<ProblemDetail | null>(null);
  const [loading, setLoading] = useState(true);
  // A flag, not a message: the page owns the (translated) copy.
  const [error, setError] = useState(false);

  useEffect(() => {
    setLoading(true);
    setError(false);
    getProblemBySlug(slug)
      .then((res) => setProblem(res.data))
      .catch(() => setError(true))
      .finally(() => setLoading(false));
  }, [slug, i18n.language]);

  return { problem, loading, error };
}
