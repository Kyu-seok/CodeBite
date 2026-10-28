import { useEffect, useRef } from "react";
import { getStreamToken, getSubmission, submissionStreamUrl } from "@/api/submissions";
import { watchSubmission, type WatchDeps, type WatchEvent } from "@/judge/watchSubmission";

/**
 * The real parties behind the watch: axios, EventSource and the window's timers. Deliberately
 * dumb and kept short; the machine it feeds is the part under test.
 */
export const browserWatchDeps: WatchDeps = {
  getSubmission: (id) => getSubmission(id).then((res) => res.data),
  async openStream(id) {
    // 404 means SSE is unavailable server-side (no Redis); the rejection sends the watch to polling.
    const { data } = await getStreamToken(id);
    const source = new EventSource(submissionStreamUrl(id, data.token));
    return {
      onResult: (cb) => source.addEventListener("result", cb),
      onClosed: (cb) => {
        source.onerror = () => {
          // EventSource retries on its own; only step in once it has actually given up.
          if (source.readyState === EventSource.CLOSED) cb();
        };
      },
      close: () => source.close(),
    };
  },
  now: () => Date.now(),
  setTimeout: (fn, ms) => window.setTimeout(fn, ms),
  clearTimeout: (handle) => window.clearTimeout(handle as number),
};

/**
 * Watches submission `id` until it settles or fails, then calls `onEvent` exactly once. Passing
 * null, changing the id or unmounting stops the watch. The latest `onEvent` is the one called,
 * so it may close over the page's current state.
 */
export function useSubmissionWatch(id: number | null, onEvent: (ev: WatchEvent) => void) {
  const latest = useRef(onEvent);
  latest.current = onEvent;
  useEffect(() => {
    if (id == null) return;
    const watch = watchSubmission(id, browserWatchDeps);
    watch.subscribe((ev) => latest.current(ev));
    return watch.stop;
  }, [id]);
}
