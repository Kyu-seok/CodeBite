import { useEffect, useId, useRef, useState } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { ArrowRight, Check } from "lucide-react";
import { Button } from "@/components/ui/Button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/Dialog";
import { ConfidencePrompt } from "./ConfidencePrompt";
import { useConfidenceLabel } from "@/lib/confidenceColors";
import { dueDateLabel } from "@/lib/dueWording";
import { findNextProblem, type NextProblem } from "@/lib/nextProblem";
import { cn, focusRing } from "@/lib/utils";
import type { Confidence, ReviewState } from "@/types/review";

interface AcceptedModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  submissionId: number | null;
  /** The problem just solved; never offered as the next one. */
  problemSlug: string;
  defaultSolveTimeSeconds?: number | null;
  /** The backend scheduler's interval per rating, shown on each option. */
  reviewIntervalDays?: Record<Confidence, number> | null;
  /** Saves the rating and resolves with the review state the backend scheduled. */
  onSubmit: (args: {
    submissionId: number;
    confidence: Confidence;
    notes: string | null;
    solveTimeSeconds: number | null;
  }) => Promise<ReviewState>;
}

/** What the dialog shows once the rating is saved: the backend's schedule and where to go next. */
interface Done {
  confidence: Confidence;
  state: ReviewState;
  next: NextProblem;
}

// Blank fields mean no time. The timer is manual, so a problem solved without it has no
// time to record, and saving 0:00 would read as a real (impossibly fast) solve.
function splitMinSec(total: number | null): { min: string; sec: string } {
  if (total == null || total <= 0) return { min: "", sec: "" };
  return { min: String(Math.floor(total / 60)), sec: String(total % 60) };
}

function toSeconds(min: string, sec: string): number | null {
  const total = (Number(min) || 0) * 60 + (Number(sec) || 0);
  return total > 0 ? total : null;
}

function cleanDigits(value: string, max?: number): string {
  if (value === "") return "";
  const n = Math.max(0, Math.floor(Number(value) || 0));
  return String(max != null ? Math.min(max, n) : n);
}

export function AcceptedModal({
  open,
  onOpenChange,
  submissionId,
  problemSlug,
  defaultSolveTimeSeconds,
  reviewIntervalDays,
  onSubmit,
}: AcceptedModalProps) {
  const { t, i18n } = useTranslation("common");
  const confidenceLabel = useConfidenceLabel();
  const initial = splitMinSec(defaultSolveTimeSeconds ?? null);
  const [min, setMin] = useState(initial.min);
  const [sec, setSec] = useState(initial.sec);
  const [busy, setBusy] = useState(false);
  const [done, setDone] = useState<Done | null>(null);
  const nextLinkRef = useRef<HTMLAnchorElement>(null);
  const noTimeId = useId();
  const noTime = toSeconds(min, sec) == null;

  // Reset the dialog when it re-opens for a different submission.
  useEffect(() => {
    if (open) {
      const next = splitMinSec(defaultSolveTimeSeconds ?? null);
      setMin(next.min);
      setSec(next.sec);
      setDone(null);
    }
  }, [open, defaultSolveTimeSeconds, submissionId]);

  // After rating, keyboard focus lands on the way forward rather than on a dialog with
  // nothing left to do.
  useEffect(() => {
    if (done) nextLinkRef.current?.focus();
  }, [done]);

  const handleSubmit = async (confidence: Confidence, notes: string | null) => {
    if (submissionId == null) return;
    setBusy(true);
    try {
      const total = toSeconds(min, sec);
      const state = await onSubmit({ submissionId, confidence, notes, solveTimeSeconds: total });
      const next = await findNextProblem(problemSlug);
      setDone({ confidence, state, next });
    } finally {
      setBusy(false);
    }
  };

  const dueDate = done ? dueDateLabel(done.state.nextDueAt, i18n.language) : "";

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent
        // Start on the rating's tab stop (Good) rather than the time inputs: rating is what this
        // dialog is for, and the time is either filled in from the solve timer or left blank.
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

        {/* Rendered empty before the rating, so the confirmation is announced when it fills in. */}
        <div role="status" className={done ? "mt-2" : "sr-only"}>
          {done && (
            <>
              <p className="text-sm font-semibold text-foreground">
                {t("review.prompt.interval", { count: done.state.intervalDays })}
              </p>
              <p className="mt-0.5 text-xs text-muted-foreground">
                {t("review.accepted.scheduled", {
                  label: confidenceLabel(done.confidence),
                  date: dueDate,
                })}
              </p>
            </>
          )}
        </div>

        {done ? (
          <div className="mt-4 flex flex-col gap-3">
            {/* Neutral on purpose: Submit keeps the view's one Ember accent (One CTA Rule). */}
            <Link
              ref={nextLinkRef}
              to={done.next.kind === "list" ? "/problems" : `/problems/${done.next.slug}`}
              onClick={() => onOpenChange(false)}
              className={cn(
                "group flex items-center gap-3 rounded-md border border-border px-3 py-2.5 transition-colors hover:border-foreground/40 hover:bg-muted/60",
                focusRing,
              )}
            >
              <span className="flex min-w-0 flex-1 flex-col">
                <span className="text-xs text-muted-foreground">
                  {t(`review.accepted.next.${done.next.kind}`)}
                </span>
                <span className="truncate text-sm font-medium text-foreground">
                  {done.next.kind === "list" ? t("review.accepted.next.listAction") : done.next.title}
                </span>
              </span>
              <ArrowRight
                aria-hidden
                className="h-4 w-4 shrink-0 text-muted-foreground transition-transform group-hover:translate-x-0.5 motion-reduce:transition-none"
              />
            </Link>
            <div className="flex justify-end">
              <Button type="button" variant="ghost" size="sm" onClick={() => onOpenChange(false)}>
                {t("button.close")}
              </Button>
            </div>
          </div>
        ) : (
          <>
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
                  placeholder="—"
                  onChange={(e) => setMin(cleanDigits(e.target.value))}
                  disabled={busy}
                  aria-label={t("review.accepted.minutesLabel")}
                  aria-describedby={noTime ? noTimeId : undefined}
                  className="w-16 rounded-md border border-border bg-background px-2 py-1 text-right font-mono text-base tabular-nums text-foreground focus:outline-none focus-visible:ring-2 focus-visible:ring-ring sm:text-sm"
                />
                <span aria-hidden className="text-muted-foreground">{t("review.accepted.minutes")}</span>
                <input
                  type="number"
                  inputMode="numeric"
                  min={0}
                  max={59}
                  value={sec}
                  placeholder="—"
                  onChange={(e) => setSec(cleanDigits(e.target.value, 59))}
                  disabled={busy}
                  aria-label={t("review.accepted.secondsLabel")}
                  aria-describedby={noTime ? noTimeId : undefined}
                  className="w-16 rounded-md border border-border bg-background px-2 py-1 text-right font-mono text-base tabular-nums text-foreground focus:outline-none focus-visible:ring-2 focus-visible:ring-ring sm:text-sm"
                />
                <span aria-hidden className="text-muted-foreground">{t("review.accepted.seconds")}</span>
              </div>
              {noTime && (
                <p id={noTimeId} className="mt-1 text-xs text-muted-foreground">{t("review.accepted.noTime")}</p>
              )}
            </fieldset>

            <div className="mt-3">
              <ConfidencePrompt
                onSubmit={handleSubmit}
                onSkip={() => onOpenChange(false)}
                busy={busy}
                intervalDays={reviewIntervalDays}
              />
            </div>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}
