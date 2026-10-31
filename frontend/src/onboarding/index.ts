/**
 * Onboarding (GLOSSARY.md): every decision about the Tutorial and Tips, free of React so the
 * workspace only renders what it returns. Storage is injected; the app passes `localStorage`.
 */
export { TIPS, tipFor, type JudgedResult, type Tip } from "./tips";
export { markTipSeen, readSeenTips } from "./seenTips";
export { browserStorage, type OnboardingStorage } from "./storage";
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
  lineToFill,
  tutorialSpotlight,
  type Spotlight,
  type SpotlightContext,
  type SpotlightCopy,
  type TourTarget,
} from "./spotlight";
export {
  milestoneToReport,
  TUTORIAL_MILESTONES,
  tutorialMilestone,
  type TutorialMilestone,
} from "./milestones";
export {
  dismissTutorialBanner,
  readTutorialBannerDismissed,
  tutorialBannerShows,
  type BannerViewer,
} from "./banner";
