import client from "./client";
import type { ProblemDetail, ProblemListItem, ProblemStats } from "../types/problem";
import type { Difficulty } from "../types/problem";
import type { PageResponse } from "../types/api";
import type { Walkthrough } from "@/components/walkthrough/walkthrough.js";

export function getProblems(page = 0, size = 20, difficulty?: Difficulty, search?: string, sort?: string, tag?: string, curation?: string) {
  return client.get<PageResponse<ProblemListItem>>("/problems", {
    params: { page, size, difficulty, search: search || undefined, sort, tag: tag || undefined, curation: curation || undefined },
  });
}

export function getProblemBySlug(slug: string) {
  return client.get<ProblemDetail>(`/problems/${slug}`);
}

/** The problem's Walkthrough (format walkthrough/1); 404 when it has none (ProblemDetail.hasWalkthrough). */
export function getWalkthrough(slug: string) {
  return client.get<Walkthrough>(`/problems/${slug}/walkthrough`);
}

export function getProblemStats(curation?: string) {
  return client.get<ProblemStats>("/problems/stats", {
    params: { curation: curation || undefined },
  });
}

export function getRandomProblem(difficulty?: Difficulty) {
  return client.get<{ slug: string }>("/problems/random", {
    params: { difficulty },
  });
}
