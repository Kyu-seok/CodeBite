import { useTranslation } from "react-i18next";
import { Star } from "lucide-react";
import { useReviewState } from "@/hooks/useReviewState";
import { badgeDueWording, lastReviewedWording } from "@/lib/dueWording";
import { confidenceTextClass, useConfidenceLabel } from "@/lib/confidenceColors";
import { cn, focusRing } from "@/lib/utils";

interface ReviewBadgeProps {
  slug: string;
  enabled: boolean;
  refreshKey?: unknown;
}

const Sep = () => (
  <span aria-hidden className="text-border">
    ·
  </span>
);

export function ReviewBadge({ slug, enabled }: ReviewBadgeProps) {
  const { t } = useTranslation("common");
  const confidenceLabel = useConfidenceLabel();
  const { state, fetchedAt: now, loading, error, loaded, refetch } = useReviewState(slug, enabled);

  if (!enabled) return null;

  const words = ({ key, ...values }: { key: string; count?: number }) => t(key, values);

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
            <span className="text-foreground">{words(lastReviewedWording(state.lastReviewedAt, now))}</span>
          </span>
          <Sep />
          <span className="inline-flex items-baseline gap-1.5">
            <span className="text-muted-foreground">{t("review.badge.confidence")}</span>
            <span className={cn("font-medium", confidenceTextClass[state.lastConfidence])}>
              {confidenceLabel(state.lastConfidence)}
            </span>
          </span>
          <Sep />
          <span className="font-medium text-foreground">{words(badgeDueWording(state.nextDueAt, state.daysOverdue, now))}</span>
        </>
      ) : (
        <span className="text-muted-foreground">{t("review.badge.empty")}</span>
      )}
    </div>
  );
}
