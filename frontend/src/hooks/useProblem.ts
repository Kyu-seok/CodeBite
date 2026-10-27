import { useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { isAxiosError } from "axios";
import { getProblemBySlug } from "../api/problems";
import type { ProblemDetail } from "../types/problem";

/** Why the problem couldn't be shown; the page owns the (translated) copy. */
export type ProblemLoadError = "notFound" | "failed";

export function useProblem(slug: string) {
  const { i18n } = useTranslation();
  const [problem, setProblem] = useState<ProblemDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<ProblemLoadError | null>(null);
  const [attempt, setAttempt] = useState(0);

  useEffect(() => {
    setLoading(true);
    setError(null);
    getProblemBySlug(slug)
      .then((res) => setProblem(res.data))
      .catch((err) => {
        // Only a 404 means the problem doesn't exist; anything else (network, 5xx) is retryable.
        setError(isAxiosError(err) && err.response?.status === 404 ? "notFound" : "failed");
      })
      .finally(() => setLoading(false));
  }, [slug, i18n.language, attempt]);

  const retry = useCallback(() => setAttempt((n) => n + 1), []);

  return { problem, loading, error, retry };
}
