import { useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import {
  getReviewStats,
  getReviewActivity,
  getTagConfidence,
} from "@/api/reviews";
import type { ReviewStats, TagConfidenceItem } from "@/types/review";
import type { ActivityDay } from "@/types/profile";
import Spinner from "@/components/ui/Spinner";
import LoadError from "@/components/ui/LoadError";
import { ActivityHeatmap } from "@/pages/profile/ActivityHeatmap";
import { TagConfidenceChart } from "./TagConfidenceChart";
import { RecommendationsCard } from "./RecommendationsCard";
import { ReviewHistoryList } from "./ReviewHistoryList";
import { formatDuration } from "./formatDuration";

function without<T>(set: ReadonlySet<T>, item: T): ReadonlySet<T> {
  if (!set.has(item)) return set;
  const next = new Set(set);
  next.delete(item);
  return next;
}

interface SummaryCardProps {
  label: string;
  value: string;
  hint?: string;
}

function SummaryCard({ label, value, hint }: SummaryCardProps) {
  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <dt className="text-xs uppercase tracking-wider text-muted-foreground">{label}</dt>
      <dd className="mt-2 text-2xl font-semibold text-foreground tabular-nums break-keep">{value}</dd>
      {hint && <dd className="mt-1 text-xs text-muted-foreground">{hint}</dd>}
    </div>
  );
}

type Section = "stats" | "activity" | "tags";
const SECTIONS: Section[] = ["stats", "activity", "tags"];

export default function ReviewsPage() {
  const { t, i18n } = useTranslation("reviews");
  const [stats, setStats] = useState<ReviewStats | null>(null);
  const [activity, setActivity] = useState<ActivityDay[]>([]);
  const [tagConfidence, setTagConfidence] = useState<TagConfidenceItem[]>([]);
  const [failed, setFailed] = useState<ReadonlySet<Section>>(new Set());
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    document.title = t("metaTitle");
  }, [t]);

  // Each section loads and retries on its own, so one failure shows as an error on its card
  // instead of zeros across the page, and retrying it leaves the other cards (and the
  // History filters) alone.
  const load = useCallback((section: Section) => {
    const request =
      section === "stats"
        ? getReviewStats().then((res) => setStats(res.data))
        : section === "activity"
          ? getReviewActivity(12).then((res) => setActivity(res.data as ActivityDay[]))
          : getTagConfidence().then((res) => setTagConfidence(res.data));
    return request.then(
      () => setFailed((prev) => without(prev, section)),
      () => setFailed((prev) => new Set(prev).add(section)),
    );
  }, []);

  useEffect(() => {
    Promise.all(SECTIONS.map(load)).finally(() => setLoading(false));
  }, [load]);

  if (loading) {
    return (
      <div className="mx-auto flex max-w-5xl items-center justify-center px-4 py-20 sm:px-6">
        <Spinner />
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6">
      <div className="flex flex-col gap-5">
        <div>
          <h1 className="text-2xl font-bold text-foreground">{t("title")}</h1>
          <p className="mt-1 text-sm text-muted-foreground">{t("subtitle")}</p>
        </div>

        {failed.has("stats") || !stats ? (
          <div className="rounded-xl border border-border bg-card p-5">
            <LoadError onRetry={() => load("stats")} />
          </div>
        ) : (
          <dl className="grid grid-cols-2 gap-4 md:grid-cols-4">
            <SummaryCard
              label={t("summary.totalRatings")}
              value={stats.totalReviews.toLocaleString(i18n.language)}
              hint={t("summary.totalRatingsHint")}
            />
            <SummaryCard
              label={t("summary.timeInvested")}
              value={formatDuration(stats.totalSolveTimeSeconds, i18n.language)}
              hint={t("summary.timeInvestedHint")}
            />
            <SummaryCard
              label={t("summary.reviewStreak")}
              value={t("summary.days", { count: stats.currentStreak })}
              hint={t("summary.reviewStreakHint")}
            />
            <SummaryCard
              label={t("summary.bestReviewStreak")}
              value={t("summary.days", { count: stats.longestStreak })}
              hint={t("summary.bestReviewStreakHint")}
            />
          </dl>
        )}

        {failed.has("activity") ? (
          <section className="rounded-xl border border-border bg-card p-5">
            <h2 className="text-sm font-medium text-foreground">{t("activity.title")}</h2>
            <LoadError onRetry={() => load("activity")} />
          </section>
        ) : (
          <ActivityHeatmap
            activity={activity}
            title={t("activity.title")}
            countLabel={(total) => t("activity.count", { count: total })}
          />
        )}

        <TagConfidenceChart data={tagConfidence} failed={failed.has("tags")} onRetry={() => load("tags")} />

        <RecommendationsCard />

        <ReviewHistoryList />
      </div>
    </div>
  );
}
