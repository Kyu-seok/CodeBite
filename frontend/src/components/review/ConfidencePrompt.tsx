import { useState } from "react";
import { Button } from "@/components/ui/Button";
import type { Confidence } from "@/types/review";

const OPTIONS: Array<{
  value: Confidence;
  label: string;
  hint: string;
  className: string;
}> = [
  {
    value: "AGAIN",
    label: "Again",
    hint: "Couldn't solve / used solution",
    className: "border-destructive/50 hover:bg-destructive/10 hover:border-destructive text-destructive",
  },
  {
    value: "HARD",
    label: "Hard",
    hint: "Solved with significant struggle",
    className: "border-warning-500/50 hover:bg-warning-500/10 hover:border-warning-500 text-warning-500",
  },
  {
    value: "GOOD",
    label: "Good",
    hint: "Solved cleanly with some effort",
    className: "border-accent-500/50 hover:bg-accent-500/10 hover:border-accent-500 text-accent-500",
  },
  {
    value: "EASY",
    label: "Easy",
    hint: "Solved quickly, fully understood",
    className: "border-success-500/50 hover:bg-success-500/10 hover:border-success-500 text-success-500",
  },
];

interface ConfidencePromptProps {
  onSubmit: (confidence: Confidence, notes: string | null) => Promise<void> | void;
  onSkip?: () => void;
  /** Optional: when present and a current rating exists, show a "Clear rating" affordance. */
  onClear?: () => Promise<void> | void;
  busy?: boolean;
  title?: string;
  subtitle?: string;
  currentRating?: Confidence | null;
  defaultNotes?: string | null;
}

export function ConfidencePrompt({
  onSubmit,
  onSkip,
  onClear,
  busy,
  title = "How was it?",
  subtitle = "Your rating sets when this problem will resurface for review.",
  currentRating = null,
  defaultNotes = null,
}: ConfidencePromptProps) {
  const [notes, setNotes] = useState(defaultNotes ?? "");
  const [picked, setPicked] = useState<Confidence | null>(null);

  const handlePick = async (c: Confidence) => {
    if (busy) return;
    setPicked(c);
    try {
      await onSubmit(c, notes.trim() ? notes.trim() : null);
    } catch {
      setPicked(null);
    }
  };

  return (
    <div className="rounded-lg border border-border bg-card p-4">
      <div>
        <h3 className="text-sm font-semibold text-foreground">{title}</h3>
        <p className="mt-0.5 text-xs text-muted-foreground">{subtitle}</p>
      </div>

      <div className="mt-3 grid grid-cols-2 gap-2 sm:grid-cols-4">
        {OPTIONS.map((opt) => {
          const isPicked = picked === opt.value;
          const isCurrent = currentRating === opt.value && !isPicked;
          const ringClass = isPicked
            ? "ring-2 ring-ring ring-offset-1"
            : isCurrent
              ? "ring-2 ring-foreground/30 ring-offset-1"
              : "";
          return (
            <button
              key={opt.value}
              type="button"
              disabled={busy}
              onClick={() => handlePick(opt.value)}
              className={`flex flex-col items-center justify-center gap-0.5 rounded-md border bg-background px-2 py-2 text-xs transition-colors disabled:pointer-events-none disabled:opacity-50 ${opt.className} ${ringClass}`}
            >
              <span className="text-sm font-semibold">{opt.label}</span>
              <span className="text-[10px] text-muted-foreground text-center leading-tight">
                {opt.hint}
              </span>
            </button>
          );
        })}
      </div>

      <textarea
        value={notes}
        onChange={(e) => setNotes(e.target.value)}
        maxLength={500}
        rows={2}
        placeholder="Optional note (what tripped you up, what to remember…)"
        disabled={busy}
        className="mt-3 w-full resize-none rounded-md border border-border bg-background px-2 py-1.5 text-xs text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring disabled:opacity-50"
      />

      {(onSkip || (onClear && currentRating)) && (
        <div className="mt-2 flex justify-end gap-2">
          {onClear && currentRating && (
            <Button
              type="button"
              variant="ghost"
              size="sm"
              onClick={onClear}
              disabled={busy}
              className="text-destructive hover:bg-destructive/10"
            >
              Clear rating
            </Button>
          )}
          {onSkip && (
            <Button
              type="button"
              variant="ghost"
              size="sm"
              onClick={onSkip}
              disabled={busy}
            >
              {currentRating ? "Close" : "Skip"}
            </Button>
          )}
        </div>
      )}
    </div>
  );
}
