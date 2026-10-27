import { useTranslation } from "react-i18next";
import type { TFunction } from "i18next";
import { Star } from "lucide-react";
import { useReviewState } from "@/hooks/useReviewState";
import { confidenceTextClass, useConfidenceLabel } from "@/lib/confidenceColors";
import { cn, focusRing } from "@/lib/utils";

interface ReviewBadgeProps {
  slug: string;
  enabled: boolean;
  refreshKey?: unknown;
}

const DAY_MS = 1000 * 60 * 60 * 24;

function dueText(iso: string, t: TFunction): string {
  const diffMs = new Date(iso).getTime() - Date.now();
  const count = Math.floor(Math.abs(diffMs) / DAY_MS);
  if (diffMs < -DAY_MS) return t("review.badge.overdue", { count });
  if (diffMs <= DAY_MS) return t("review.badge.dueNow");
  if (count === 1) return t("review.badge.dueTomorrow");
  return t("review.badge.dueIn", { count });
}

function lastReviewedText(iso: string, t: TFunction): string {
  const days = Math.floor((Date.now() - new Date(iso).getTime()) / DAY_MS);
  if (days < 1) return t("review.badge.today");
  if (days === 1) return t("review.badge.yesterday");
  if (days < 30) return t("review.badge.daysAgo", { count: days });
  return t("review.badge.monthsAgo", { count: Math.floor(days / 30) });
}

const Sep = () => (
  <span aria-hidden className="text-border">
    ·
  </span>
);

export function ReviewBadge({ slug, enabled }: ReviewBadgeProps) {
  const { t } = useTranslation("common");
  const confidenceLabel = useConfidenceLabel();
  const { state, loading, error, loaded, refetch } = useReviewState(slug, enabled);

  if (!enabled) return null;

  const shell =
    "flex min-h-8 flex-wrap items-center gap-x-3 gap-y-1 rounded-md border border-border bg-muted/30 px-3 py-1.5 text-xs";

  if (error) {
    return (
      <div role="alert" className={shell}>
        <span className="text-error-700 dark:text-error-400">{t("review.badge.loadFailed")}</span>
        <button
          type="button"
          onClick={refetch}
          disabled={loading}
          className={cn(
            "rounded-sm font-medium text-accent-700 underline-offset-2 hover:text-accent-800 hover:underline disabled:opacity-50 dark:text-accent-400 dark:hover:text-accent-400",
            focusRing,
          )}
        >
          {t("review.badge.retry")}
        </button>
      </div>
    );
  }

  if (!loaded) {
    return (
      <div role="status" className={shell}>
        <span className="h-3 w-40 max-w-full animate-pulse rounded bg-muted motion-reduce:animate-none" aria-hidden />
        <span className="sr-only">{t("review.badge.loading")}</span>
      </div>
    );
  }

  return (
    <div role="group" aria-label={t("review.badge.label")} className={shell}>
      {state ? (
        <>
          {state.mastered && (
            <>
              <span
                title={t("review.badge.masteredHint")}
                className="inline-flex items-center gap-1 font-medium text-success-700 dark:text-success-400"
              >
                <Star aria-hidden className="h-3 w-3 fill-current" />
                {t("review.badge.mastered")}
                <span className="sr-only">: {t("review.badge.masteredHint")}</span>
              </span>
              <Sep />
            </>
          )}
          <span className="inline-flex items-baseline gap-1.5">
            <span className="text-muted-foreground">{t("review.badge.reviewed")}</span>
            <span className="text-foreground">{lastReviewedText(state.lastReviewedAt, t)}</span>
          </span>
          <Sep />
          <span className="inline-flex items-baseline gap-1.5">
            <span className="text-muted-foreground">{t("review.badge.confidence")}</span>
            <span className={cn("font-medium", confidenceTextClass[state.lastConfidence])}>
              {confidenceLabel(state.lastConfidence)}
            </span>
          </span>
          <Sep />
          <span className="font-medium text-foreground">{dueText(state.nextDueAt, t)}</span>
        </>
      ) : (
        <span className="text-muted-foreground">{t("review.badge.empty")}</span>
      )}
    </div>
  );
}
