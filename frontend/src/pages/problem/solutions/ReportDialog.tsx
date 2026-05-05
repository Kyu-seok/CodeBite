import { useEffect, useState } from "react"
import { useTranslation } from "react-i18next"
import { Button } from "@/components/ui/Button"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/Dialog"

interface ReportDialogProps {
  open: boolean
  onClose: () => void
  onSubmit: (reason: string) => Promise<void> | void
}

export function ReportDialog({ open, onClose, onSubmit }: ReportDialogProps) {
  const { t } = useTranslation("problem")
  const { t: tc } = useTranslation("common")
  const [reason, setReason] = useState("")
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (open) {
      setReason("")
      setSubmitting(false)
    }
  }, [open])

  const handleSubmit = async () => {
    if (!reason.trim() || submitting) return
    setSubmitting(true)
    try {
      await onSubmit(reason.trim())
      onClose()
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <Dialog
      open={open}
      onOpenChange={(isOpen) => {
        if (!isOpen) onClose()
      }}>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>{t("solutions.report")}</DialogTitle>
          <DialogDescription>{t("solutions.reportDescription")}</DialogDescription>
        </DialogHeader>
        <textarea
          value={reason}
          onChange={(e) => setReason(e.target.value)}
          maxLength={500}
          rows={4}
          placeholder={t("solutions.reportReasonPlaceholder")}
          className="mt-2 w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
        />
        <div className="mt-4 flex justify-end gap-2">
          <Button variant="outline" size="sm" onClick={onClose}>
            {tc("button.cancel")}
          </Button>
          <Button
            variant="destructive"
            size="sm"
            disabled={!reason.trim() || submitting}
            onClick={handleSubmit}>
            {t("solutions.report")}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  )
}
