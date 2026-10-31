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
