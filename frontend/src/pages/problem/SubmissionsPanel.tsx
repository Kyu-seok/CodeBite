import { useState } from "react"
import { Badge } from "@/components/ui/Badge"
import { Button } from "@/components/ui/Button"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/Dialog"
import type { SubmissionListItem, SubmissionStatus } from "@/types/submission"

const statusColorMap: Record<SubmissionStatus, string> = {
  ACCEPTED: "text-success-500",
  WRONG_ANSWER: "text-destructive",
  RUNTIME_ERROR: "text-destructive",
  TIME_LIMIT_EXCEEDED: "text-warning-500",
  COMPILATION_ERROR: "text-warning-500",
  PENDING: "text-muted-foreground",
  INTERNAL_ERROR: "text-muted-foreground",
}

const statusLabels: Record<SubmissionStatus, string> = {
  ACCEPTED: "Accepted",
  WRONG_ANSWER: "Wrong Answer",
  TIME_LIMIT_EXCEEDED: "Time Limit Exceeded",
  RUNTIME_ERROR: "Runtime Error",
  COMPILATION_ERROR: "Compile Error",
  PENDING: "Pending",
  INTERNAL_ERROR: "Internal Error",
}

function formatDate(dateStr: string) {
  const d = new Date(dateStr)
  return d.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  })
}

function formatMemory(kb: number) {
  return `${(kb / 1024).toFixed(1)} MB`
}

function NoteModal({
  open,
  value,
  onClose,
  onSave,
}: {
  open: boolean
  value: string | null
  onClose: () => void
  onSave: (notes: string) => void
}) {
  const [draft, setDraft] = useState("")

  return (
    <Dialog
      open={open}
      onOpenChange={(isOpen) => {
        if (isOpen) setDraft(value || "")
        else onClose()
      }}
    >
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>Notes</DialogTitle>
          <DialogDescription className="sr-only">
            Add or edit a note for this submission
          </DialogDescription>
        </DialogHeader>
        <textarea
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          maxLength={500}
          rows={5}
          placeholder="Write your note here..."
          className="mt-2 w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
        />
        <div className="mt-4 flex justify-end gap-2">
          <Button variant="outline" size="sm" onClick={onClose}>
            Cancel
          </Button>
          <Button
            size="sm"
            onClick={() => {
              onSave(draft)
              onClose()
            }}
          >
            Save
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  )
}

interface SubmissionsPanelProps {
  isAuthenticated: boolean
  submissions: SubmissionListItem[]
  onUpdateNote?: (id: number, notes: string) => void
}

export function SubmissionsPanel({
  isAuthenticated,
  submissions,
  onUpdateNote,
}: SubmissionsPanelProps) {
  const [editingId, setEditingId] = useState<number | null>(null)
  const editingSubmission = editingId != null
    ? submissions.find((s) => s.id === editingId) ?? null
    : null

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
    <div className="overflow-auto">
      {/* Header */}
      <div className="sticky top-0 grid grid-cols-[2rem_1fr_4.5rem_5rem_5rem_minmax(4rem,1fr)] items-center gap-2 px-4 py-2 text-xs font-medium text-muted-foreground border-b border-border bg-background">
        <span />
        <span>Status</span>
        <span>Language</span>
        <span>Runtime</span>
        <span>Memory</span>
        <span>Notes</span>
      </div>

      {/* Rows */}
      {submissions.map((s, i) => (
        <div
          key={s.id}
          className="grid grid-cols-[2rem_1fr_4.5rem_5rem_5rem_minmax(4rem,1fr)] items-center gap-2 px-4 py-2.5 text-sm border-b border-border hover:bg-muted/50 transition-colors"
        >
          {/* Row number */}
          <span className="text-xs text-muted-foreground">
            {submissions.length - i}
          </span>

          {/* Status + date */}
          <div className="min-w-0">
            <div className={`font-medium ${statusColorMap[s.status]}`}>
              {statusLabels[s.status]}
            </div>
            <div className="text-xs text-muted-foreground">
              {formatDate(s.createdAt)}
            </div>
          </div>

          {/* Language */}
          <div>
            <Badge variant="secondary" className="text-[10px] px-1.5 py-0 capitalize">
              {s.language}
            </Badge>
          </div>

          {/* Runtime */}
          <div className="flex items-center gap-1 text-xs text-muted-foreground">
            {s.runtimeMs != null ? (
              <>
                <svg className="w-3 h-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <circle cx="12" cy="12" r="10" />
                  <polyline points="12 6 12 12 16 14" />
                </svg>
                <span>{s.runtimeMs} ms</span>
              </>
            ) : (
              <span>N/A</span>
            )}
          </div>

          {/* Memory */}
          <div className="flex items-center gap-1 text-xs text-muted-foreground">
            {s.memoryKb != null ? (
              <>
                <svg className="w-3 h-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="4" y="4" width="16" height="16" rx="2" />
                  <rect x="9" y="9" width="6" height="6" />
                  <path d="M15 2v2" /><path d="M15 20v2" /><path d="M2 15h2" /><path d="M2 9h2" />
                  <path d="M20 15h2" /><path d="M20 9h2" /><path d="M9 2v2" /><path d="M9 20v2" />
                </svg>
                <span>{formatMemory(s.memoryKb)}</span>
              </>
            ) : (
              <span>N/A</span>
            )}
          </div>

          {/* Notes */}
          <div className="min-w-0">
            <span
              onClick={() => setEditingId(s.id)}
              className="text-xs text-muted-foreground truncate block cursor-pointer hover:text-foreground transition-colors"
              title={s.notes || "Add a note..."}
            >
              {s.notes || (
                <span className="italic opacity-50">Add note</span>
              )}
            </span>
          </div>
        </div>
      ))}

      <NoteModal
        open={editingId != null}
        value={editingSubmission?.notes ?? null}
        onClose={() => setEditingId(null)}
        onSave={(notes) => {
          if (editingId != null) onUpdateNote?.(editingId, notes)
        }}
      />
    </div>
  )
}
