import { confidenceChipClass, confidenceLabel } from "@/lib/confidenceColors";
import type { RatingHistoryItem } from "@/types/review";

interface ProgressionStripProps {
  history: RatingHistoryItem[];
  onPillClick: (submissionId: number) => void;
}

function shortDate(iso: string): string {
  const d = new Date(iso);
  return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
}

function tooltipFor(item: RatingHistoryItem): string {
  const date = new Date(item.reviewedAt).toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
  return `${confidenceLabel[item.confidence]} · ${item.language} · ${item.status} · ${date}`;
}

export function ProgressionStrip({ history, onPillClick }: ProgressionStripProps) {
  if (history.length === 0) return null;

  return (
    <div className="flex flex-wrap items-center gap-x-2 gap-y-1.5 rounded-md border border-border bg-muted/30 px-3 py-2 text-xs">
      <span className="text-muted-foreground">Progression:</span>
      <div className="flex flex-wrap items-center gap-1.5">
        {history.map((item, i) => (
          <div key={item.submissionId} className="flex items-center gap-1.5">
            <button
              type="button"
              onClick={() => onPillClick(item.submissionId)}
              title={tooltipFor(item)}
              className={`inline-flex items-center gap-1 rounded px-1.5 py-0.5 text-[10px] font-medium transition-opacity hover:opacity-80 cursor-pointer ${confidenceChipClass[item.confidence]}`}
            >
              <span>{confidenceLabel[item.confidence]}</span>
              <span className="text-[9px] opacity-70 tabular-nums">{shortDate(item.reviewedAt)}</span>
            </button>
            {i < history.length - 1 && (
              <span aria-hidden className="text-muted-foreground/50">→</span>
            )}
          </div>
        ))}
      </div>
      <span className="ml-auto text-[10px] text-muted-foreground tabular-nums">
        {history.length} {history.length === 1 ? "review" : "reviews"}
      </span>
    </div>
  );
}
