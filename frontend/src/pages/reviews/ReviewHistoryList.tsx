import { useEffect, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import DifficultyBadge from "@/components/ui/DifficultyBadge";
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationPrevious,
  PaginationNext,
} from "@/components/ui/Pagination";
import { getReviewHistoryFiltered } from "@/api/reviews";
import { getTags } from "@/api/tags";
import { confidenceChipClass, confidenceLabel } from "@/lib/confidenceColors";
import type {
  Confidence,
  ReviewHistoryItem,
  ReviewHistoryPage,
} from "@/types/review";
import type { Difficulty, TagDto } from "@/types/problem";

const PAGE_SIZE = 20;

const CONFIDENCES: Confidence[] = ["AGAIN", "HARD", "GOOD", "EASY"];
const DIFFICULTIES: Difficulty[] = ["EASY", "MEDIUM", "HARD"];

function formatDate(iso: string): string {
  return new Date(iso).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
}

function formatSolveTime(seconds: number | null): string {
  if (seconds == null) return "—";
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  if (m > 0) return `${m}m ${s}s`;
  return `${s}s`;
}

interface FilterChipProps<T extends string> {
  label: string;
  value: T | undefined;
  options: T[];
  optionLabel?: (v: T) => string;
  onChange: (v: T | undefined) => void;
}

function FilterChip<T extends string>({
  label,
  value,
  options,
  optionLabel,
  onChange,
}: FilterChipProps<T>) {
  return (
    <div className="flex items-center gap-1.5">
      <span className="text-xs text-muted-foreground">{label}:</span>
      <select
        value={value ?? ""}
        onChange={(e) => onChange((e.target.value || undefined) as T | undefined)}
        className="h-7 rounded-md border border-border bg-background px-2 text-xs text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
      >
        <option value="">Any</option>
        {options.map((opt) => (
          <option key={opt} value={opt}>
            {optionLabel ? optionLabel(opt) : opt}
          </option>
        ))}
      </select>
    </div>
  );
}

export function ReviewHistoryList() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [page, setPage] = useState(0);
  const [confidence, setConfidence] = useState<Confidence | undefined>();
  const [difficulty, setDifficulty] = useState<Difficulty | undefined>();
  const [tag, setTagState] = useState<string | undefined>(
    searchParams.get("tag") || undefined,
  );
  const [data, setData] = useState<ReviewHistoryPage | null>(null);
  const [loading, setLoading] = useState(false);
  const [tags, setTags] = useState<TagDto[]>([]);

  // Keep `tag` in sync with the URL so deep links (e.g. /reviews?tag=dp) work
  // and so changing the dropdown updates the URL for sharing/back-button.
  const setTag = (next: string | undefined) => {
    setTagState(next);
    const sp = new URLSearchParams(searchParams);
    if (next) sp.set("tag", next);
    else sp.delete("tag");
    setSearchParams(sp, { replace: true });
  };

  useEffect(() => {
    getTags()
      .then((res) => setTags(res.data))
      .catch(() => {});
  }, []);

  // Reset to page 0 when filters change.
  useEffect(() => {
    setPage(0);
  }, [confidence, difficulty, tag]);

  useEffect(() => {
    setLoading(true);
    getReviewHistoryFiltered({ confidence, difficulty, tag, page, size: PAGE_SIZE })
      .then((res) => setData(res.data))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [confidence, difficulty, tag, page]);

  const items: ReviewHistoryItem[] = data?.content ?? [];
  const totalPages = data?.totalPages ?? 0;

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex flex-wrap items-baseline justify-between gap-3">
        <h3 className="text-sm font-medium text-foreground">History</h3>
        <div className="flex flex-wrap items-center gap-3">
          <FilterChip
            label="Confidence"
            value={confidence}
            options={CONFIDENCES}
            optionLabel={(v) => confidenceLabel[v]}
            onChange={setConfidence}
          />
          <FilterChip
            label="Difficulty"
            value={difficulty}
            options={DIFFICULTIES}
            onChange={setDifficulty}
          />
          <div className="flex items-center gap-1.5">
            <span className="text-xs text-muted-foreground">Tag:</span>
            <select
              value={tag ?? ""}
              onChange={(e) => setTag(e.target.value || undefined)}
              className="h-7 rounded-md border border-border bg-background px-2 text-xs text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
            >
              <option value="">Any</option>
              {tags.map((t) => (
                <option key={t.slug} value={t.slug}>
                  {t.name}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {loading ? (
        <div className="flex h-20 items-center justify-center">
          <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-accent" />
        </div>
      ) : items.length === 0 ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">
            No ratings match the current filters.
          </p>
        </div>
      ) : (
        <div className="space-y-0 divide-y divide-border/50">
          {items.map((it) => (
            <div
              key={it.submissionId}
              className="flex items-center justify-between gap-4 py-2.5 first:pt-0 last:pb-0"
            >
              <div className="flex min-w-0 flex-1 items-center gap-3">
                <DifficultyBadge difficulty={it.difficulty} />
                <Link
                  to={`/problems/${it.problemSlug}`}
                  className="truncate text-sm text-foreground transition-colors hover:text-accent"
                >
                  {it.problemTitle}
                </Link>
              </div>

              <div className="flex shrink-0 items-center gap-3">
                <span className="hidden text-xs capitalize text-muted-foreground sm:block">
                  {it.language}
                </span>
                <span
                  className={`inline-flex items-center rounded px-1.5 py-0.5 text-[10px] font-medium ${confidenceChipClass[it.confidence]}`}
                >
                  {confidenceLabel[it.confidence]}
                </span>
                <span className="hidden w-16 text-right text-xs tabular-nums text-muted-foreground md:block">
                  {formatSolveTime(it.solveTimeSeconds)}
                </span>
                <span className="w-20 text-right text-xs tabular-nums text-muted-foreground">
                  {formatDate(it.reviewedAt)}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}

      {totalPages > 1 && (
        <div className="mt-4">
          <Pagination>
            <PaginationContent>
              <PaginationItem>
                <PaginationPrevious
                  onClick={() => setPage((p) => Math.max(0, p - 1))}
                  disabled={page === 0}
                />
              </PaginationItem>
              <PaginationItem>
                <span className="px-3 text-xs text-muted-foreground tabular-nums">
                  {page + 1} / {totalPages}
                </span>
              </PaginationItem>
              <PaginationItem>
                <PaginationNext
                  onClick={() => setPage((p) => Math.min(totalPages - 1, p + 1))}
                  disabled={page >= totalPages - 1}
                />
              </PaginationItem>
            </PaginationContent>
          </Pagination>
        </div>
      )}
    </div>
  );
}

