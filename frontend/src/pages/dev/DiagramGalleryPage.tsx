import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getProblem, listProblems } from "@/api/admin";
import type { AdminProblemListItem } from "@/types/admin";
import { useAuth } from "@/context/AuthContext";
import { MarkdownRenderer } from "@/components/markdown/MarkdownRenderer";
import { Button } from "@/components/ui/Button";
import { InlineLoadError } from "@/components/ui/LoadError";
import Spinner from "@/components/ui/Spinner";
import { useDocumentMeta } from "@/hooks/useDocumentMeta";
import { cn } from "@/lib/utils";
import {
  DEFAULT_WIDTH,
  WIDTH_PRESETS,
  diagramParseStatus,
  findDiagramBlocks,
  galleryAccess,
  type DiagramBlock,
  type TileWidth,
} from "./diagramGallery";

/** A problem whose admin detail has arrived, with the Diagrams found in its English description. */
interface LoadedProblem {
  slug: string;
  published: boolean;
  blocks: DiagramBlock[];
}

/** How many admin detail requests are in flight at once. */
const CONCURRENCY = 6;

/**
 * Dev-only (Vite dev mode, see App.tsx): every Diagram of every problem, published or not, on one
 * scroll, each drawn through the same MarkdownRenderer as the problem page at a chosen pane width.
 * Theme comes from the nav's toggle. Needs an ADMIN session, since it reads the admin problem API.
 */
export default function DiagramGalleryPage() {
  useDocumentMeta({ title: "Diagram gallery", noindex: true });
  const { user, loading } = useAuth();
  const access = galleryAccess({ loading, user });

  const [width, setWidth] = useState<TileWidth>(DEFAULT_WIDTH);
  const [problems, setProblems] = useState<AdminProblemListItem[] | null>(null);
  const [loaded, setLoaded] = useState<Record<number, LoadedProblem>>({});
  const [failedSlugs, setFailedSlugs] = useState<string[]>([]);
  const [listError, setListError] = useState<string | null>(null);
  const [attempt, setAttempt] = useState(0);

  useEffect(() => {
    if (access !== "allowed") return;
    let cancelled = false;

    const fetchDetails = async (queue: AdminProblemListItem[]) => {
      while (queue.length > 0 && !cancelled) {
        const problem = queue.shift()!;
        try {
          const res = await getProblem(problem.id);
          if (cancelled) return;
          setLoaded((prev) => ({
            ...prev,
            [problem.id]: {
              slug: res.data.slug,
              published: res.data.published,
              blocks: findDiagramBlocks(res.data.description),
            },
          }));
        } catch {
          if (!cancelled) setFailedSlugs((prev) => [...prev, problem.slug]);
        }
      }
    };

    (async () => {
      const all: AdminProblemListItem[] = [];
      let page = 0;
      let totalPages = 1;
      while (page < totalPages) {
        const res = await listProblems({ page, size: 50 });
        all.push(...res.data.content);
        totalPages = res.data.totalPages;
        page += 1;
      }
      if (cancelled) return;
      all.sort((a, b) => a.id - b.id);
      setProblems(all);
      setLoaded({});
      setFailedSlugs([]);
      setListError(null);
      const queue = [...all];
      await Promise.all(Array.from({ length: CONCURRENCY }, () => fetchDetails(queue)));
    })().catch((e: unknown) => {
      if (!cancelled) setListError(e instanceof Error ? e.message : String(e));
    });

    return () => {
      cancelled = true;
    };
  }, [access, attempt]);

  if (access === "loading") return <Spinner />;

  if (access === "denied") {
    return (
      <div className="mx-auto max-w-2xl px-4 py-12">
        <h1 className="mb-3 text-xl font-semibold text-foreground">Diagram gallery</h1>
        <p className="text-sm text-muted-foreground">
          This page reads the admin problem list, so it needs an ADMIN session. On the dev backend,{" "}
          <code className="rounded bg-muted px-1 py-0.5 text-xs">POST /api/auth/test-token?username=&lt;name&gt;&amp;role=ADMIN</code>{" "}
          returns a JWT; store it in localStorage under <code className="rounded bg-muted px-1 py-0.5 text-xs">token</code> and reload.
        </p>
      </div>
    );
  }

  const loadedCount = Object.keys(loaded).length;
  const tiles = (problems ?? []).flatMap((p) => {
    const detail = loaded[p.id];
    return detail ? detail.blocks.map((block, i) => ({ key: `${p.id}-${i}`, ...detail, block })) : [];
  });

  return (
    <div className="px-4 py-6 sm:px-6">
      <div className="mb-6 flex flex-wrap items-center gap-x-6 gap-y-3">
        <h1 className="text-xl font-semibold text-foreground">Diagram gallery</h1>
        <p className="text-sm text-muted-foreground" aria-live="polite">
          {problems === null
            ? "Loading the problem list…"
            : `${loadedCount} of ${problems.length} problems loaded · ${tiles.length} Diagrams`}
        </p>
        <div role="group" aria-label="Tile width" className="ml-auto flex items-center gap-1">
          {WIDTH_PRESETS.map((preset) => (
            <Button
              key={preset}
              size="sm"
              variant={preset === width ? "default" : "outline"}
              aria-pressed={preset === width}
              onClick={() => setWidth(preset)}
            >
              {preset}px
            </Button>
          ))}
        </div>
      </div>

      {listError && (
        <InlineLoadError message={`The problem list failed to load: ${listError}`} onRetry={() => setAttempt((n) => n + 1)} />
      )}
      {failedSlugs.length > 0 && (
        <InlineLoadError
          message={`${failedSlugs.length} problem detail${failedSlugs.length === 1 ? "" : "s"} failed to load: ${failedSlugs.join(", ")}`}
          onRetry={() => setAttempt((n) => n + 1)}
        />
      )}

      <ul className="flex flex-wrap gap-6">
        {tiles.map(({ key, slug, published, block }) => {
          const status = diagramParseStatus(block);
          return (
            <li key={key} style={{ width }} className="max-w-full rounded-lg border border-border bg-card p-3">
              <div className="mb-2 flex flex-wrap items-baseline gap-x-2 text-sm">
                <Link to={`/problems/${slug}`} className="font-medium text-accent-700 hover:underline dark:text-accent-400">
                  {slug}
                </Link>
                <span className="text-muted-foreground">
                  {block.example === null ? "no example" : `Example ${block.example}`} · {block.kind}
                </span>
                {!published && (
                  <span className="rounded bg-muted px-1.5 py-0.5 text-xs text-muted-foreground">unpublished</span>
                )}
              </div>
              {!status.ok && (
                <p role="alert" className="mb-2 text-xs text-error-700 dark:text-error-400">
                  Does not parse, so the raw block shows: {status.message}
                </p>
              )}
              {/* The same renderer as the problem page: a block that fails to parse shows as raw text. */}
              <MarkdownRenderer source={block.source} className={cn(!status.ok && "opacity-90")} />
            </li>
          );
        })}
      </ul>
    </div>
  );
}
