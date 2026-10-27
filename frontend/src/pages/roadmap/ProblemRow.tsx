import { Check } from "lucide-react"
import { useTranslation } from "react-i18next"
import DifficultyBadge from "@/components/ui/DifficultyBadge"
import type { RoadmapCategory } from "@/types/roadmap"

/** A problem's solved mark, title and difficulty, as the panel and the list both show it. */
export function ProblemRow({ problem }: { problem: RoadmapCategory["problems"][number] }) {
  const { t } = useTranslation("roadmap")
  const solved = problem.status === "SOLVED"
  return (
    <>
      <span aria-hidden className={`flex-shrink-0 ${solved ? "text-success-500" : "text-muted-foreground/40"}`}>
        {solved ? (
          <Check className="h-4 w-4" strokeWidth={2.5} />
        ) : (
          <span className="inline-block h-3.5 w-3.5 rounded-full border-2 border-current" />
        )}
      </span>
      <span className={`flex-1 truncate ${solved ? "text-muted-foreground" : "text-foreground"}`}>
        {problem.title}
        {/* The check is a picture; say it in words too. */}
        <span className="sr-only">, {solved ? t("solved") : t("notSolved")}</span>
      </span>
      <DifficultyBadge difficulty={problem.difficulty} />
    </>
  )
}
