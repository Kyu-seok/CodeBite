import { useId, useRef, useState, type KeyboardEvent } from "react";
import { useTranslation } from "react-i18next";
import { Check } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { CONFIDENCE_ORDER, useConfidenceLabel } from "@/lib/confidenceColors";
import { cn, focusRing } from "@/lib/utils";
import type { Confidence } from "@/types/review";

// Hairline-weight borders and washes may use the 500 step; label text follows
// Wash-and-Text / Readable Ember (700 on paper, 800 for Ember on its own wash, 400 on night).
const OPTION_CLASS: Record<Confidence, { base: string; selected: string }> = {
  AGAIN: {
    base: "border-error-500/50 hover:border-error-500 hover:bg-error-500/10 text-error-700 dark:text-error-400",
    selected: "border-error-500 bg-error-500/10",
  },
  HARD: {
    base: "border-warning-500/50 hover:border-warning-500 hover:bg-warning-500/10 text-warning-700 dark:text-warning-400",
    selected: "border-warning-500 bg-warning-500/10",
  },
  GOOD: {
    base: "border-accent-500/50 hover:border-accent-500 hover:bg-accent-500/10 text-accent-700 hover:text-accent-800 dark:text-accent-400 dark:hover:text-accent-400",
    selected: "border-accent-500 bg-accent-500/10 text-accent-800 dark:text-accent-400",
  },
  EASY: {
    base: "border-success-500/50 hover:border-success-500 hover:bg-success-500/10 text-success-700 dark:text-success-400",
    selected: "border-success-500 bg-success-500/10",
  },
};

type Status =
  | { kind: "idle" }
  | { kind: "saving" }
  | { kind: "saved"; confidence: Confidence }
  | { kind: "clearing" }
  | { kind: "cleared" }
  | { kind: "saveFailed" }
  | { kind: "clearFailed" };

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

/**
 * The confidence choice is a radio group: Tab lands on the current rating (or the first),
 * arrow keys move between options without saving, and Enter / Space saves the focused one.
 */
export function ConfidencePrompt({
  onSubmit,
  onSkip,
  onClear,
  busy = false,
  title,
  subtitle,
  currentRating = null,
  defaultNotes = null,
}: ConfidencePromptProps) {
  const { t } = useTranslation("common");
  const confidenceLabel = useConfidenceLabel();
  const id = useId();
  const titleId = `${id}-title`;
  const subtitleId = `${id}-subtitle`;
  const notesId = `${id}-notes`;

  const [notes, setNotes] = useState(defaultNotes ?? "");
  const [picked, setPicked] = useState<Confidence | null>(null);
  const [status, setStatus] = useState<Status>({ kind: "idle" });
  const optionRefs = useRef<Array<HTMLButtonElement | null>>([]);

  const working = busy || status.kind === "saving" || status.kind === "clearing";
  const selected = picked ?? currentRating;
  const tabStop = Math.max(0, selected ? CONFIDENCE_ORDER.indexOf(selected) : 0);
  const [focusIndex, setFocusIndex] = useState<number | null>(null);
  const activeIndex = focusIndex ?? tabStop;

  const handlePick = async (c: Confidence) => {
    if (working) return;
    setPicked(c);
    setStatus({ kind: "saving" });
    try {
      await onSubmit(c, notes.trim() ? notes.trim() : null);
      setStatus({ kind: "saved", confidence: c });
    } catch {
      setPicked(null);
      setStatus({ kind: "saveFailed" });
    }
  };

  const handleClear = async () => {
    if (!onClear || working) return;
    setStatus({ kind: "clearing" });
    try {
      await onClear();
      setPicked(null);
      setStatus({ kind: "cleared" });
    } catch {
      setStatus({ kind: "clearFailed" });
    }
  };

  const handleKeyDown = (e: KeyboardEvent<HTMLButtonElement>, index: number) => {
    const last = CONFIDENCE_ORDER.length - 1;
    let next: number | null = null;
    if (e.key === "ArrowRight" || e.key === "ArrowDown") next = index === last ? 0 : index + 1;
    else if (e.key === "ArrowLeft" || e.key === "ArrowUp") next = index === 0 ? last : index - 1;
    else if (e.key === "Home") next = 0;
    else if (e.key === "End") next = last;
    if (next == null) return;
    e.preventDefault();
    setFocusIndex(next);
    optionRefs.current[next]?.focus();
  };

  const statusText =
    status.kind === "saving"
      ? t("review.prompt.saving")
      : status.kind === "saved"
        ? t("review.prompt.saved", { label: confidenceLabel(status.confidence) })
        : status.kind === "clearing"
          ? t("review.prompt.clearing")
          : status.kind === "cleared"
            ? t("review.prompt.cleared")
            : "";
  const errorText =
    status.kind === "saveFailed"
      ? t("review.prompt.saveFailed")
      : status.kind === "clearFailed"
        ? t("review.prompt.clearFailed")
        : "";

  const showClear = onClear && currentRating;

  return (
    <div className="@container rounded-lg border border-border bg-card p-4">
      <div>
        <h3 id={titleId} className="text-sm font-semibold text-foreground">
          {title ?? t("review.prompt.title")}
        </h3>
        <p id={subtitleId} className="mt-0.5 text-xs text-muted-foreground">
          {subtitle ?? t("review.prompt.subtitle")}
        </p>
      </div>

      <div
        role="radiogroup"
        aria-labelledby={titleId}
        aria-describedby={subtitleId}
        aria-busy={working || undefined}
        className="mt-3 grid grid-cols-2 gap-2 @sm:grid-cols-4"
        onBlur={(e) => {
          if (!e.currentTarget.contains(e.relatedTarget as Node | null)) setFocusIndex(null);
        }}
      >
        {CONFIDENCE_ORDER.map((c, i) => {
          const isSelected = selected === c;
          const hintId = `${id}-hint-${c}`;
          const nameId = `${id}-name-${c}`;
          return (
            <button
              key={c}
              ref={(el) => {
                optionRefs.current[i] = el;
              }}
              type="button"
              role="radio"
              aria-checked={isSelected}
              aria-labelledby={nameId}
              aria-describedby={hintId}
              aria-disabled={working || undefined}
              tabIndex={i === activeIndex ? 0 : -1}
              onClick={() => handlePick(c)}
              onKeyDown={(e) => handleKeyDown(e, i)}
              onFocus={() => setFocusIndex(i)}
              className={cn(
                "relative flex min-w-0 flex-col items-center justify-start gap-0.5 rounded-md border bg-background px-2 pb-2 pt-2.5 text-center transition-colors aria-disabled:cursor-not-allowed aria-disabled:opacity-60",
                focusRing,
                OPTION_CLASS[c].base,
                isSelected && OPTION_CLASS[c].selected,
              )}
            >
              {isSelected && (
                <Check aria-hidden className="absolute right-1.5 top-1.5 h-3.5 w-3.5" strokeWidth={2.5} />
              )}
              <span id={nameId} className="text-sm font-semibold">{confidenceLabel(c)}</span>
              <span id={hintId} className="text-xs leading-snug text-muted-foreground break-keep [overflow-wrap:anywhere]">
                {t(`confidence.hint.${c}`)}
              </span>
            </button>
          );
        })}
      </div>

      <label htmlFor={notesId} className="mt-3 block text-xs font-medium text-muted-foreground">
        {t("review.prompt.notesLabel")}
      </label>
      <textarea
        id={notesId}
        value={notes}
        onChange={(e) => setNotes(e.target.value)}
        maxLength={500}
        rows={2}
        placeholder={t("review.prompt.notesPlaceholder")}
        disabled={working}
        className="mt-1 w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-base text-foreground placeholder:text-muted-foreground focus:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-50 sm:text-xs"
      />

      {errorText && (
        <p role="alert" className="mt-2 text-xs text-error-700 dark:text-error-400">
          {errorText}
        </p>
      )}

      <div className="mt-2 flex flex-wrap items-center justify-end gap-2">
        <p role="status" className="mr-auto min-w-0 text-xs text-muted-foreground">
          {statusText}
        </p>
        {showClear && (
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={handleClear}
            disabled={working}
            className="text-error-700 hover:bg-error-500/10 dark:text-error-400"
          >
            {t("review.prompt.clear")}
          </Button>
        )}
        {onSkip && (
          <Button type="button" variant="ghost" size="sm" onClick={onSkip} disabled={working}>
            {currentRating ? t("button.close") : t("review.prompt.skip")}
          </Button>
        )}
      </div>
    </div>
  );
}
