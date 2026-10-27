import { useEffect, useId, useRef } from "react"
import { Link } from "react-router-dom"
import { X } from "lucide-react"
import { useTranslation } from "react-i18next"
import type { RoadmapCategory } from "@/types/roadmap"
import { ProblemRow } from "./ProblemRow"

interface ProblemPanelProps {
  category: RoadmapCategory | null
  onClose: () => void
}

export default function ProblemPanel({ category, onClose }: ProblemPanelProps) {
  const { t } = useTranslation("roadmap")
  const headingId = useId()
  const headingRef = useRef<HTMLHeadingElement>(null)
  const isOpen = category !== null

  const solvedCount = category?.problems.filter((p) => p.status === "SOLVED").length ?? 0
  const totalCount = category?.problems.length ?? 0
  const name = category ? t(`categories.${category.slug}.name`) : ""

  // Opening moves focus into the panel, so keyboard users land on what they asked for.
  useEffect(() => {
    if (category) headingRef.current?.focus()
  }, [category])

  return (
    <div
      role={isOpen ? "region" : undefined}
      aria-labelledby={isOpen ? headingId : undefined}
      onKeyDown={(e) => {
        if (e.key === "Escape") {
          e.stopPropagation()
          onClose()
        }
      }}
      className={`absolute right-0 top-0 z-10 h-full w-80 border-l border-border bg-card shadow-lg transition-transform duration-200 motion-reduce:transition-none ${
        isOpen ? "translate-x-0" : "translate-x-full"
      }`}
    >
      {category && (
        <div className="flex h-full flex-col">
          {/* Header */}
          <div className="border-b border-border p-4">
            <div className="flex items-start justify-between gap-2">
              <div className="min-w-0">
                <h2
                  id={headingId}
                  ref={headingRef}
                  tabIndex={-1}
                  className="text-base font-semibold text-foreground outline-none"
                >
                  {name}
                </h2>
                <p className="mt-1 text-xs text-muted-foreground italic">
                  &ldquo;{t(`categories.${category.slug}.description`)}&rdquo;
                </p>
              </div>
              <button
                type="button"
                onClick={onClose}
                aria-label={t("closePanel", { name })}
                className="flex-shrink-0 rounded-md p-1.5 text-muted-foreground hover:bg-secondary hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
              >
                <X aria-hidden className="h-4 w-4" />
              </button>
            </div>
            <div className="mt-3 flex items-center gap-2">
              <div aria-hidden className="h-1.5 flex-1 overflow-hidden rounded-full bg-secondary">
                <div
                  className={`h-full rounded-full transition-all ${
                    solvedCount === totalCount && totalCount > 0 ? "bg-success-500" : "bg-accent-500"
                  }`}
                  style={{ width: totalCount > 0 ? `${(solvedCount / totalCount) * 100}%` : "0%" }}
                />
              </div>
              <span className="text-xs font-medium tabular-nums text-muted-foreground">
                {t("progress", { solved: solvedCount, total: totalCount })}
              </span>
            </div>
          </div>

          {/* Problem list */}
          <ul className="flex-1 overflow-y-auto p-2">
            {category.problems.map((problem) => (
              <li key={problem.id}>
                <Link
                  to={`/problems/${problem.slug}`}
                  className="flex items-center gap-2.5 rounded-md px-2 py-2 text-sm transition-colors hover:bg-secondary"
                >
                  <ProblemRow problem={problem} />
                </Link>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}
