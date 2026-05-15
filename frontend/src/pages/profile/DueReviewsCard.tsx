import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import DifficultyBadge from "@/components/ui/DifficultyBadge";
import { getDueReviews } from "@/api/reviews";
import { confidenceLabel, confidenceTextClass } from "@/lib/confidenceColors";
import type { DueReviewItem } from "@/types/review";
import type { Difficulty } from "@/types/problem";

function dueText(iso: string, daysOverdue: number): string {
  if (daysOverdue >= 1) {
    return daysOverdue === 1 ? "overdue 1d" : `overdue ${daysOverdue}d`;
  }
  const ms = new Date(iso).getTime() - Date.now();
  if (ms <= 0) return "due now";
  const days = Math.ceil(ms / (1000 * 60 * 60 * 24));
  if (days === 1) return "due today";
  return `due in ${days}d`;
}

export function DueReviewsCard() {
  const [items, setItems] = useState<DueReviewItem[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getDueReviews(0, 5)
      .then((res) => {
        setItems(res.data.content);
        setTotal(res.data.totalElements);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex items-baseline justify-between">
        <h3 className="text-sm font-medium text-foreground">Due for review</h3>
        <div className="flex items-baseline gap-3">
          {total > 0 && (
            <span className="text-xs tabular-nums text-muted-foreground">
              {total} {total === 1 ? "problem" : "problems"}
            </span>
          )}
          <Link
            to="/reviews"
            className="text-xs text-muted-foreground hover:text-accent transition-colors"
          >
            View all →
          </Link>
        </div>
      </div>

      {loading ? (
        <div className="flex h-20 items-center justify-center">
          <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-accent" />
        </div>
      ) : items.length === 0 ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">
            Nothing due — review a solved problem to start the cycle.
          </p>
        </div>
      ) : (
        <div className="space-y-0 divide-y divide-border/50">
          {items.map((it) => (
            <div
              key={it.problemId}
              className="flex items-center justify-between gap-4 py-2.5 first:pt-0 last:pb-0"
            >
              <div className="flex min-w-0 flex-1 items-center gap-3">
                <DifficultyBadge difficulty={it.difficulty as Difficulty} />
                <Link
                  to={`/problems/${it.slug}`}
                  className="truncate text-sm text-foreground hover:text-accent transition-colors"
                >
                  {it.title}
                </Link>
              </div>

              <div className="flex shrink-0 items-center gap-3">
                <span
                  className={`hidden text-xs font-medium sm:block ${confidenceTextClass[it.lastConfidence]}`}
                >
                  {confidenceLabel[it.lastConfidence]}
                </span>
                <span className="w-24 text-right text-xs tabular-nums text-muted-foreground">
                  {dueText(it.nextDueAt, it.daysOverdue)}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
