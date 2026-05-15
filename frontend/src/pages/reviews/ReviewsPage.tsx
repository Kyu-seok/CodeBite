import { useEffect, useState } from "react";
import {
  getReviewStats,
  getReviewActivity,
  getTagConfidence,
} from "@/api/reviews";
import type { ReviewStats, TagConfidenceItem } from "@/types/review";
import type { ActivityDay } from "@/types/profile";
import Spinner from "@/components/ui/Spinner";
import { ActivityHeatmap } from "@/pages/profile/ActivityHeatmap";
import { TagConfidenceChart } from "./TagConfidenceChart";
import { RecommendationsCard } from "./RecommendationsCard";
import { ReviewHistoryList } from "./ReviewHistoryList";

function formatDuration(seconds: number): string {
  if (seconds <= 0) return "0m";
  const hours = Math.floor(seconds / 3600);
  const mins = Math.floor((seconds % 3600) / 60);
  if (hours > 0) return mins > 0 ? `${hours}h ${mins}m` : `${hours}h`;
  return `${mins}m`;
}

interface SummaryCardProps {
  label: string;
  value: string;
  hint?: string;
}

function SummaryCard({ label, value, hint }: SummaryCardProps) {
  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <div className="text-xs uppercase tracking-wider text-muted-foreground">{label}</div>
      <div className="mt-2 text-2xl font-semibold text-foreground tabular-nums">{value}</div>
      {hint && <div className="mt-1 text-xs text-muted-foreground">{hint}</div>}
    </div>
  );
}

export default function ReviewsPage() {
  const [stats, setStats] = useState<ReviewStats | null>(null);
  const [activity, setActivity] = useState<ActivityDay[]>([]);
  const [tagConfidence, setTagConfidence] = useState<TagConfidenceItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    document.title = "Reviews | CodeBite";
    Promise.all([getReviewStats(), getReviewActivity(12), getTagConfidence()])
      .then(([statsRes, activityRes, tagRes]) => {
        setStats(statsRes.data);
        setActivity(activityRes.data as ActivityDay[]);
        setTagConfidence(tagRes.data);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

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
          <h1 className="text-2xl font-bold text-foreground">Reviews</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Your spaced-repetition history and progress.
          </p>
        </div>

        <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
          <SummaryCard
            label="Total ratings"
            value={String(stats?.totalReviews ?? 0)}
            hint="Confidence ratings logged across all submissions."
          />
          <SummaryCard
            label="Time invested"
            value={formatDuration(stats?.totalSolveTimeSeconds ?? 0)}
            hint="Sum of solve time across rated submissions."
          />
          <SummaryCard
            label="Current streak"
            value={`${stats?.currentStreak ?? 0}d`}
            hint="Consecutive days with at least one rating."
          />
          <SummaryCard
            label="Longest streak"
            value={`${stats?.longestStreak ?? 0}d`}
            hint="Your best run."
          />
        </div>

        <ActivityHeatmap
          activity={activity}
          title="Review activity"
          countLabel={(total) =>
            `${total} ${total === 1 ? "rating" : "ratings"} in the past year`
          }
        />

        <TagConfidenceChart data={tagConfidence} />

        <RecommendationsCard />

        <ReviewHistoryList />
      </div>
    </div>
  );
}
