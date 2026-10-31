import { TIPS, type Tip } from "./tips";

/** The part of Storage onboarding needs; the app passes localStorage, tests a Map-backed fake. */
export interface OnboardingStorage {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
}

const SEEN_TIPS_KEY = "onboarding-seen-tips";

function isTip(value: unknown): value is Tip {
  return (TIPS as readonly unknown[]).includes(value);
}

/**
 * The Tips dismissed in this browser. Storage that throws, holds nothing or holds something
 * unreadable means none: a Tip shown again is better than a broken workspace.
 */
export function readSeenTips(storage: OnboardingStorage): Set<Tip> {
  try {
    const stored: unknown = JSON.parse(storage.getItem(SEEN_TIPS_KEY) ?? "[]");
    return new Set(Array.isArray(stored) ? stored.filter(isTip) : []);
  } catch {
    return new Set();
  }
}

/**
 * Remembers `tip` as dismissed and returns every Tip seen: those stored, those in `seenTips` (what
 * the page already knows) and `tip`. A write that fails is dropped, so the returned set still
 * hides the Tip for as long as the page keeps it; on the next visit it shows again.
 */
export function markTipSeen(
  storage: OnboardingStorage,
  tip: Tip,
  seenTips: ReadonlySet<Tip> = new Set(),
): Set<Tip> {
  const seen = new Set([...readSeenTips(storage), ...seenTips, tip]);
  try {
    storage.setItem(SEEN_TIPS_KEY, JSON.stringify([...seen]));
  } catch {
    // storage full / disabled
  }
  return seen;
}
