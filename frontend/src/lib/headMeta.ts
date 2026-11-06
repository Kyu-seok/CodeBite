/**
 * What a page puts in <head> for search engines and link unfurlers, as data: the hook
 * (useDocumentMeta) writes it into the DOM. Kept free of the DOM so it can be tested.
 */

/** The canonical origin every page links itself under, whatever host served it (www, a preview). */
export const SITE_ORIGIN = "https://code-bite.com"

export interface PageMeta {
  /** The tab title; also the Open Graph title. */
  title: string
  /** The snippet search engines and unfurlers show; at most ~160 characters. */
  description?: string
  /** The route's canonical path (no query string): its canonical link and og:url. */
  path?: string
  /** A page that exists only to say something is missing: search engines must not index it. */
  noindex?: boolean
}

export interface HeadTag {
  tag: "meta" | "link"
  attrs: Record<string, string>
}

/** The tags {@code meta} needs, in document order; none for a field that isn't set. */
export function headTags(meta: PageMeta, origin: string = SITE_ORIGIN): HeadTag[] {
  const tags: HeadTag[] = []
  if (meta.noindex) {
    tags.push({ tag: "meta", attrs: { name: "robots", content: "noindex" } })
  }
  if (meta.description) {
    tags.push({ tag: "meta", attrs: { name: "description", content: meta.description } })
  }
  tags.push({ tag: "meta", attrs: { property: "og:title", content: meta.title } })
  if (meta.description) {
    tags.push({ tag: "meta", attrs: { property: "og:description", content: meta.description } })
  }
  if (meta.path && !meta.noindex) {
    const url = origin + meta.path
    tags.push({ tag: "link", attrs: { rel: "canonical", href: url } })
    tags.push({ tag: "meta", attrs: { property: "og:url", content: url } })
  }
  return tags
}

const MAX_SUMMARY = 160

/**
 * A problem statement's opening as a one-line description: Markdown, code and diagram blocks
 * dropped, cut at a word boundary within {@link MAX_SUMMARY} characters.
 */
export function problemSummary(description: string): string {
  const text = description
    .replace(/```[\s\S]*?```/g, " ")
    .replace(/`([^`]*)`/g, "$1")
    .replace(/!?\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replace(/[*_]+/g, "")
    .replace(/^[#>]+\s*/gm, "")
    .replace(/\s+/g, " ")
    .trim()
  if (text.length <= MAX_SUMMARY) return text
  const cut = text.slice(0, MAX_SUMMARY - 1)
  const lastSpace = cut.lastIndexOf(" ")
  return (lastSpace > MAX_SUMMARY / 2 ? cut.slice(0, lastSpace) : cut) + "…"
}
