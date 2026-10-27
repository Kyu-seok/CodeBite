import { useId, useState } from "react"
import { Link } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { ChevronDown } from "lucide-react"
import type { RoadmapCategory } from "@/types/roadmap"
import { TOPOLOGICAL_ORDER } from "./roadmapLayout"
import { ProblemRow } from "./ProblemRow"

interface RoadmapListProps {
  categories: RoadmapCategory[]
}

export default function RoadmapList({ categories }: RoadmapListProps) {
  const { t } = useTranslation("roadmap")
  const [expandedSlug, setExpandedSlug] = useState<string | null>(null)
  const idPrefix = useId()

  const categoryMap = new Map(categories.map((c) => [c.slug, c]))

  // Prerequisite order, so the list keeps the graph's "learn this first" meaning.
  const orderedCategories = TOPOLOGICAL_ORDER
    .map((slug) => categoryMap.get(slug))
    .filter((c): c is RoadmapCategory => c != null)

  return (
    <ol className="space-y-3">
      {orderedCategories.map((category) => {
        const totalProblems = category.problems.length
        const solvedCount = category.problems.filter((p) => p.status === "SOLVED").length
        const isEmpty = totalProblems === 0
        const isComplete = totalProblems > 0 && solvedCount === totalProblems
        const isExpanded = expandedSlug === category.slug
        const panelId = `${idPrefix}-${category.slug}`

        return (
          <li
            key={category.slug}
            className={`rounded-lg border bg-card shadow-sm transition-colors
              ${isEmpty ? "border-dashed border-border" : isComplete ? "border-success-500/50" : "border-border"}
            `}
          >
            {/* The heading wraps the toggle, so it stays a heading and the button stays a button. */}
            <h2 className="text-sm">
              <button
                type="button"
                disabled={isEmpty}
                aria-expanded={isEmpty ? undefined : isExpanded}
                aria-controls={isEmpty ? undefined : panelId}
                onClick={() => setExpandedSlug(isExpanded ? null : category.slug)}
                className="flex w-full items-center gap-3 rounded-lg p-4 text-left focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:cursor-default"
              >
                <span className="min-w-0 flex-1">
                  <span className="flex items-center gap-2">
                    <span className={`font-semibold ${isEmpty ? "text-muted-foreground" : "text-foreground"}`}>
                      {t(`categories.${category.slug}.name`)}
                    </span>
                    {isEmpty && (
                      <span className="text-xs font-medium text-muted-foreground">{t("comingSoon")}</span>
                    )}
                  </span>
                  <span className="mt-0.5 block truncate text-xs font-normal italic text-muted-foreground">
                    &ldquo;{t(`categories.${category.slug}.description`)}&rdquo;
                  </span>
                </span>
                {!isEmpty && (
                  <span className="flex flex-shrink-0 items-center gap-3">
                    <span className="text-xs font-medium tabular-nums text-muted-foreground">
                      <span aria-hidden>
                        {solvedCount}/{totalProblems}
                      </span>
                      <span className="sr-only">{t("progress", { solved: solvedCount, total: totalProblems })}</span>
                    </span>
                    <ChevronDown
                      aria-hidden
                      className={`h-4 w-4 text-muted-foreground transition-transform duration-200 motion-reduce:transition-none ${isExpanded ? "rotate-180" : ""}`}
                    />
                  </span>
                )}
              </button>
            </h2>

            {isExpanded && (
              <ul id={panelId} className="border-t border-border px-2 py-1">
                {category.problems.map((problem) => (
                  <li key={problem.id}>
                    <Link
                      to={`/problems/${problem.slug}`}
                      className="flex items-center gap-2 rounded-md px-2 py-2 text-sm transition-colors hover:bg-secondary"
                    >
                      <ProblemRow problem={problem} />
                    </Link>
                  </li>
                ))}
              </ul>
            )}
          </li>
        )
      })}
    </ol>
  )
}
