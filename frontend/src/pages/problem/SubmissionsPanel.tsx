import { useState, useEffect } from "react"
import { useTranslation } from "react-i18next"
import { Badge } from "@/components/ui/Badge"
import { Button } from "@/components/ui/Button"
import LoadError from "@/components/ui/LoadError"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/Dialog"
import type { CustomTestCaseInput, SubmissionListItem } from "@/types/submission"
import type { AddCustomTestOutcome } from "./customTests"
import { confidenceChipClass, useConfidenceLabel } from "@/lib/confidenceColors"
import { SubmissionDetail } from "./SubmissionDetail"
import {
  STATUS_KEYS,
  STATUS_TEXT_CLASS,
  formatMemory,
  formatDate,
  languageLabel,
} from "./submissionDisplay"

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
  const { t } = useTranslation("problem")
  const { t: tc } = useTranslation("common")
  const [draft, setDraft] = useState("")

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect -- The dialog stays mounted while closed; each opening starts from the saved note.
    if (open) setDraft(value || "")
  }, [open, value])

  return (
    <Dialog
      open={open}
      onOpenChange={(isOpen) => {
        if (!isOpen) onClose()
      }}
    >
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>{t("submissions.notesDialog")}</DialogTitle>
          <DialogDescription className="sr-only">
            {t("submissions.notesDescription")}
          </DialogDescription>
        </DialogHeader>
        <textarea
          aria-label={t("submissions.notesDialog")}
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          maxLength={500}
          rows={5}
          placeholder={t("submissions.notesPlaceholder")}
          className="mt-2 w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
        />
        <div className="mt-4 flex justify-end gap-2">
          <Button variant="outline" size="sm" onClick={onClose}>
            {tc("button.cancel")}
          </Button>
          <Button
            size="sm"
            onClick={() => {
              onSave(draft)
              onClose()
            }}
          >
            {tc("button.save")}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  )
}

interface SubmissionsPanelProps {
  isAuthenticated: boolean
  submissions: SubmissionListItem[]
  failed: boolean
  onRetry: () => void
  selectedSubmissionId: number | null
  onSelectSubmission: (id: number | null) => void
  onUpdateNote?: (id: number, notes: string) => void
  onLoadIntoEditor?: (code: string, language: string) => void
  onAddCustomTest?: (tc: CustomTestCaseInput) => AddCustomTestOutcome
}

export function SubmissionsPanel({
  isAuthenticated,
  submissions,
  failed,
  onRetry,
  selectedSubmissionId,
  onSelectSubmission,
  onUpdateNote,
  onLoadIntoEditor,
  onAddCustomTest,
}: SubmissionsPanelProps) {
  const { t, i18n } = useTranslation("problem")
  const { t: tc } = useTranslation("common")
  const confidenceLabel = useConfidenceLabel()
  const [editingId, setEditingId] = useState<number | null>(null)
  const editingSubmission = editingId != null
    ? submissions.find((s) => s.id === editingId) ?? null
    : null

  if (selectedSubmissionId != null) {
    return (
      <SubmissionDetail
        submissionId={selectedSubmissionId}
        onBack={() => onSelectSubmission(null)}
        onUpdateNote={onUpdateNote}
        onLoadIntoEditor={onLoadIntoEditor}
        onAddCustomTest={onAddCustomTest}
      />
    )
  }

  if (!isAuthenticated) {
    return (
      <div className="p-6">
        <p className="text-sm text-muted-foreground">
          {t("submissions.loginRequired")}
        </p>
      </div>
    )
  }

  if (failed) {
    return (
      <div className="p-6">
        <LoadError onRetry={onRetry} />
      </div>
    )
  }

  if (submissions.length === 0) {
    return (
      <div className="p-6">
        <p className="text-sm text-muted-foreground">{t("submissions.noSubmissions")}</p>
      </div>
    )
  }

  // A container query, not a viewport one: the left panel is resizable, so its own width decides.
  return (
    <div className="@container overflow-auto">
      {/* Header */}
      <div className="sticky top-0 grid grid-cols-[2rem_minmax(7rem,1fr)_4.5rem_4.5rem_minmax(3rem,1fr)] @xl:grid-cols-[2rem_minmax(7rem,1fr)_4.5rem_5rem_5rem_4.5rem_minmax(4rem,1fr)] items-center gap-2 px-4 py-2 text-xs font-medium text-muted-foreground border-b border-border bg-background">
        <span />
        <span>{tc("label.status")}</span>
        <span>{tc("label.language")}</span>
        <span>{tc("label.runtime")}</span>
        <span className="hidden @xl:block">{tc("label.memory")}</span>
        <span className="hidden @xl:block">{t("submissions.confidence")}</span>
        <span>{t("submissions.notes")}</span>
      </div>

      {/* Rows */}
      {submissions.map((s, i) => {
        const date = formatDate(s.createdAt, i18n.language)
        return (
        <div
          key={s.id}
          className="relative grid grid-cols-[2rem_minmax(7rem,1fr)_4.5rem_4.5rem_minmax(3rem,1fr)] @xl:grid-cols-[2rem_minmax(7rem,1fr)_4.5rem_5rem_5rem_4.5rem_minmax(4rem,1fr)] items-center gap-2 px-4 py-2.5 text-sm border-b border-border hover:bg-muted/50 transition-colors focus-within:bg-muted/50"
        >
          {/* Row number */}
          <span className="font-mono text-xs tabular-nums text-muted-foreground">
            {submissions.length - i}
          </span>

          {/* Status + date. The button's overlay makes the whole row open the submission. */}
          <div className="min-w-0">
            <button
              type="button"
              onClick={() => onSelectSubmission(s.id)}
              aria-label={`${tc(STATUS_KEYS[s.status])}, ${t("submissions.openSubmission", { date })}`}
              className={`block text-left font-medium after:absolute after:inset-0 after:content-[''] focus-visible:outline-none focus-visible:after:ring-2 focus-visible:after:ring-inset focus-visible:after:ring-ring ${STATUS_TEXT_CLASS[s.status]}`}
            >
              {tc(STATUS_KEYS[s.status])}
            </button>
            <div className="whitespace-nowrap text-xs text-muted-foreground">
              {date}
            </div>
          </div>

          {/* Language */}
          <div>
            <Badge variant="secondary" className="text-xs px-1.5 py-0">
              {languageLabel(s.language)}
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
                <span className="font-mono tabular-nums">{s.runtimeMs} ms</span>
              </>
            ) : (
              <span>{tc("label.na")}</span>
            )}
          </div>

          {/* Memory */}
          <div className="hidden items-center gap-1 text-xs text-muted-foreground @xl:flex">
            {s.memoryKb != null ? (
              <>
                <svg className="w-3 h-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="4" y="4" width="16" height="16" rx="2" />
                  <rect x="9" y="9" width="6" height="6" />
                  <path d="M15 2v2" /><path d="M15 20v2" /><path d="M2 15h2" /><path d="M2 9h2" />
                  <path d="M20 15h2" /><path d="M20 9h2" /><path d="M9 2v2" /><path d="M9 20v2" />
                </svg>
                <span className="font-mono tabular-nums">{formatMemory(s.memoryKb)}</span>
              </>
            ) : (
              <span>{tc("label.na")}</span>
            )}
          </div>

          {/* Confidence */}
          <div className="hidden @xl:block">
            {s.confidence ? (
              <span className={`inline-flex items-center rounded px-1.5 py-0.5 text-xs font-medium ${confidenceChipClass[s.confidence]}`}>
                {confidenceLabel(s.confidence)}
              </span>
            ) : (
              <span className="text-xs text-muted-foreground" aria-hidden="true">—</span>
            )}
          </div>

          {/* Notes */}
          <div className="min-w-0">
            <button
              type="button"
              onClick={() => setEditingId(s.id)}
              aria-label={s.notes ? `${t("submissions.editNote")}: ${s.notes}` : t("submissions.addNote")}
              className="relative z-10 block w-full truncate rounded text-left text-xs text-muted-foreground hover:text-foreground transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
              title={s.notes || t("submissions.addNote")}
            >
              {s.notes || (
                <span className="italic">{t("submissions.addNote")}</span>
              )}
            </button>
          </div>
        </div>
        )
      })}

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
