import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { Check } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/Dialog";
import { ConfidencePrompt } from "./ConfidencePrompt";
import type { Confidence } from "@/types/review";

interface AcceptedModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  submissionId: number | null;
  defaultSolveTimeSeconds?: number | null;
  /** The backend scheduler's interval per rating, shown on each option. */
  reviewIntervalDays?: Record<Confidence, number> | null;
  onSubmit: (args: {
    submissionId: number;
    confidence: Confidence;
    notes: string | null;
    solveTimeSeconds: number | null;
  }) => Promise<void> | void;
}

function splitMinSec(total: number | null): { min: number; sec: number } {
  if (total == null || total < 0) return { min: 0, sec: 0 };
  return { min: Math.floor(total / 60), sec: total % 60 };
}

export function AcceptedModal({
  open,
  onOpenChange,
  submissionId,
  defaultSolveTimeSeconds,
  reviewIntervalDays,
  onSubmit,
}: AcceptedModalProps) {
  const { t } = useTranslation("common");
  const initial = splitMinSec(defaultSolveTimeSeconds ?? null);
  const [min, setMin] = useState(initial.min);
  const [sec, setSec] = useState(initial.sec);
  const [busy, setBusy] = useState(false);

  // Reset the minute/second inputs when the modal re-opens for a different submission.
  useEffect(() => {
    if (open) {
      const next = splitMinSec(defaultSolveTimeSeconds ?? null);
      setMin(next.min);
      setSec(next.sec);
    }
  }, [open, defaultSolveTimeSeconds]);

  const handleSubmit = async (confidence: Confidence, notes: string | null) => {
    if (submissionId == null) return;
    setBusy(true);
    try {
      const total =
        defaultSolveTimeSeconds != null || min > 0 || sec > 0
          ? Math.max(0, min) * 60 + Math.max(0, sec)
          : null;
      await onSubmit({ submissionId, confidence, notes, solveTimeSeconds: total });
      onOpenChange(false);
    } finally {
      setBusy(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent
        // Start on the rating's tab stop (Good) rather than the time inputs: rating is what this
        // dialog is for, and the time is usually already filled in from the solve timer.
        onOpenAutoFocus={(e) => {
          const stop = (e.currentTarget as HTMLElement | null)?.querySelector<HTMLElement>(
            '[role="radio"][tabindex="0"]',
          );
          if (!stop) return;
          e.preventDefault();
          stop.focus();
        }}
      >
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <span
              aria-hidden
              className="inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-success-500/15 text-success-700 dark:text-success-400"
            >
              <Check className="h-4 w-4" strokeWidth={3} />
            </span>
            {t("review.accepted.title")}
          </DialogTitle>
          <DialogDescription className="sr-only">{t("review.prompt.subtitle")}</DialogDescription>
        </DialogHeader>

        <fieldset className="mt-2 rounded-md border border-border bg-muted/30 px-3 py-2">
          <legend className="sr-only">{t("review.accepted.timeTaken")}</legend>
          <span aria-hidden className="text-xs text-muted-foreground">
            {t("review.accepted.timeTaken")}
          </span>
          <div className="mt-1 flex items-center gap-1.5 text-sm">
            <input
              type="number"
              inputMode="numeric"
              min={0}
              value={min}
              onChange={(e) => setMin(Math.max(0, Number(e.target.value) || 0))}
              disabled={busy}
              aria-label={t("review.accepted.minutesLabel")}
              className="w-16 rounded-md border border-border bg-background px-2 py-1 text-right font-mono text-base tabular-nums text-foreground focus:outline-none focus-visible:ring-2 focus-visible:ring-ring sm:text-sm"
            />
            <span aria-hidden className="text-muted-foreground">{t("review.accepted.minutes")}</span>
            <input
              type="number"
              inputMode="numeric"
              min={0}
              max={59}
              value={sec}
              onChange={(e) => setSec(Math.max(0, Math.min(59, Number(e.target.value) || 0)))}
              disabled={busy}
              aria-label={t("review.accepted.secondsLabel")}
              className="w-16 rounded-md border border-border bg-background px-2 py-1 text-right font-mono text-base tabular-nums text-foreground focus:outline-none focus-visible:ring-2 focus-visible:ring-ring sm:text-sm"
            />
            <span aria-hidden className="text-muted-foreground">{t("review.accepted.seconds")}</span>
          </div>
        </fieldset>

        <div className="mt-3">
          <ConfidencePrompt
            onSubmit={handleSubmit}
            onSkip={() => onOpenChange(false)}
            busy={busy}
            intervalDays={reviewIntervalDays}
          />
        </div>
      </DialogContent>
    </Dialog>
  );
}
