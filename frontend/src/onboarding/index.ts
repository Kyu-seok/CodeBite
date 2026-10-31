/**
 * Onboarding (GLOSSARY.md): every decision about the Tutorial and Tips, free of React so the
 * workspace only renders what it returns. Storage is injected; the app passes `localStorage`.
 */
export { TIPS, tipFor, type JudgedResult, type Tip } from "./tips";
export { markTipSeen, readSeenTips, type OnboardingStorage } from "./seenTips";
export { browserStorage } from "./browserStorage";
export {
  advanceTutorial,
  NOT_STARTED,
  readTutorial,
  TUTORIAL_PROBLEM_SLUG,
  TUTORIAL_STEPS,
  tutorialStep,
  type TutorialEvent,
  type TutorialState,
  type TutorialStepName,
} from "./tutorial";
export {
  dismissTutorialBanner,
  readTutorialBannerDismissed,
  tutorialBannerShows,
  type BannerViewer,
} from "./banner";
