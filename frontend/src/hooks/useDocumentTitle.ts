import { useEffect } from "react";

/**
 * Sets the tab title while the page is mounted and puts the previous one back when it leaves,
 * so a page that sets no title of its own doesn't inherit "Sign-in failed" or "Page not found".
 */
export function useDocumentTitle(title: string) {
  useEffect(() => {
    const previous = document.title;
    document.title = title;
    return () => {
      document.title = previous;
    };
  }, [title]);
}
