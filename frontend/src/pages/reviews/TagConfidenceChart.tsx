import { useTranslation } from "react-i18next";
import type { Confidence, TagConfidenceItem } from "@/types/review";
import { CONFIDENCE_ORDER, useConfidenceLabel } from "@/lib/confidenceColors";
import LoadError from "@/components/ui/LoadError";
import { cn } from "@/lib/utils";

interface TagConfidenceChartProps {
  data: TagConfidenceItem[];
  failed?: boolean;
  onRetry?: () => void;
}

// A rating is a self-assessment, not a judging outcome, so it gets the ink ramp the rating
// prompt uses (#39) rather than red/amber/green (DESIGN.md Outcome-Only Rule): lightest for
// Again, darkest for Easy, flipped on night. Each fill carries a text colour that reads on it.
const segmentClass: Record<Confidence, string> = {
  AGAIN: "bg-primary-100 text-primary-950 dark:bg-primary-800 dark:text-primary-100",
  HARD: "bg-primary-300 text-primary-950 dark:bg-primary-600 dark:text-white",
  GOOD: "bg-primary-500 text-white dark:bg-primary-300 dark:text-primary-950",
  EASY: "bg-primary-800 text-white dark:bg-primary-100 dark:text-primary-950",
};

// Below this share a segment is too narrow to print its count; the row label still has it.
const LABEL_MIN_PCT = 8;

export function TagConfidenceChart({ data, failed, onRetry }: TagConfidenceChartProps) {
  const { t } = useTranslation("reviews");

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex flex-wrap items-baseline justify-between gap-x-4 gap-y-2">
        <h2 className="text-sm font-medium text-foreground">{t("chart.title")}</h2>
        {!failed && data.length > 0 && <Legend />}
      </div>

      {failed ? (
        <LoadError onRetry={onRetry} />
      ) : data.length === 0 ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">{t("chart.empty")}</p>
        </div>
      ) : (
        <ul className="space-y-3">
          {data.map((row) => (
            <TagRow key={row.tagSlug} row={row} />
          ))}
        </ul>
      )}
    </section>
  );
}

function TagRow({ row }: { row: TagConfidenceItem }) {
  const { t } = useTranslation("reviews");
  const confidenceLabel = useConfidenceLabel();
  const total = row.again + row.hard + row.good + row.easy;
  const counts: Record<Confidence, number> = {
    AGAIN: row.again,
    HARD: row.hard,
    GOOD: row.good,
    EASY: row.easy,
  };
  const present = CONFIDENCE_ORDER.filter((c) => counts[c] > 0);
  // Read as one sentence: "Graphs, 8 ratings: Good 6, Easy 2".
  const breakdown = present.map((c) => t("chart.segment", { label: confidenceLabel(c), count: counts[c] })).join(", ");

  return (
    <li>
      <div className="mb-1 flex items-baseline justify-between text-xs">
        <span className="font-medium text-foreground">{row.tagName}</span>
        <span className="tabular-nums text-muted-foreground">{t("chart.ratings", { count: total })}</span>
      </div>
      <span className="sr-only">{breakdown}</span>
      {/* 1px gaps of card background keep neighbouring segments apart without relying on hue. */}
      <div aria-hidden className="flex h-5 w-full gap-px overflow-hidden rounded-md">
        {present.map((c) => {
          const pct = (counts[c] / total) * 100;
          return (
            <div
              key={c}
              className={cn(
                "flex items-center justify-center font-mono text-xs font-medium tabular-nums",
                segmentClass[c],
              )}
              style={{ width: `${pct}%` }}
            >
              {pct >= LABEL_MIN_PCT && counts[c]}
            </div>
          );
        })}
      </div>
    </li>
  );
}

function Legend() {
  const confidenceLabel = useConfidenceLabel();
  return (
    <ul aria-hidden className="flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-muted-foreground">
      {CONFIDENCE_ORDER.map((c) => (
        <li key={c} className="flex items-center gap-1.5">
          <span className={cn("inline-block h-3 w-3 rounded-sm ring-1 ring-border", segmentClass[c])} />
          {confidenceLabel(c)}
        </li>
      ))}
    </ul>
  );
}
