import { useDocumentMeta } from "./useDocumentMeta";

/**
 * Sets the tab title while the page is mounted and puts the previous one back when it leaves,
 * so a page that sets no title of its own doesn't inherit "Sign-in failed" or "Page not found".
 * A page search engines should describe or index uses useDocumentMeta directly.
 */
export function useDocumentTitle(title: string) {
  useDocumentMeta({ title });
}
