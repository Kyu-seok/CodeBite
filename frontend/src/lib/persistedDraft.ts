import type { TimerDeps } from "./timers";

/** The part of Storage a draft needs; tests pass a Map-backed fake. */
export interface DraftStorage {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
}

/** Long enough to skip synchronous storage I/O on every keystroke, short enough to survive a quick nav-away. */
export const DRAFT_DEBOUNCE_MS = 300;

/** The draft stored under `key`, or `initial` when there is none or it cannot be read. */
export function readDraft<T>(storage: DraftStorage, key: string, initial: T): T {
  try {
    const stored = storage.getItem(key);
    return stored ? (JSON.parse(stored) as T) : initial;
  } catch {
    return initial;
  }
}

export interface DraftWriter<T> {
  /** Writes `value` after the debounce, replacing any write still pending. */
  schedule(value: T): void;
  /** Writes the latest scheduled value now and drops the pending write; nothing scheduled, nothing written. */
  flush(): void;
}

/**
 * Writes drafts under `key`, debounced. A write that fails (storage full or disabled) is dropped
 * without a word: the draft is a convenience, not a record.
 */
export function createDraftWriter<T>(
  storage: DraftStorage,
  key: string,
  timers: Pick<TimerDeps, "setTimeout" | "clearTimeout">,
  debounceMs: number = DRAFT_DEBOUNCE_MS,
): DraftWriter<T> {
  let latest: { value: T } | null = null;
  let pending: unknown = null;

  const write = () => {
    if (!latest) return;
    try {
      storage.setItem(key, JSON.stringify(latest.value));
    } catch {
      // storage full / disabled
    }
  };

  const cancel = () => {
    if (pending != null) timers.clearTimeout(pending);
    pending = null;
  };

  return {
    schedule(value) {
      latest = { value };
      cancel();
      pending = timers.setTimeout(() => {
        pending = null;
        write();
      }, debounceMs);
    },
    flush() {
      cancel();
      write();
    },
  };
}
