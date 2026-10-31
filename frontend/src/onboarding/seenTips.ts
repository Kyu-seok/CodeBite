import { readStored, writeStored, type OnboardingStorage } from "./storage";
import { TIPS, type Tip } from "./tips";

const SEEN_TIPS_KEY = "onboarding-seen-tips";

function isTip(value: unknown): value is Tip {
  return (TIPS as readonly unknown[]).includes(value);
}

/**
 * The Tips dismissed in this browser. Storage that throws, holds nothing or holds something
 * unreadable means none: a Tip shown again is better than a broken workspace.
 */
export function readSeenTips(storage: OnboardingStorage): Set<Tip> {
  const parse = (stored: unknown) => new Set(Array.isArray(stored) ? stored.filter(isTip) : []);
  return readStored(storage, SEEN_TIPS_KEY, parse, new Set<Tip>());
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
  writeStored(storage, SEEN_TIPS_KEY, [...seen]);
  return seen;
}
