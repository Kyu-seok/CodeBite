import { useCallback, useEffect, useId, useRef, useState } from "react";
import { Link, useLocation, useSearchParams } from "react-router-dom";
import { useTranslation } from "react-i18next";
import DifficultyBadge from "@/components/ui/DifficultyBadge";
import Spinner from "@/components/ui/Spinner";
import LoadError from "@/components/ui/LoadError";
import { Button } from "@/components/ui/Button";
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationPrevious,
  PaginationNext,
} from "@/components/ui/Pagination";
import { getReviewHistoryFiltered } from "@/api/reviews";
import { getTags } from "@/api/tags";
import { CONFIDENCE_ORDER, useConfidenceLabel } from "@/lib/confidenceColors";
import type { Confidence, ReviewHistoryPage } from "@/types/review";
import type { Difficulty, TagDto } from "@/types/problem";
import { formatSolveTime } from "./formatDuration";

const PAGE_SIZE = 20;

const DIFFICULTIES: Difficulty[] = ["EASY", "MEDIUM", "HARD"];

interface FilterSelectProps<T extends string> {
  label: string;
  value: T | undefined;
  options: T[];
  optionLabel: (v: T) => string;
  onChange: (v: T | undefined) => void;
}

function FilterSelect<T extends string>({ label, value, options, optionLabel, onChange }: FilterSelectProps<T>) {
  const { t } = useTranslation("reviews");
  const id = useId();
  return (
    <div className="flex items-center gap-1.5">
      <label htmlFor={id} className="text-xs text-muted-foreground">
        {label}
      </label>
      <select
        id={id}
        value={value ?? ""}
        onChange={(e) => onChange((e.target.value || undefined) as T | undefined)}
        className="h-8 rounded-md border border-border bg-background px-2 text-xs text-foreground focus:outline-none focus-visible:ring-2 focus-visible:ring-ring"
      >
        <option value="">{t("history.any")}</option>
        {options.map((opt) => (
          <option key={opt} value={opt}>
            {optionLabel(opt)}
          </option>
        ))}
      </select>
    </div>
  );
}

export function ReviewHistoryList() {
  const { t, i18n } = useTranslation("reviews");
  const { t: tc } = useTranslation("common");
  const confidenceLabel = useConfidenceLabel();
  const location = useLocation();
  const [searchParams, setSearchParams] = useSearchParams();
  // The URL owns the tag filter, so a "Weakest categories" link on this same page applies it.
  const tag = searchParams.get("tag") || undefined;
  const [page, setPage] = useState(0);
  const [confidence, setConfidence] = useState<Confidence | undefined>();
  const [difficulty, setDifficulty] = useState<Difficulty | undefined>();
  const [data, setData] = useState<ReviewHistoryPage | null>(null);
  const [status, setStatus] = useState<"loading" | "ready" | "failed">("loading");
  const [tags, setTags] = useState<TagDto[]>([]);
  const [tagsFailed, setTagsFailed] = useState(false);
  const [lastTag, setLastTag] = useState(tag);
  // Which filters the rows on screen belong to; while it differs from the current ones the
  // previous rows stay, dimmed and marked busy, instead of collapsing to a spinner.
  const requestKey = `${confidence}|${difficulty}|${tag}|${page}`;
  const [shownKey, setShownKey] = useState<string | null>(null);
  const headingRef = useRef<HTMLHeadingElement>(null);

  // A tag picked from outside (a link) starts the list over, like the selects below do.
  if (tag !== lastTag) {
    setLastTag(tag);
    setPage(0);
  }

  const setTag = (next: string | undefined) => {
    const sp = new URLSearchParams(searchParams);
    if (next) sp.set("tag", next);
    else sp.delete("tag");
    setSearchParams(sp, { replace: true });
  };

  const fetchTags = useCallback(() => {
    getTags()
      .then((res) => setTags(res.data))
      .catch(() => setTagsFailed(true));
  }, []);

  useEffect(fetchTags, [fetchTags]);

  // isCurrent drops a response that lands after the filters have moved on, so an older page
  // can't replace a newer one (and leave the list marked busy).
  const fetchPage = useCallback(
    (isCurrent: () => boolean = () => true) => {
      getReviewHistoryFiltered({ confidence, difficulty, tag, page, size: PAGE_SIZE })
        .then((res) => {
          if (!isCurrent()) return;
          setData(res.data);
          setShownKey(requestKey);
          setStatus("ready");
        })
        .catch(() => {
          if (isCurrent()) setStatus("failed");
        });
    },
    [confidence, difficulty, tag, page, requestKey],
  );

  useEffect(() => {
    let current = true;
    fetchPage(() => current);
    return () => {
      current = false;
    };
  }, [fetchPage]);

  // Arriving from a "Weakest categories" link: bring the filtered list into view and focus.
  useEffect(() => {
    if ((location.state as { focusHistory?: boolean } | null)?.focusHistory) {
      headingRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
      headingRef.current?.focus({ preventScroll: true });
    }
  }, [location.key, location.state]);

  const retry = () => {
    setStatus("loading");
    fetchPage();
  };

  const filtered = Boolean(confidence || difficulty || tag);
  const clearFilters = () => {
    setConfidence(undefined);
    setDifficulty(undefined);
    setPage(0);
    setTag(undefined);
  };

  const tagName = (slug: string) => tags.find((tg) => tg.slug === slug)?.name ?? slug;
  const items = data?.content ?? [];
  const totalPages = data?.totalPages ?? 0;
  const formatDate = (iso: string) =>
    new Date(iso).toLocaleDateString(i18n.language, { month: "short", day: "numeric", year: "numeric" });

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <h2 ref={headingRef} tabIndex={-1} className="scroll-mt-20 text-sm font-medium text-foreground outline-none">
          {t("history.title")}
        </h2>
        <div className="flex flex-wrap items-center gap-3">
          <FilterSelect
            label={t("history.confidence")}
            value={confidence}
            options={[...CONFIDENCE_ORDER]}
            optionLabel={confidenceLabel}
            onChange={(v) => {
              setConfidence(v);
              setPage(0);
            }}
          />
          <FilterSelect
            label={t("history.difficulty")}
            value={difficulty}
            options={DIFFICULTIES}
            optionLabel={(v) => tc(`difficulty.${v.toLowerCase()}`)}
            onChange={(v) => {
              setDifficulty(v);
              setPage(0);
            }}
          />
          <FilterSelect
            label={t("history.tag")}
            value={tag}
            options={tags.map((tg) => tg.slug)}
            optionLabel={tagName}
            onChange={setTag}
          />
        </div>
      </div>

      {tagsFailed && (
        <p role="alert" className="mb-3 flex items-center gap-2 text-xs text-muted-foreground">
          {t("history.tagsFailed")}
          <Button size="sm" variant="link" className="h-auto p-0 text-xs" onClick={() => {
              setTagsFailed(false);
              fetchTags();
            }}>
            {tc("loadError.retry")}
          </Button>
        </p>
      )}
      {/* Says which tag a "Weakest categories" link applied; the focused heading alone reads "History". */}
      <p role="status" className="sr-only">
        {tag ? t("history.filteredByTag", { tag: tagName(tag) }) : ""}
      </p>

      {status === "failed" ? (
        <LoadError onRetry={retry} />
      ) : status === "loading" && !data ? (
        <Spinner size="sm" className="h-20 p-0" />
      ) : items.length === 0 ? (
        <div className="flex h-20 flex-col items-center justify-center gap-2 text-center">
          <p className="text-sm text-muted-foreground">{filtered ? t("history.empty") : t("history.noRatings")}</p>
          {filtered && (
            <Button size="sm" variant="outline" onClick={clearFilters}>
              {t("history.clearFilters")}
            </Button>
          )}
        </div>
      ) : (
        <ul
          aria-busy={shownKey !== requestKey}
          className="space-y-0 divide-y divide-border/50 transition-opacity aria-busy:opacity-60"
        >
          {items.map((it) => (
            <li
              key={it.submissionId}
              className="flex items-center justify-between gap-4 py-2.5 first:pt-0 last:pb-0"
            >
              <div className="flex min-w-0 flex-1 items-center gap-3">
                <DifficultyBadge difficulty={it.difficulty} />
                <Link
                  to={`/problems/${it.problemSlug}`}
                  className="truncate rounded-sm text-sm text-foreground transition-colors hover:text-accent-700 dark:hover:text-accent-400"
                >
                  {it.problemTitle}
                </Link>
              </div>

              <div className="flex shrink-0 items-center gap-3">
                <span className="hidden text-xs capitalize text-muted-foreground sm:block">
                  {it.language}
                </span>
                <span className="inline-flex items-center rounded bg-secondary px-1.5 py-0.5 text-xs font-medium text-secondary-foreground">
                  {confidenceLabel(it.confidence)}
                </span>
                <span className="hidden w-16 text-right font-mono text-xs tabular-nums text-muted-foreground md:block">
                  {it.solveTimeSeconds == null ? "—" : formatSolveTime(it.solveTimeSeconds, i18n.language)}
                </span>
                <span className="min-w-20 text-right text-xs tabular-nums text-muted-foreground">
                  {formatDate(it.reviewedAt)}
                </span>
              </div>
            </li>
          ))}
        </ul>
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
                  {t("history.page", { page: page + 1, total: totalPages })}
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
    </section>
  );
}
