import type { Confidence } from "@/types/review";

export const confidenceLabel: Record<Confidence, string> = {
  AGAIN: "Again",
  HARD: "Hard",
  GOOD: "Good",
  EASY: "Easy",
};

// Foreground text color — used for inline labels (badges, list rows).
export const confidenceTextClass: Record<Confidence, string> = {
  AGAIN: "text-destructive",
  HARD: "text-warning-500",
  GOOD: "text-accent-500",
  EASY: "text-success-500",
};

// Tinted background + matching text — used for chips/pills.
export const confidenceChipClass: Record<Confidence, string> = {
  AGAIN: "bg-destructive/15 text-destructive",
  HARD: "bg-warning-500/15 text-warning-500",
  GOOD: "bg-accent-500/15 text-accent-500",
  EASY: "bg-success-500/15 text-success-500",
};
