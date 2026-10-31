import type { OnboardingStorage } from "./seenTips";

/**
 * localStorage, reached only inside each call: where merely touching `localStorage` throws
 * (blocked site data), the throw lands in the module's own try/catch, never in a render.
 */
export const browserStorage: OnboardingStorage = {
  getItem: (key) => localStorage.getItem(key),
  setItem: (key, value) => localStorage.setItem(key, value),
};
