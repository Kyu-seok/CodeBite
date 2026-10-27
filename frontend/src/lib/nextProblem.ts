import { getDueReviews } from "@/api/reviews";
import { getRoadmapNext } from "@/api/recommendations";

/** Where to go after an Accepted problem is rated. */
export type NextProblem =
  | { kind: "review"; slug: string; title: string }
  | { kind: "roadmap"; slug: string; title: string }
  | { kind: "list" };

/**
 * Picks the next thing to practise, in order: the first due review, then the next
 * unsolved problem on the roadmap, then the problem list. The problem just solved is
 * never offered. A failed lookup falls through to the next source.
 */
export async function findNextProblem(currentSlug: string): Promise<NextProblem> {
  try {
    const due = await getDueReviews(0, 5);
    const item = due.data.content.find((d) => d.slug !== currentSlug);
    if (item) return { kind: "review", slug: item.slug, title: item.title };
  } catch {
    // fall through
  }
  try {
    const roadmap = await getRoadmapNext();
    for (const category of roadmap.data) {
      const problem = category.unsolvedProblems.find((p) => p.slug !== currentSlug);
      if (problem) return { kind: "roadmap", slug: problem.slug, title: problem.title };
    }
  } catch {
    // fall through
  }
  return { kind: "list" };
}
