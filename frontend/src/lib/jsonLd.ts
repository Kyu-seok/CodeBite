/**
 * Schema.org JSON-LD for the pages search engines describe: what the site is (one graph on the
 * landing page) and what a problem page is (its breadcrumb trail and the problem as a learning
 * resource). Plain data; useDocumentMeta writes it into <head>. Kept free of the DOM to be tested.
 */
import { SITE_ORIGIN } from "./headMeta"
import type { Difficulty, TagDto } from "@/types/problem"

const SITE_NAME = "CodeBite"
const GITHUB_URL = "https://github.com/Kyu-seok/CodeBite"

const EDUCATIONAL_LEVEL: Record<Difficulty, string> = {
  EASY: "Beginner",
  MEDIUM: "Intermediate",
  HARD: "Advanced",
}

function ids(origin: string) {
  return { organization: `${origin}/#organization`, website: `${origin}/#website`, app: `${origin}/#app` }
}

/** The site as an entity: who publishes it, what it is and what it offers. For the landing page. */
export function siteGraph(origin: string = SITE_ORIGIN): object {
  const id = ids(origin)
  return {
    "@context": "https://schema.org",
    "@graph": [
      {
        "@type": "Organization",
        "@id": id.organization,
        name: SITE_NAME,
        url: `${origin}/`,
        logo: { "@type": "ImageObject", url: `${origin}/logo.svg`, width: 512, height: 512 },
        sameAs: [GITHUB_URL],
      },
      {
        "@type": "WebSite",
        "@id": id.website,
        url: `${origin}/`,
        name: SITE_NAME,
        inLanguage: ["en", "ko"],
        publisher: { "@id": id.organization },
      },
      {
        "@type": "WebApplication",
        "@id": id.app,
        name: SITE_NAME,
        url: `${origin}/`,
        applicationCategory: "EducationalApplication",
        operatingSystem: "Any",
        browserRequirements: "Requires JavaScript",
        isAccessibleForFree: true,
        offers: { "@type": "Offer", price: "0", priceCurrency: "USD" },
        inLanguage: ["en", "ko"],
        publisher: { "@id": id.organization },
      },
    ],
  }
}

export interface ProblemForJsonLd {
  title: string
  slug: string
  /** Already shortened to a sentence or two (see problemSummary). */
  description: string
  difficulty: Difficulty
  tags?: TagDto[]
  createdAt: string
  updatedAt: string
}

/**
 * A problem page: its breadcrumb trail (Problems › topic › problem) and the problem as a
 * LearningResource, in the language the page is shown in.
 */
export function problemGraph(problem: ProblemForJsonLd, language: string, origin: string = SITE_ORIGIN): object {
  const id = ids(origin)
  const url = `${origin}/problems/${problem.slug}`
  const topic = problem.tags?.[0]
  const crumbs = [{ "@type": "ListItem", position: 1, name: "Problems", item: `${origin}/problems` }]
  if (topic) {
    crumbs.push({ "@type": "ListItem", position: 2, name: topic.name, item: `${origin}/problems?tag=${topic.slug}` })
  }
  crumbs.push({ "@type": "ListItem", position: crumbs.length + 1, name: problem.title, item: url })
  const resource: Record<string, unknown> = {
    "@type": "LearningResource",
    "@id": `${url}#problem`,
    name: problem.title,
    url,
    description: problem.description,
    learningResourceType: "Practice problem",
    educationalLevel: EDUCATIONAL_LEVEL[problem.difficulty],
    isAccessibleForFree: true,
    inLanguage: language,
    dateCreated: problem.createdAt.slice(0, 10),
    dateModified: problem.updatedAt.slice(0, 10),
    isPartOf: { "@id": id.website },
    provider: { "@id": id.organization },
  }
  if (topic) {
    resource.teaches = topic.name
    resource.keywords = problem.tags!.map((t) => t.name)
  }
  return {
    "@context": "https://schema.org",
    "@graph": [
      {
        "@type": "WebPage",
        "@id": `${url}#webpage`,
        url,
        name: `${problem.title} | ${SITE_NAME}`,
        isPartOf: { "@id": id.website },
        inLanguage: language,
        dateModified: problem.updatedAt.slice(0, 10),
        breadcrumb: { "@id": `${url}#breadcrumb` },
        mainEntity: { "@id": `${url}#problem` },
      },
      { "@type": "BreadcrumbList", "@id": `${url}#breadcrumb`, itemListElement: crumbs },
      resource,
    ],
  }
}
