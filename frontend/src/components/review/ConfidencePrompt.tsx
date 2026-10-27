import { useId, useRef, useState, type KeyboardEvent } from "react";
import { useTranslation } from "react-i18next";
import { Check } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { CONFIDENCE_ORDER, useConfidenceLabel } from "@/lib/confidenceColors";
import { cn, focusRing } from "@/lib/utils";
import type { Confidence } from "@/types/review";

// Neutral on purpose. A rating is a self-assessment, not a judging outcome, so it never takes
// green, amber or red (Outcome-Only Rule), and it never takes Ember, because the view's one accent
// belongs to Submit (One CTA Rule). Selection is an Ink border with an inset hairline, a Mist wash
// and a check mark, so it doesn't rely on colour.
const OPTION_BASE = "border-border text-foreground hover:border-foreground/40 hover:bg-muted/60";
const OPTION_SELECTED = "border-foreground bg-muted inset-ring inset-ring-foreground";

// Digit keys rate without a pointer: 1 = Again … 4 = Easy.
const SHORTCUT_KEYS = ["1", "2", "3", "4"] as const;
// With nothing rated yet, Tab (and the Accepted dialog's initial focus) lands on Good.
const DEFAULT_FOCUS: Confidence = "GOOD";

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
  /** Days until the problem comes back for each rating, from the backend scheduler. Hidden when absent. */
  intervalDays?: Partial<Record<Confidence, number>> | null;
}

/**
 * The note comes first and the rating last, because picking a rating saves it together with the note.
 * The confidence choice is a radio group: Tab lands on the current rating (or Good), arrow keys move
 * between options without saving, and Enter / Space or the digit keys 1–4 save one. Digits are
 * handled only inside this prompt, and never while typing or with a modifier held, so they can't
 * reach the editor or the page's Cmd/Ctrl Run and Submit shortcuts.
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
  intervalDays = null,
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
  const tabStop = Math.max(0, CONFIDENCE_ORDER.indexOf(selected ?? DEFAULT_FOCUS));
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

  const handleShortcut = (e: KeyboardEvent<HTMLDivElement>) => {
    if (e.defaultPrevented || e.repeat || e.metaKey || e.ctrlKey || e.altKey || e.shiftKey) return;
    if (e.nativeEvent.isComposing) return;
    if (e.target instanceof Element && e.target.closest("textarea, input, select, [contenteditable]")) return;
    const index = SHORTCUT_KEYS.indexOf(e.key as (typeof SHORTCUT_KEYS)[number]);
    if (index < 0) return;
    e.preventDefault();
    setFocusIndex(index);
    optionRefs.current[index]?.focus();
    void handlePick(CONFIDENCE_ORDER[index]);
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
    <div className="@container rounded-lg border border-border bg-card p-4" onKeyDown={handleShortcut}>
      <div>
        <h3 id={titleId} className="text-sm font-semibold text-foreground">
          {title ?? t("review.prompt.title")}
        </h3>
        <p id={subtitleId} className="mt-0.5 text-xs text-muted-foreground">
          {subtitle ?? t("review.prompt.subtitle")}
        </p>
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
          const intervalId = `${id}-interval-${c}`;
          const days = intervalDays?.[c];
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
              aria-describedby={days != null ? `${intervalId} ${hintId}` : hintId}
              aria-keyshortcuts={SHORTCUT_KEYS[i]}
              aria-disabled={working || undefined}
              tabIndex={i === activeIndex ? 0 : -1}
              onClick={() => handlePick(c)}
              onKeyDown={(e) => handleKeyDown(e, i)}
              onFocus={() => setFocusIndex(i)}
              className={cn(
                "relative flex min-w-0 flex-col items-center justify-start gap-0.5 rounded-md border bg-background px-2 pb-2 pt-2.5 text-center transition-colors aria-disabled:cursor-not-allowed aria-disabled:opacity-60",
                focusRing,
                OPTION_BASE,
                isSelected && OPTION_SELECTED,
              )}
            >
              <kbd
                aria-hidden
                className="absolute left-1.5 top-1.5 font-mono text-[0.625rem] leading-none text-muted-foreground"
              >
                {SHORTCUT_KEYS[i]}
              </kbd>
              {isSelected && (
                <Check aria-hidden className="absolute right-1.5 top-1.5 h-3.5 w-3.5" strokeWidth={2.5} />
              )}
              <span className="flex flex-wrap items-baseline justify-center gap-x-1">
                <span id={nameId} className="text-sm font-semibold">{confidenceLabel(c)}</span>
                {days != null && (
                  <span aria-hidden className="font-mono text-xs tabular-nums text-muted-foreground">
                    · {t("review.prompt.intervalShort", { count: days })}
                  </span>
                )}
              </span>
              {days != null && (
                <span id={intervalId} className="sr-only">
                  {t("review.prompt.interval", { count: days })}
                </span>
              )}
              <span id={hintId} className="text-xs leading-snug text-muted-foreground break-keep [overflow-wrap:anywhere]">
                {t(`confidence.hint.${c}`)}
              </span>
            </button>
          );
        })}
      </div>

      {errorText && (
        <p role="alert" className="mt-2 text-xs text-error-700 dark:text-error-400">
          {errorText}
        </p>
      )}

      <div className="mt-2 flex flex-wrap items-center justify-end gap-2">
        <div className="mr-auto min-w-0 text-xs text-muted-foreground">
          <p role="status">{statusText}</p>
          {/* Each option carries aria-keyshortcuts; this is the sighted version of the same hint. */}
          {!statusText && (
            <p aria-hidden className="hidden [@media(hover:hover)]:block">
              {t("review.prompt.shortcutHint")}
            </p>
          )}
        </div>
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
