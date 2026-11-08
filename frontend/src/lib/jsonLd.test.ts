import { describe, expect, it } from "vitest"
import { problemGraph, siteGraph } from "./jsonLd"

type Node = Record<string, unknown> & { "@type": string }
const nodes = (graph: object) => (graph as { "@graph": Node[] })["@graph"]

describe("siteGraph", () => {
  it("describes the organization, the site and the free web application under one origin", () => {
    const graph = siteGraph("https://code-bite.test")
    expect(nodes(graph).map((n) => n["@type"])).toEqual(["Organization", "WebSite", "WebApplication"])
    const app = nodes(graph)[2]
    expect(app.url).toBe("https://code-bite.test/")
    expect(app.offers).toEqual({ "@type": "Offer", price: "0", priceCurrency: "USD" })
    expect(nodes(graph)[1].publisher).toEqual({ "@id": "https://code-bite.test/#organization" })
  })
})

describe("problemGraph", () => {
  const problem = {
    title: "Group Anagrams",
    slug: "group-anagrams",
    description: "Given an array of strings, group the anagrams.",
    difficulty: "MEDIUM" as const,
    tags: [{ name: "Arrays & Hashing", slug: "arrays-and-hashing" }],
    createdAt: "2026-03-20T09:45:11.525089Z",
    updatedAt: "2026-04-01T00:00:00Z",
  }

  it("walks Problems › topic › problem and links the topic's filter", () => {
    const [, crumbs] = nodes(problemGraph(problem, "en", "https://code-bite.test"))
    expect(crumbs.itemListElement).toEqual([
      { "@type": "ListItem", position: 1, name: "Problems", item: "https://code-bite.test/problems" },
      {
        "@type": "ListItem",
        position: 2,
        name: "Arrays & Hashing",
        item: "https://code-bite.test/problems?tag=arrays-and-hashing",
      },
      {
        "@type": "ListItem",
        position: 3,
        name: "Group Anagrams",
        item: "https://code-bite.test/problems/group-anagrams",
      },
    ])
  })

  it("describes the problem as a free practice resource in the page's language, with dates as days", () => {
    const [page, , resource] = nodes(problemGraph(problem, "ko", "https://code-bite.test"))
    expect(resource).toMatchObject({
      "@type": "LearningResource",
      learningResourceType: "Practice problem",
      educationalLevel: "Intermediate",
      isAccessibleForFree: true,
      inLanguage: "ko",
      teaches: "Arrays & Hashing",
      keywords: ["Arrays & Hashing"],
      dateCreated: "2026-03-20",
      dateModified: "2026-04-01",
    })
    expect(page.mainEntity).toEqual({ "@id": "https://code-bite.test/problems/group-anagrams#problem" })
  })

  it("skips the topic level when the problem has no tag", () => {
    const [, crumbs, resource] = nodes(problemGraph({ ...problem, tags: [] }, "en"))
    expect((crumbs.itemListElement as unknown[]).length).toBe(2)
    expect(resource).not.toHaveProperty("teaches")
  })
})
