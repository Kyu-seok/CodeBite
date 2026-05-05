import { useState } from "react"
import { useNavigate } from "react-router-dom"
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
  const { isAuthenticated } = useAuth()
  const navigate = useNavigate()
  const [pending, setPending] = useState(false)
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
    try {
      const res =
        solution.viewerVote === dir
          ? await clearVote(solution.id)
          : await voteSolution(solution.id, { direction: dir })
      onChange(res.data)
    } catch {
      // ignore
    } finally {
      setPending(false)
    }
  }

  return (
    <div className="inline-flex items-center gap-1 rounded-md border border-border bg-background px-1 py-0.5">
      <Button
        variant="ghost"
        size="icon"
        disabled={pending}
        onClick={() => handleVote("UP")}
        aria-label="Upvote"
        className={cn(
          "h-7 w-7",
          solution.viewerVote === "UP" && "text-success-500",
        )}>
        <ChevronUp className="h-4 w-4" />
      </Button>
      <span className="px-1 text-sm font-semibold tabular-nums">{netScore}</span>
      <Button
        variant="ghost"
        size="icon"
        disabled={pending}
        onClick={() => handleVote("DOWN")}
        aria-label="Downvote"
        className={cn(
          "h-7 w-7",
          solution.viewerVote === "DOWN" && "text-destructive",
        )}>
        <ChevronDown className="h-4 w-4" />
      </Button>
    </div>
  )
}
