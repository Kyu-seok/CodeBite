import type { OnboardingStorage } from "./seenTips";
import type { TutorialState } from "./tutorial";

/**
 * Who is looking at /problems. A signed-in user's `hasSubmissions` is null until it is known.
 */
export type BannerViewer = { signedIn: false } | { signedIn: true; hasSubmissions: boolean | null };

/**
 * Whether /problems offers the Tutorial: to a signed-in user while they have no submissions (a
 * server fact, so a new browser doesn't bring it back), to an anonymous visitor while the Tutorial
 * hasn't been finished or skipped in this browser. Never once dismissed in this browser.
 */
export function tutorialBannerShows(viewer: BannerViewer, tutorial: TutorialState, dismissed: boolean): boolean {
  if (dismissed) return false;
  if (viewer.signedIn) return viewer.hasSubmissions === false;
  return tutorial.status !== "finished" && tutorial.status !== "skipped";
}

const BANNER_DISMISSED_KEY = "onboarding-tutorial-banner-dismissed";

/** Whether the /problems banner was dismissed in this browser; storage that throws or holds junk means not. */
export function readTutorialBannerDismissed(storage: OnboardingStorage): boolean {
  try {
    return JSON.parse(storage.getItem(BANNER_DISMISSED_KEY) ?? "false") === true;
  } catch {
    return false;
  }
}

/**
 * Remembers the banner as dismissed and returns true, the page's new state. A write that fails is
 * dropped: the banner stays hidden while the page is open and comes back on the next visit.
 */
export function dismissTutorialBanner(storage: OnboardingStorage): true {
  try {
    storage.setItem(BANNER_DISMISSED_KEY, "true");
  } catch {
    // storage full / disabled
  }
  return true;
}
