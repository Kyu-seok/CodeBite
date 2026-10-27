import { useCallback, useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import DifficultyBadge from "@/components/ui/DifficultyBadge";
import Spinner from "@/components/ui/Spinner";
import LoadError from "@/components/ui/LoadError";
import { useConfidenceLabel } from "@/lib/confidenceColors";
import type { Confidence } from "@/types/review";
import {
  getWeakTags,
  getRoadmapNext,
  type WeakCategoryItem,
  type RoadmapNextItem,
} from "@/api/recommendations";

/** The rating nearest a numeric average (1 = Again … 4 = Easy). */
function nearestConfidence(avg: number): Confidence {
  if (avg < 1.5) return "AGAIN";
  if (avg < 2.5) return "HARD";
  if (avg < 3.5) return "GOOD";
  return "EASY";
}

export function RecommendationsCard() {
  const { t } = useTranslation("reviews");
  const confidenceLabel = useConfidenceLabel();
  const [weak, setWeak] = useState<WeakCategoryItem[]>([]);
  const [next, setNext] = useState<RoadmapNextItem[]>([]);
  const [status, setStatus] = useState<"loading" | "ready" | "failed">("loading");

  const fetchRecommendations = useCallback(() => {
    Promise.all([getWeakTags(3), getRoadmapNext()])
      .then(([w, n]) => {
        setWeak(w.data);
        setNext(n.data);
        setStatus("ready");
      })
      .catch(() => setStatus("failed"));
  }, []);

  useEffect(fetchRecommendations, [fetchRecommendations]);

  const retry = () => {
    setStatus("loading");
    fetchRecommendations();
  };

  const empty = status === "ready" && weak.length === 0 && next.length === 0;

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <h2 className="mb-4 text-sm font-medium text-foreground">{t("recommendations.title")}</h2>

      {status === "loading" ? (
        <Spinner size="sm" className="h-20 p-0" />
      ) : status === "failed" ? (
        <LoadError onRetry={retry} />
      ) : empty ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">{t("recommendations.empty")}</p>
        </div>
      ) : (
        <div className="space-y-5">
          {weak.length > 0 && (
            <section>
              <h3 className="mb-2 text-xs font-medium uppercase tracking-wider text-muted-foreground">
                {t("recommendations.weakest")}
              </h3>
              <ul className="space-y-2">
                {weak.map((w) => (
                  <li key={w.tagSlug}>
                    {/* `focusHistory` tells the History card to bring itself into view. */}
                    <Link
                      to={`/reviews?tag=${w.tagSlug}`}
                      state={{ focusHistory: true }}
                      className="flex items-center justify-between gap-3 rounded-md border border-border bg-background px-3 py-2 text-sm transition-colors hover:bg-muted/50"
                    >
                      <span className="font-medium text-foreground">{w.tagName}</span>
                      <span className="flex items-center gap-3 text-xs text-muted-foreground">
                        <span className="font-medium text-foreground">
                          {t("recommendations.average", { label: confidenceLabel(nearestConfidence(w.avgConfidence)) })}
                        </span>
                        <span className="tabular-nums">{t("chart.ratings", { count: w.ratedSubmissionCount })}</span>
                      </span>
                    </Link>
                  </li>
                ))}
              </ul>
            </section>
          )}

          {next.length > 0 && (
            <section>
              <h3 className="mb-2 text-xs font-medium uppercase tracking-wider text-muted-foreground">
                {t("recommendations.roadmapNext")}
              </h3>
              <ul className="space-y-2">
                {next.slice(0, 3).map((cat) => (
                  <li
                    key={cat.categorySlug}
                    className="rounded-md border border-border bg-background px-3 py-2"
                  >
                    <div className="text-sm font-medium text-foreground">{cat.categoryName}</div>
                    {cat.description && (
                      <div className="mt-0.5 text-xs text-muted-foreground">{cat.description}</div>
                    )}
                    {cat.unsolvedProblems.length > 0 && (
                      <div className="mt-2 flex flex-wrap items-center gap-2">
                        {cat.unsolvedProblems.map((p) => (
                          <Link
                            key={p.slug}
                            to={`/problems/${p.slug}`}
                            className="inline-flex items-center gap-1.5 rounded border border-border px-2 py-0.5 text-xs text-foreground transition-colors hover:bg-muted/50"
                          >
                            <DifficultyBadge difficulty={p.difficulty} />
                            <span className="truncate max-w-[12rem]">{p.title}</span>
                          </Link>
                        ))}
                      </div>
                    )}
                  </li>
                ))}
              </ul>
            </section>
          )}
        </div>
      )}
    </section>
  );
}
