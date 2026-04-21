import { Link } from "react-router-dom"
import { X, Check } from "lucide-react"
import { useTranslation } from "react-i18next"
import type { RoadmapCategory } from "@/types/roadmap"
import DifficultyBadge from "@/components/ui/DifficultyBadge"

interface ProblemPanelProps {
  category: RoadmapCategory | null
  onClose: () => void
}

export default function ProblemPanel({ category, onClose }: ProblemPanelProps) {
  const { t } = useTranslation("roadmap")
  const isOpen = category !== null

  const solvedCount = category?.problems.filter((p) => p.status === "SOLVED").length ?? 0
  const totalCount = category?.problems.length ?? 0

  return (
    <div
      className={`absolute right-0 top-0 z-10 h-full w-80 border-l border-border bg-card shadow-lg transition-transform duration-200 ${
        isOpen ? "translate-x-0" : "translate-x-full"
      }`}
    >
      {category && (
        <div className="flex h-full flex-col">
          {/* Header */}
          <div className="border-b border-border p-4">
            <div className="flex items-start justify-between gap-2">
              <div className="min-w-0">
                <h2 className="text-base font-semibold text-foreground">
                  {t(`categories.${category.slug}.name`)}
                </h2>
                <p className="mt-1 text-xs text-muted-foreground italic">
                  &ldquo;{t(`categories.${category.slug}.description`)}&rdquo;
                </p>
              </div>
              <button
                onClick={onClose}
                className="flex-shrink-0 rounded-md p-1 text-muted-foreground hover:bg-secondary hover:text-foreground"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
            <div className="mt-3 flex items-center gap-2">
              <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-secondary">
                <div
                  className={`h-full rounded-full transition-all ${
                    solvedCount === totalCount && totalCount > 0 ? "bg-success-500" : "bg-accent-500"
                  }`}
                  style={{ width: totalCount > 0 ? `${(solvedCount / totalCount) * 100}%` : "0%" }}
                />
              </div>
              <span className="text-xs font-medium text-muted-foreground">
                {solvedCount} / {totalCount}
              </span>
            </div>
          </div>

          {/* Problem list */}
          <div className="flex-1 overflow-y-auto p-2">
            {category.problems.map((problem) => (
              <Link
                key={problem.id}
                to={`/problems/${problem.slug}`}
                className="flex items-center gap-2.5 rounded-md px-2 py-2 text-sm transition-colors hover:bg-secondary"
              >
                <span
                  className={`flex-shrink-0 ${
                    problem.status === "SOLVED" ? "text-success-500" : "text-muted-foreground/30"
                  }`}
                >
                  {problem.status === "SOLVED" ? (
                    <Check className="h-4 w-4" />
                  ) : (
                    <span className="inline-block h-3.5 w-3.5 rounded-full border-2 border-current" />
                  )}
                </span>
                <span
                  className={`flex-1 truncate ${
                    problem.status === "SOLVED" ? "text-muted-foreground" : "text-foreground"
                  }`}
                >
                  {problem.title}
                </span>
                <DifficultyBadge difficulty={problem.difficulty} />
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
