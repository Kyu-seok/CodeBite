import { useEffect, useState } from "react";
import {
  Dialog,
  DialogContent,
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
  onSubmit,
}: AcceptedModalProps) {
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
      <DialogContent>
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <span aria-hidden className="inline-flex h-6 w-6 items-center justify-center rounded-full bg-success-500 text-white text-sm">✓</span>
            Accepted!
          </DialogTitle>
        </DialogHeader>

        {(defaultSolveTimeSeconds != null || true) && (
          <div className="mt-2 rounded-md border border-border bg-muted/30 px-3 py-2">
            <label className="text-xs text-muted-foreground">Time taken</label>
            <div className="mt-1 flex items-center gap-1.5 text-sm">
              <input
                type="number"
                min={0}
                value={min}
                onChange={(e) => setMin(Math.max(0, Number(e.target.value) || 0))}
                disabled={busy}
                className="w-14 rounded-md border border-border bg-background px-2 py-1 text-right tabular-nums text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
              />
              <span className="text-muted-foreground">min</span>
              <input
                type="number"
                min={0}
                max={59}
                value={sec}
                onChange={(e) => setSec(Math.max(0, Math.min(59, Number(e.target.value) || 0)))}
                disabled={busy}
                className="w-14 rounded-md border border-border bg-background px-2 py-1 text-right tabular-nums text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
              />
              <span className="text-muted-foreground">sec</span>
            </div>
          </div>
        )}

        <div className="mt-3">
          <ConfidencePrompt
            onSubmit={handleSubmit}
            onSkip={() => onOpenChange(false)}
            busy={busy}
            title="How was it?"
            subtitle="Your rating sets when we'll resurface this problem for review."
          />
        </div>
      </DialogContent>
    </Dialog>
  );
}
