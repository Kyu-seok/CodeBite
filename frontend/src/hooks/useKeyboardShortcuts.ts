import { useEffect, useCallback } from 'react';

export function useKeyboardShortcuts(
  onRun: () => void,
  onSubmit: () => void,
  disabled: boolean,
) {
  const handleKeyDown = useCallback(
    (e: KeyboardEvent) => {
      if (disabled) return;

      const isMod = e.metaKey || e.ctrlKey;
      if (!isMod) return;

      if (e.key === "'" && !e.shiftKey) {
        e.preventDefault();
        onRun();
      } else if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        onSubmit();
      }
    },
    [onRun, onSubmit, disabled],
  );

  useEffect(() => {
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [handleKeyDown]);
}
