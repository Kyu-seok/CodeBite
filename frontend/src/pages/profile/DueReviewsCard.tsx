import { useCallback, useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import DifficultyBadge from "@/components/ui/DifficultyBadge";
import Spinner from "@/components/ui/Spinner";
import { getDueReviews, getReviewStats } from "@/api/reviews";
import { useConfidenceLabel, confidenceTextClass } from "@/lib/confidenceColors";
import type { DueReviewItem } from "@/types/review";
import type { Difficulty } from "@/types/problem";
import LoadError from "@/components/ui/LoadError";

export function DueReviewsCard() {
  const { t, i18n } = useTranslation("profile");
  const confidenceLabel = useConfidenceLabel();
  const [items, setItems] = useState<DueReviewItem[]>([]);
  const [total, setTotal] = useState(0);
  const [reviewStreak, setReviewStreak] = useState(0);
  const [status, setStatus] = useState<"loading" | "ready" | "failed">("loading");
  const [now] = useState(() => Date.now());

  const fetchDue = useCallback(() => {
    getDueReviews(0, 5)
      .then((res) => {
        setItems(res.data.content);
        setTotal(res.data.totalElements);
        setStatus("ready");
      })
      .catch(() => setStatus("failed"));
    // The Review Streak is a footnote here; if it fails to load the card simply doesn't show it.
    getReviewStats()
      .then((res) => setReviewStreak(res.data.currentStreak))
      .catch(() => {});
  }, []);

  useEffect(fetchDue, [fetchDue]);

  const retry = () => {
    setStatus("loading");
    fetchDue();
  };

  const relative = new Intl.RelativeTimeFormat(i18n.language, { numeric: "auto" });
  const dueText = (iso: string, daysOverdue: number) => {
    if (daysOverdue >= 1) return t("dueReviews.overdue", { count: daysOverdue });
    const ms = new Date(iso).getTime() - now;
    if (ms <= 0) return t("dueReviews.dueNow");
    // Whole UTC days between today and the due date, as Streak Days count them (ADR 0001)
    const utcDay = (time: number) => Math.floor(time / 86_400_000);
    return t("dueReviews.due", { when: relative.format(utcDay(now + ms) - utcDay(now), "day") });
  };

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1">
        <h2 className="text-sm font-medium text-foreground">{t("dueReviews.title")}</h2>
        <div className="flex items-baseline gap-3 text-xs text-muted-foreground">
          {reviewStreak > 0 && (
            <span className="tabular-nums">{t("dueReviews.reviewStreak", { count: reviewStreak })}</span>
          )}
          {total > 0 && <span className="tabular-nums">{t("dueReviews.count", { count: total })}</span>}
          <Link
            to="/reviews"
            className="rounded-sm transition-colors hover:text-accent-700 dark:hover:text-accent-400"
          >
            {t("dueReviews.viewAll")}
          </Link>
        </div>
      </div>

      {status === "loading" ? (
        <Spinner size="sm" className="h-20 p-0" />
      ) : status === "failed" ? (
        <LoadError onRetry={retry} />
      ) : items.length === 0 ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">{t("dueReviews.empty")}</p>
        </div>
      ) : (
        <ul className="space-y-0 divide-y divide-border/50">
          {items.map((it) => (
            <li
              key={it.problemId}
              className="flex items-center justify-between gap-4 py-2.5 first:pt-0 last:pb-0"
            >
              <div className="flex min-w-0 flex-1 items-center gap-3">
                <DifficultyBadge difficulty={it.difficulty as Difficulty} />
                <Link
                  to={`/problems/${it.slug}`}
                  className="truncate rounded-sm text-sm text-foreground transition-colors hover:text-accent-700 dark:hover:text-accent-400"
                >
                  {it.title}
                </Link>
              </div>

              <div className="flex shrink-0 items-center gap-3">
                <span
                  className={`hidden text-xs font-medium sm:block ${confidenceTextClass[it.lastConfidence]}`}
                >
                  {confidenceLabel(it.lastConfidence)}
                </span>
                <span className="min-w-24 text-right text-xs tabular-nums text-muted-foreground">
                  {dueText(it.nextDueAt, it.daysOverdue)}
                </span>
              </div>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
