import StatusBadge from "@/components/ui/StatusBadge"
import type { SubmissionListItem } from "@/types/submission"

interface SubmissionsPanelProps {
  isAuthenticated: boolean
  submissions: SubmissionListItem[]
}

export function SubmissionsPanel({
  isAuthenticated,
  submissions,
}: SubmissionsPanelProps) {
  if (!isAuthenticated) {
    return (
      <div className="p-6">
        <p className="text-sm text-muted-foreground">
          Log in to see submission history
        </p>
      </div>
    )
  }

  if (submissions.length === 0) {
    return (
      <div className="p-6">
        <p className="text-sm text-muted-foreground">No submissions yet</p>
      </div>
    )
  }

  return (
    <div className="p-4 space-y-2">
      {submissions.map((s) => (
        <div
          key={s.id}
          className="flex items-center justify-between rounded-lg bg-muted p-2 text-sm"
        >
          <div className="flex items-center gap-3">
            <StatusBadge status={s.status} />
            <span className="text-muted-foreground">{s.language}</span>
          </div>
          <div className="flex items-center gap-3 text-xs text-muted-foreground">
            {s.runtimeMs != null && <span>{s.runtimeMs}ms</span>}
            {s.memoryKb != null && <span>{s.memoryKb}KB</span>}
            <span>{new Date(s.createdAt).toLocaleString()}</span>
          </div>
        </div>
      ))}
    </div>
  )
}
