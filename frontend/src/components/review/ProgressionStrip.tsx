import { useId } from "react";
import { useTranslation } from "react-i18next";
import { ChevronRight } from "lucide-react";
import { confidenceChipClass, useConfidenceLabel } from "@/lib/confidenceColors";
import { cn, focusRing } from "@/lib/utils";
import { STATUS_KEYS } from "@/pages/problem/submissionDisplay";
import type { RatingHistoryItem } from "@/types/review";
import type { SubmissionStatus } from "@/types/submission";

interface ProgressionStripProps {
  history: RatingHistoryItem[];
  onPillClick: (submissionId: number) => void;
}

export function ProgressionStrip({ history, onPillClick }: ProgressionStripProps) {
  const { t, i18n } = useTranslation("common");
  const confidenceLabel = useConfidenceLabel();
  const labelId = useId();

  if (history.length === 0) return null;

  const shortDate = (iso: string) =>
    new Date(iso).toLocaleDateString(i18n.language, { month: "short", day: "numeric" });
  const fullDate = (iso: string) =>
    new Date(iso).toLocaleString(i18n.language, {
      month: "short",
      day: "numeric",
      year: "numeric",
      hour: "numeric",
      minute: "2-digit",
    });
  const statusLabel = (status: string) => {
    const key = STATUS_KEYS[status as SubmissionStatus];
    return key ? t(key) : status;
  };

  return (
    <div className="flex flex-wrap items-center gap-x-2 gap-y-1.5 rounded-md border border-border bg-muted/30 px-3 py-2 text-xs">
      <span id={labelId} className="text-muted-foreground">
        {t("review.strip.label")}
      </span>
      <ol aria-labelledby={labelId} className="flex min-w-0 flex-wrap items-center gap-1.5">
        {history.map((item, i) => {
          const label = t("review.strip.pill", {
            label: confidenceLabel(item.confidence),
            language: item.language,
            status: statusLabel(item.status),
            date: fullDate(item.reviewedAt),
          });
          return (
            <li key={item.submissionId} className="flex items-center gap-1.5">
              <button
                type="button"
                onClick={() => onPillClick(item.submissionId)}
                title={label}
                aria-label={label}
                className={cn(
                  "inline-flex items-center gap-1 rounded px-1.5 py-0.5 text-xs font-medium transition-opacity hover:opacity-80",
                  focusRing,
                  confidenceChipClass[item.confidence],
                )}
              >
                <span>{confidenceLabel(item.confidence)}</span>
                <span className="font-normal tabular-nums">{shortDate(item.reviewedAt)}</span>
              </button>
              {i < history.length - 1 && (
                <ChevronRight aria-hidden className="h-3 w-3 text-muted-foreground" />
              )}
            </li>
          );
        })}
      </ol>
      <span className="ml-auto text-xs text-muted-foreground tabular-nums">
        {t("review.strip.count", { count: history.length })}
      </span>
    </div>
  );
}
