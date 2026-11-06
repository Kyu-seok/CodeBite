import { describe, expect, it } from "vitest"
import { headTags, problemSummary } from "./headMeta"

describe("headTags", () => {
  it("links a page to its canonical URL and describes it", () => {
    const tags = headTags(
      { title: "Problems | CodeBite", description: "All the problems.", path: "/problems" },
      "https://code-bite.com",
    )
    expect(tags).toEqual([
      { tag: "meta", attrs: { name: "description", content: "All the problems." } },
      { tag: "meta", attrs: { property: "og:title", content: "Problems | CodeBite" } },
      { tag: "meta", attrs: { property: "og:description", content: "All the problems." } },
      { tag: "link", attrs: { rel: "canonical", href: "https://code-bite.com/problems" } },
      { tag: "meta", attrs: { property: "og:url", content: "https://code-bite.com/problems" } },
    ])
  })

  it("marks a missing page noindex and gives it no canonical", () => {
    const tags = headTags({ title: "Not found", noindex: true, path: "/problems/gone" })
    expect(tags).toEqual([
      { tag: "meta", attrs: { name: "robots", content: "noindex" } },
      { tag: "meta", attrs: { property: "og:title", content: "Not found" } },
    ])
  })

  it("emits only the title when nothing else is known", () => {
    expect(headTags({ title: "CodeBite" })).toEqual([
      { tag: "meta", attrs: { property: "og:title", content: "CodeBite" } },
    ])
  })
})

describe("problemSummary", () => {
  it("drops Markdown, code and diagram blocks", () => {
    const text =
      "Given an array `nums`, return **the sum**.\n\n```diagram-array\nnums: [1,2]\n```\n\nSee [docs](https://x.y)."
    expect(problemSummary(text)).toBe("Given an array nums, return the sum. See docs.")
  })

  it("cuts a long statement at a word boundary with an ellipsis", () => {
    const text = Array.from({ length: 40 }, (_, i) => `word${i}`).join(" ")
    const summary = problemSummary(text)
    expect(summary.length).toBeLessThanOrEqual(160)
    expect(summary.endsWith("…")).toBe(true)
    const kept = summary.slice(0, -1)
    expect(text.startsWith(kept)).toBe(true)
    expect(text[kept.length]).toBe(" ") // the cut falls between words, never inside one
  })

  it("keeps a short statement as it is", () => {
    expect(problemSummary("Return the larger of two numbers.")).toBe("Return the larger of two numbers.")
  })
})
