import { useState } from "react"
import { Link } from "react-router-dom"
import { useTranslation } from "react-i18next"
import type { RoadmapCategory } from "@/types/roadmap"
import { TOPOLOGICAL_ORDER } from "./roadmapLayout"
import DifficultyBadge from "@/components/ui/DifficultyBadge"

function CheckIcon() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <polyline points="20 6 9 17 4 12" />
    </svg>
  )
}

function ChevronIcon({ open }: { open: boolean }) {
  return (
    <svg
      width="16" height="16" viewBox="0 0 24 24" fill="none"
      stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
      className={`transition-transform duration-200 ${open ? "rotate-180" : ""}`}
    >
      <polyline points="6 9 12 15 18 9" />
    </svg>
  )
}

interface RoadmapListProps {
  categories: RoadmapCategory[]
}

export default function RoadmapList({ categories }: RoadmapListProps) {
  const { t } = useTranslation("roadmap")
  const [expandedSlug, setExpandedSlug] = useState<string | null>(null)

  const categoryMap = new Map(categories.map((c) => [c.slug, c]))

  const orderedCategories = TOPOLOGICAL_ORDER
    .map((slug) => categoryMap.get(slug))
    .filter((c): c is RoadmapCategory => c != null)

  return (
    <div className="space-y-3">
      {orderedCategories.map((category) => {
        const totalProblems = category.problems.length
        const solvedCount = category.problems.filter((p) => p.status === "SOLVED").length
        const isEmpty = totalProblems === 0
        const isComplete = totalProblems > 0 && solvedCount === totalProblems
        const isExpanded = expandedSlug === category.slug

        return (
          <div
            key={category.slug}
            className={`rounded-lg border bg-card shadow-sm transition-colors
              ${isEmpty ? "border-border/50 opacity-60" : "border-border"}
              ${isComplete ? "border-success-500/50" : ""}
            `}
          >
            <button
              onClick={() => !isEmpty && setExpandedSlug(isExpanded ? null : category.slug)}
              className={`flex w-full items-center gap-3 p-4 text-left ${isEmpty ? "cursor-default" : "cursor-pointer"}`}
            >
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <h3 className="text-sm font-semibold text-foreground">{t(`categories.${category.slug}.name`)}</h3>
                  {isEmpty && (
                    <span className="text-[10px] font-medium uppercase tracking-wider text-muted-foreground/60">
                      {t('comingSoon')}
                    </span>
                  )}
                </div>
                <p className="mt-0.5 text-[11px] text-muted-foreground italic truncate">
                  "{t(`categories.${category.slug}.description`)}"
                </p>
              </div>
              {!isEmpty && (
                <div className="flex items-center gap-3 flex-shrink-0">
                  <span className="text-xs font-medium text-muted-foreground">
                    {solvedCount}/{totalProblems}
                  </span>
                  <ChevronIcon open={isExpanded} />
                </div>
              )}
            </button>

            {isExpanded && totalProblems > 0 && (
              <div className="border-t border-border px-2 py-1">
                {category.problems.map((problem) => (
                  <Link
                    key={problem.id}
                    to={`/problems/${problem.slug}`}
                    className="flex items-center gap-2 rounded-md px-2 py-2 text-sm transition-colors hover:bg-secondary"
                  >
                    <span className={`flex-shrink-0 ${problem.status === "SOLVED" ? "text-success-500" : "text-muted-foreground/30"}`}>
                      {problem.status === "SOLVED" ? (
                        <CheckIcon />
                      ) : (
                        <span className="inline-block h-3.5 w-3.5 rounded-full border-2 border-current" />
                      )}
                    </span>
                    <span className={`flex-1 truncate ${problem.status === "SOLVED" ? "text-muted-foreground" : "text-foreground"}`}>
                      {problem.title}
                    </span>
                    <DifficultyBadge difficulty={problem.difficulty} />
                  </Link>
                ))}
              </div>
            )}
          </div>
        )
      })}
    </div>
  )
}
