/** The part of Storage onboarding needs; the app passes `browserStorage`, tests a Map-backed fake. */
export interface OnboardingStorage {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
}

/**
 * localStorage, reached only inside each call: where merely touching `localStorage` throws
 * (blocked site data), the throw lands in `readStored` / `writeStored`, never in a render.
 */
export const browserStorage: OnboardingStorage = {
  getItem: (key) => localStorage.getItem(key),
  setItem: (key, value) => localStorage.setItem(key, value),
};

/**
 * The JSON value under `key`, made safe by `parse` (which drops or rejects what it doesn't
 * recognise). Storage that throws, holds nothing or holds something that isn't JSON gives
 * `fallback`: onboarding forgetting something is better than a broken workspace.
 */
export function readStored<T>(storage: OnboardingStorage, key: string, parse: (stored: unknown) => T, fallback: T): T {
  try {
    const stored = storage.getItem(key);
    return stored == null ? fallback : parse(JSON.parse(stored));
  } catch {
    return fallback;
  }
}

/** Keeps `value` as JSON under `key`. A write that fails (storage full or disabled) is dropped. */
export function writeStored(storage: OnboardingStorage, key: string, value: unknown): void {
  try {
    storage.setItem(key, JSON.stringify(value));
  } catch {
    // storage full / disabled
  }
}
