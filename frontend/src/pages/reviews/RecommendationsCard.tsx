import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import DifficultyBadge from "@/components/ui/DifficultyBadge";
import {
  getWeakTags,
  getRoadmapNext,
  type WeakCategoryItem,
  type RoadmapNextItem,
} from "@/api/recommendations";

// Map a numeric average (1..4) to a label + color matching the confidence palette.
function avgLabel(avg: number): { label: string; className: string } {
  if (avg < 1.5) return { label: "Again", className: "text-destructive" };
  if (avg < 2.5) return { label: "Hard", className: "text-warning-500" };
  if (avg < 3.5) return { label: "Good", className: "text-accent-500" };
  return { label: "Easy", className: "text-success-500" };
}

export function RecommendationsCard() {
  const [weak, setWeak] = useState<WeakCategoryItem[]>([]);
  const [next, setNext] = useState<RoadmapNextItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([getWeakTags(3), getRoadmapNext()])
      .then(([w, n]) => {
        setWeak(w.data);
        setNext(n.data);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  const empty = !loading && weak.length === 0 && next.length === 0;

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <h3 className="mb-4 text-sm font-medium text-foreground">Recommendations</h3>

      {loading ? (
        <div className="flex h-20 items-center justify-center">
          <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-accent" />
        </div>
      ) : empty ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">
            Rate a few submissions and we'll start suggesting what to revisit.
          </p>
        </div>
      ) : (
        <div className="space-y-5">
          {weak.length > 0 && (
            <section>
              <h4 className="mb-2 text-xs font-medium uppercase tracking-wider text-muted-foreground">
                Weakest categories
              </h4>
              <div className="space-y-2">
                {weak.map((w) => {
                  const a = avgLabel(w.avgConfidence);
                  return (
                    <Link
                      key={w.tagSlug}
                      to={`/reviews?tag=${w.tagSlug}`}
                      className="flex items-center justify-between rounded-md border border-border bg-background px-3 py-2 text-sm transition-colors hover:bg-muted/50"
                    >
                      <span className="font-medium text-foreground">{w.tagName}</span>
                      <span className="flex items-center gap-3 text-xs">
                        <span className={`font-medium ${a.className}`}>avg {a.label}</span>
                        <span className="tabular-nums text-muted-foreground">
                          {w.ratedSubmissionCount} {w.ratedSubmissionCount === 1 ? "rating" : "ratings"}
                        </span>
                      </span>
                    </Link>
                  );
                })}
              </div>
            </section>
          )}

          {next.length > 0 && (
            <section>
              <h4 className="mb-2 text-xs font-medium uppercase tracking-wider text-muted-foreground">
                Roadmap next
              </h4>
              <div className="space-y-2">
                {next.slice(0, 3).map((cat) => (
                  <div
                    key={cat.categorySlug}
                    className="rounded-md border border-border bg-background px-3 py-2"
                  >
                    <div className="text-sm font-medium text-foreground">{cat.categoryName}</div>
                    {cat.description && (
                      <div className="mt-0.5 text-xs text-muted-foreground">{cat.description}</div>
                    )}
                    {cat.unsolvedProblems.length > 0 && (
                      <div className="mt-2 flex flex-wrap items-center gap-2">
                        {cat.unsolvedProblems.map((p) => (
                          <Link
                            key={p.slug}
                            to={`/problems/${p.slug}`}
                            className="inline-flex items-center gap-1.5 rounded border border-border px-2 py-0.5 text-xs text-foreground transition-colors hover:bg-muted/50"
                          >
                            <DifficultyBadge difficulty={p.difficulty} />
                            <span className="truncate max-w-[12rem]">{p.title}</span>
                          </Link>
                        ))}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </section>
          )}
        </div>
      )}
    </div>
  );
}
