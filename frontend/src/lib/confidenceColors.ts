import { useCallback } from "react";
import { useTranslation } from "react-i18next";
import type { Confidence } from "@/types/review";

export const CONFIDENCE_ORDER: readonly Confidence[] = ["AGAIN", "HARD", "GOOD", "EASY"];

/** Translated confidence label (`common:confidence.*`), e.g. Again / 다시. */
export function useConfidenceLabel() {
  const { t } = useTranslation("common");
  return useCallback((c: Confidence) => t(`confidence.${c}`), [t]);
}

// Foreground text colour for inline labels (badges, list rows).
// Wash-and-Text / Readable Ember: the 700 step on paper, the 400 step on night.
export const confidenceTextClass: Record<Confidence, string> = {
  AGAIN: "text-error-700 dark:text-error-400",
  HARD: "text-warning-700 dark:text-warning-400",
  GOOD: "text-accent-700 dark:text-accent-400",
  EASY: "text-success-700 dark:text-success-400",
};

// Tinted wash + matching readable text, for chips and pills. Ember steps to 800 on its
// own wash, where 700 drops below 4.5:1 (as on the Mist sort header).
export const confidenceChipClass: Record<Confidence, string> = {
  AGAIN: "bg-error-500/15 text-error-700 dark:text-error-400",
  HARD: "bg-warning-500/15 text-warning-700 dark:text-warning-400",
  GOOD: "bg-accent-500/15 text-accent-800 dark:text-accent-400",
  EASY: "bg-success-500/15 text-success-700 dark:text-success-400",
};
