import { useEffect } from "react"
import { headTags, type PageMeta } from "@/lib/headMeta"

/** Marks the tags this hook owns, so a page replaces the previous page's (and index.html's). */
const OWNED = "data-page-meta"

/**
 * Sets the tab title and the page's <head> tags (description, canonical, Open Graph, robots)
 * while the page is mounted, and puts the previous title back when it leaves, so a page that
 * sets nothing doesn't inherit "Sign-in failed" or "Page not found". Pass null while the page
 * doesn't know yet what it shows.
 */
export function useDocumentMeta(meta: PageMeta | null) {
  const title = meta?.title
  const description = meta?.description
  const path = meta?.path
  const noindex = meta?.noindex ?? false

  useEffect(() => {
    if (title === undefined) return
    const previous = document.title
    document.title = title
    document.head.querySelectorAll(`[${OWNED}]`).forEach((el) => el.remove())
    const owned = headTags({ title, description, path, noindex }).map(({ tag, attrs }) => {
      const el = document.createElement(tag)
      for (const [name, value] of Object.entries(attrs)) el.setAttribute(name, value)
      el.setAttribute(OWNED, "")
      document.head.appendChild(el)
      return el
    })
    return () => {
      document.title = previous
      owned.forEach((el) => el.remove())
    }
  }, [title, description, path, noindex])
}
