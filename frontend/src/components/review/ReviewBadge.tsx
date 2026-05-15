import { useReviewState } from "@/hooks/useReviewState";
import { confidenceLabel, confidenceTextClass } from "@/lib/confidenceColors";

interface ReviewBadgeProps {
  slug: string;
  enabled: boolean;
  refreshKey?: unknown;
}

function relativeFromNow(iso: string): string {
  const target = new Date(iso).getTime();
  const now = Date.now();
  const diffMs = target - now;
  const absDays = Math.floor(Math.abs(diffMs) / (1000 * 60 * 60 * 24));
  if (diffMs < -1000 * 60 * 60 * 24) {
    if (absDays === 1) return "overdue 1d";
    return `overdue ${absDays}d`;
  }
  if (diffMs <= 1000 * 60 * 60 * 24) return "due now";
  if (absDays === 1) return "due tomorrow";
  return `due in ${absDays}d`;
}

function lastReviewedText(iso: string): string {
  const ms = Date.now() - new Date(iso).getTime();
  const days = Math.floor(ms / (1000 * 60 * 60 * 24));
  if (days < 1) return "today";
  if (days === 1) return "yesterday";
  if (days < 30) return `${days}d ago`;
  const months = Math.floor(days / 30);
  return `${months}mo ago`;
}

export function ReviewBadge({ slug, enabled }: ReviewBadgeProps) {
  const { state } = useReviewState(slug, enabled);

  if (!enabled) return null;

  return (
    <div className="flex flex-wrap items-center gap-x-3 gap-y-1 rounded-md border border-border bg-muted/30 px-3 py-1.5 text-xs">
      {state ? (
        <>
          {state.mastered && (
            <>
              <span
                title="Mastered: 3+ reviews, last 2 Good or Easy, interval ≥ 30 days."
                className="font-medium text-success-500"
              >
                ★ Mastered
              </span>
              <span className="text-border">·</span>
            </>
          )}
          <span className="text-muted-foreground">Reviewed:</span>
          <span className="text-foreground">{lastReviewedText(state.lastReviewedAt)}</span>
          <span className="text-border">·</span>
          <span className="text-muted-foreground">Confidence:</span>
          <span className={`font-medium ${confidenceTextClass[state.lastConfidence]}`}>
            {confidenceLabel[state.lastConfidence]}
          </span>
          <span className="text-border">·</span>
          <span className="font-medium text-foreground">
            {relativeFromNow(state.nextDueAt)}
          </span>
        </>
      ) : (
        <span className="text-muted-foreground">No review logged yet — rate a submission to start tracking.</span>
      )}
    </div>
  );
}
