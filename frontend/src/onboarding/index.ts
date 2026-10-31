/**
 * Onboarding (GLOSSARY.md): every decision about Tips, free of React so the workspace only renders
 * what it returns. Storage is injected; the app passes `localStorage`.
 */
export { TIPS, tipFor, type JudgedResult, type Tip } from "./tips";
export { markTipSeen, readSeenTips, type OnboardingStorage } from "./seenTips";
export { browserStorage } from "./browserStorage";
