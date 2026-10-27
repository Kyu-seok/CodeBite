import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { ChevronUp, ChevronDown } from "lucide-react"
import { Button } from "@/components/ui/Button"
import { useAuth } from "@/context/AuthContext"
import { clearVote, voteSolution } from "@/api/solutions"
import type { SolutionDetail, VoteDirection, VoteResponse } from "@/types/solution"
import { cn } from "@/lib/utils"

interface VoteBarProps {
  solution: SolutionDetail
  onChange: (next: Pick<VoteResponse, "viewerVote" | "upvotesCount" | "downvotesCount">) => void
  slug: string
}

export function VoteBar({ solution, onChange, slug }: VoteBarProps) {
  const { t } = useTranslation("problem")
  const { isAuthenticated } = useAuth()
  const navigate = useNavigate()
  const [pending, setPending] = useState(false)
  const [failed, setFailed] = useState(false)
  const netScore = solution.upvotesCount - solution.downvotesCount

  const requireAuth = () => {
    sessionStorage.setItem("returnUrl", `/problems/${slug}/solutions/${solution.id}`)
    navigate("/login")
  }

  const handleVote = async (dir: VoteDirection) => {
    if (!isAuthenticated) {
      requireAuth()
      return
    }
    if (pending) return
    setPending(true)
    setFailed(false)
    try {
      const res =
        solution.viewerVote === dir
          ? await clearVote(solution.id)
          : await voteSolution(solution.id, { direction: dir })
      onChange(res.data)
    } catch {
      setFailed(true)
    } finally {
      setPending(false)
    }
  }

  // The viewer's own vote is the current selection, so it takes the accent (One Ember rule).
  const selectedClass = "text-accent-700 dark:text-accent-400"
  return (
    <div className="flex shrink-0 flex-col items-end">
      <div className="inline-flex items-center gap-1 rounded-md border border-border bg-background px-1 py-0.5">
        <Button
          variant="ghost"
          size="icon"
          disabled={pending}
          onClick={() => handleVote("UP")}
          aria-label={t("solutions.upvote")}
          aria-pressed={solution.viewerVote === "UP"}
          className={cn("h-7 w-7", solution.viewerVote === "UP" && selectedClass)}>
          <ChevronUp className="h-4 w-4" />
        </Button>
        <span className="px-1 font-mono text-sm font-semibold tabular-nums">
          <span className="sr-only">{t("solutions.score", { n: netScore })}</span>
          <span aria-hidden="true">{netScore}</span>
        </span>
        <Button
          variant="ghost"
          size="icon"
          disabled={pending}
          onClick={() => handleVote("DOWN")}
          aria-label={t("solutions.downvote")}
          aria-pressed={solution.viewerVote === "DOWN"}
          className={cn("h-7 w-7", solution.viewerVote === "DOWN" && selectedClass)}>
          <ChevronDown className="h-4 w-4" />
        </Button>
      </div>
      {failed && (
        <p role="alert" className="mt-1 max-w-48 text-right text-xs text-destructive">
          {t("solutions.voteFailed")}
        </p>
      )}
    </div>
  )
}
