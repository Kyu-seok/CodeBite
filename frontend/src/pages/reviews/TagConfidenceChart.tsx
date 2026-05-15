import type { Confidence, TagConfidenceItem } from "@/types/review";
import { confidenceLabel } from "@/lib/confidenceColors";

interface TagConfidenceChartProps {
  data: TagConfidenceItem[];
}

// Solid background colors for the stacked-bar segments. We don't reuse the
// `bg-…/15` chips here because we want full opacity for legibility in the bar.
const segmentBg: Record<Confidence, string> = {
  AGAIN: "bg-destructive",
  HARD: "bg-warning-500",
  GOOD: "bg-accent-500",
  EASY: "bg-success-500",
};

const ORDER: Confidence[] = ["AGAIN", "HARD", "GOOD", "EASY"];

export function TagConfidenceChart({ data }: TagConfidenceChartProps) {
  const empty = data.length === 0;

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex items-baseline justify-between">
        <h3 className="text-sm font-medium text-foreground">Confidence by tag</h3>
        <Legend />
      </div>

      {empty ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">
            Rate a few submissions to see your tag breakdown.
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          {data.map((row) => (
            <TagRow key={row.tagSlug} row={row} />
          ))}
        </div>
      )}
    </div>
  );
}

function TagRow({ row }: { row: TagConfidenceItem }) {
  const total = row.again + row.hard + row.good + row.easy;
  const counts: Record<Confidence, number> = {
    AGAIN: row.again,
    HARD: row.hard,
    GOOD: row.good,
    EASY: row.easy,
  };

  return (
    <div>
      <div className="mb-1 flex items-baseline justify-between text-xs">
        <span className="font-medium text-foreground">{row.tagName}</span>
        <span className="tabular-nums text-muted-foreground">
          {total} {total === 1 ? "rating" : "ratings"}
        </span>
      </div>
      <div className="flex h-5 w-full overflow-hidden rounded-md bg-muted/40">
        {ORDER.map((c) => {
          const count = counts[c];
          if (count === 0) return null;
          const pct = (count / total) * 100;
          return (
            <div
              key={c}
              className={`${segmentBg[c]} transition-opacity hover:opacity-80`}
              style={{ width: `${pct}%` }}
              title={`${confidenceLabel[c]}: ${count} (${pct.toFixed(0)}%)`}
            />
          );
        })}
      </div>
    </div>
  );
}

function Legend() {
  return (
    <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-[10px] text-muted-foreground">
      {ORDER.map((c) => (
        <div key={c} className="flex items-center gap-1">
          <span className={`inline-block h-2.5 w-2.5 rounded-sm ${segmentBg[c]}`} />
          <span>{confidenceLabel[c]}</span>
        </div>
      ))}
    </div>
  );
}
