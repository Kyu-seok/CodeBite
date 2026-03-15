import client from "./client";
import type { ProblemDetail, ProblemListItem } from "../types/problem";
import type { Difficulty } from "../types/problem";
import type { PageResponse } from "../types/api";

export function getProblems(page = 0, size = 20, difficulty?: Difficulty) {
  return client.get<PageResponse<ProblemListItem>>("/problems", {
    params: { page, size, difficulty },
  });
}

export function getProblemBySlug(slug: string) {
  return client.get<ProblemDetail>(`/problems/${slug}`);
}
