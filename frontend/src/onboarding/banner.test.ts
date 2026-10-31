import { describe, expect, it } from "vitest";
import {
  dismissTutorialBanner,
  NOT_STARTED,
  readTutorialBannerDismissed,
  tutorialBannerShows,
  type OnboardingStorage,
  type TutorialState,
} from ".";

class MemoryStorage implements OnboardingStorage {
  items = new Map<string, string>();
  getItem(key: string) {
    return this.items.get(key) ?? null;
  }
  setItem(key: string, value: string) {
    this.items.set(key, value);
  }
}

const throwing: OnboardingStorage = {
  getItem: () => {
    throw new Error("storage disabled");
  },
  setItem: () => {
    throw new Error("storage disabled");
  },
};

const anonymous = { signedIn: false } as const;

describe("tutorialBannerShows", () => {
  it("offers the Tutorial to an anonymous visitor who hasn't finished or skipped it", () => {
    expect(tutorialBannerShows(anonymous, NOT_STARTED, false)).toBe(true);
    expect(tutorialBannerShows(anonymous, { status: "active", step: "run" }, false)).toBe(true);
  });

  it("hides for an anonymous visitor who finished or skipped it in this browser", () => {
    const finished: TutorialState = { status: "finished" };
    const skipped: TutorialState = { status: "skipped" };
    expect(tutorialBannerShows(anonymous, finished, false)).toBe(false);
    expect(tutorialBannerShows(anonymous, skipped, false)).toBe(false);
  });

  it("offers the Tutorial to a signed-in user with no submissions, whatever this browser remembers", () => {
    const viewer = { signedIn: true, hasSubmissions: false } as const;
    expect(tutorialBannerShows(viewer, NOT_STARTED, false)).toBe(true);
    expect(tutorialBannerShows(viewer, { status: "skipped" }, false)).toBe(true);
    expect(tutorialBannerShows(viewer, { status: "finished" }, false)).toBe(true);
  });

  it("hides for a signed-in user with a submission, even one who never took the Tutorial", () => {
    expect(tutorialBannerShows({ signedIn: true, hasSubmissions: true }, NOT_STARTED, false)).toBe(false);
  });

  it("hides for a signed-in user until it is known whether they have submissions", () => {
    expect(tutorialBannerShows({ signedIn: true, hasSubmissions: null }, NOT_STARTED, false)).toBe(false);
  });

  it("hides once dismissed, for anyone", () => {
    expect(tutorialBannerShows(anonymous, NOT_STARTED, true)).toBe(false);
    expect(tutorialBannerShows({ signedIn: true, hasSubmissions: false }, NOT_STARTED, true)).toBe(false);
  });
});

describe("tutorial banner dismissal", () => {
  it("is remembered in storage", () => {
    const storage = new MemoryStorage();
    expect(readTutorialBannerDismissed(storage)).toBe(false);
    expect(dismissTutorialBanner(storage)).toBe(true);
    expect(readTutorialBannerDismissed(storage)).toBe(true);
  });

  it("reads as not dismissed from unreadable storage", () => {
    const storage = new MemoryStorage();
    storage.setItem("onboarding-tutorial-banner-dismissed", "{not json");
    expect(readTutorialBannerDismissed(storage)).toBe(false);
  });

  it("still hides the banner for this page when storage throws", () => {
    expect(readTutorialBannerDismissed(throwing)).toBe(false);
    expect(dismissTutorialBanner(throwing)).toBe(true);
  });
});
