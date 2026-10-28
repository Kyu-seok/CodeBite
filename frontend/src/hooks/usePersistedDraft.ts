import { useEffect, useMemo, useState, type Dispatch, type SetStateAction } from "react";
import { createDraftWriter, readDraft } from "@/lib/persistedDraft";
import { browserTimers } from "@/lib/timers";

/**
 * State that survives a reload: read from localStorage under `key` on mount, written back
 * debounced on every change and at once on unmount, so a quick nav-away keeps the last
 * keystrokes. When `key` changes, the old key is flushed and the new one read.
 */
export function usePersistedDraft<T>(key: string, initial: T): [T, Dispatch<SetStateAction<T>>] {
  const [value, setValue] = useState<T>(() => readDraft(localStorage, key, initial));
  const [readKey, setReadKey] = useState(key);
  if (readKey !== key) {
    // The route changed under this page: show the new key's draft, not the old one's.
    setReadKey(key);
    setValue(readDraft(localStorage, key, initial));
  }

  const writer = useMemo(() => createDraftWriter<T>(localStorage, key, browserTimers), [key]);
  useEffect(() => {
    writer.schedule(value);
  }, [writer, value]);
  useEffect(() => () => writer.flush(), [writer]);

  return [value, setValue];
}
