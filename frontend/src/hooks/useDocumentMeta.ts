import { useEffect } from "react"
import { headTags, type PageMeta } from "@/lib/headMeta"

/** Marks the tags this hook owns, so a page replaces the previous page's (and index.html's). */
const OWNED = "data-page-meta"

/**
 * Sets the tab title and the page's <head> tags (description, canonical, Open Graph, robots)
 * while the page is mounted, and puts back what it replaced when the page leaves, so a page that
 * sets nothing inherits neither "Sign-in failed" nor the previous page's canonical. A page that
 * sets only a title keeps the tags already there (index.html's description). Pass null while the
 * page doesn't know yet what it shows.
 */
export function useDocumentMeta(meta: PageMeta | null) {
  const title = meta?.title
  const description = meta?.description
  const path = meta?.path
  const noindex = meta?.noindex ?? false
  // Compared as text: a graph built on each render is a new object with the same content.
  const jsonLd = meta?.jsonLd ? JSON.stringify(meta.jsonLd) : undefined

  useEffect(() => {
    if (title === undefined) return
    const previousTitle = document.title
    document.title = title
    const ownsHead = description !== undefined || path !== undefined || noindex || jsonLd !== undefined
    if (!ownsHead) {
      return () => {
        document.title = previousTitle
      }
    }
    const replaced = Array.from(document.head.querySelectorAll(`[${OWNED}]`))
    replaced.forEach((el) => el.remove())
    const owned: HTMLElement[] = headTags({ title, description, path, noindex }).map(({ tag, attrs }) => {
      const el = document.createElement(tag)
      for (const [name, value] of Object.entries(attrs)) el.setAttribute(name, value)
      return el
    })
    if (jsonLd) {
      const script = document.createElement("script")
      script.type = "application/ld+json"
      script.text = jsonLd
      owned.push(script)
    }
    for (const el of owned) {
      el.setAttribute(OWNED, "")
      document.head.appendChild(el)
    }
    return () => {
      document.title = previousTitle
      owned.forEach((el) => el.remove())
      replaced.forEach((el) => document.head.appendChild(el))
    }
  }, [title, description, path, noindex, jsonLd])
}
