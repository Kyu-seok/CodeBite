import { useCallback, useEffect, useRef, useState } from 'react';

/** Feedback after an action, such as "Copied", that shows for a moment, then reverts to idle. */
export type FlashState = 'idle' | 'success' | 'error';

/** The current feedback and a function that shows one for `ms` (1.5s), restarting on each call. */
export function useFlash(ms = 1500): [FlashState, (state: FlashState) => void] {
  const [state, setState] = useState<FlashState>('idle');
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => () => {
    if (timer.current) clearTimeout(timer.current);
  }, []);

  const flash = useCallback(
    (next: FlashState) => {
      setState(next);
      if (timer.current) clearTimeout(timer.current);
      timer.current = setTimeout(() => setState('idle'), ms);
    },
    [ms],
  );

  return [state, flash];
}
