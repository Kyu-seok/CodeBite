/**
 * Where Submit sends an anonymous user back to after signing in. The code they wrote waits in its
 * draft, but the language they wrote it in lives only in the page, and a signed-in user's recent
 * language would otherwise take its place; so the way back names it.
 */
export function submitReturnUrl(slug: string, language: string): string {
  return `/problems/${slug}?${new URLSearchParams({ lang: language })}`;
}

/** The language a way back from signing in names, when the problem has it. */
export function languageOnReturn(search: string, languages: readonly string[]): string | null {
  const lang = new URLSearchParams(search).get("lang");
  return lang != null && languages.includes(lang) ? lang : null;
}

/** The part of Storage the way back needs; tests pass a Map-backed fake. */
export interface ReturnStorage {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
  removeItem(key: string): void;
}

const KEY = "returnUrl";

/** Where signing in from a page comes back to: the page as it was, query string included. */
export function returnTarget(location: { pathname: string; search: string }): string {
  return location.pathname + location.search;
}

/** Remembers where to come back to after signing in; OAuthCallbackPage takes it. */
export function rememberReturn(target: string, storage: ReturnStorage = sessionStorage): void {
  storage.setItem(KEY, target);
}

/** The way back remembered before signing in, cleared so it is followed once; null when there is none. */
export function takeReturn(storage: ReturnStorage = sessionStorage): string | null {
  const target = storage.getItem(KEY);
  storage.removeItem(KEY);
  return target;
}
