import { useEffect, useCallback } from 'react';

// Shortcuts typed into a dialog (settings, report, review rating) belong to
// that dialog, not to the code behind it.
const DIALOG_SELECTOR = '[role="dialog"], [role="alertdialog"]';

function isInsideDialog(target: EventTarget | null): boolean {
  return target instanceof Element && target.closest(DIALOG_SELECTOR) !== null;
}

// Page-level Run/Submit shortcuts. Inside the editor Monaco handles the same
// keys itself and stops propagation, so this only fires elsewhere on the page.
export function useKeyboardShortcuts(
  onRun: () => void,
  onSubmit: () => void,
  disabled: boolean,
) {
  const handleKeyDown = useCallback(
    (e: KeyboardEvent) => {
      if (disabled) return;
      // Already handled by someone else (e.g. Monaco, a focused widget).
      if (e.defaultPrevented) return;
      // A held key must not fire a second Run/Submit once the first finishes.
      if (e.repeat) return;
      // Hangul (and other IME) composition: Enter commits the syllable.
      // Safari reports the committing keydown as isComposing=false with
      // keyCode 229, so the deprecated keyCode check is still needed.
      if (e.isComposing || e.keyCode === 229) return;

      const isMod = e.metaKey || e.ctrlKey;
      // Alt excludes AltGr (Ctrl+Alt on Windows), which types characters.
      if (!isMod || e.shiftKey || e.altKey) return;
      if (isInsideDialog(e.target)) return;

      // Match the physical key too, as Monaco's KeyCode.Quote does, so the
      // shortcut works on layouts where that key isn't an apostrophe.
      if (e.key === "'" || e.code === 'Quote') {
        e.preventDefault();
        onRun();
      } else if (e.key === 'Enter') {
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
