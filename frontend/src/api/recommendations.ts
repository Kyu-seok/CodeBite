import client from "./client";
import type { Difficulty } from "../types/problem";

export interface WeakCategoryItem {
  tagSlug: string;
  tagName: string;
  avgConfidence: number; // 1.0..4.0
  ratedSubmissionCount: number;
}

export interface RoadmapNextProblem {
  slug: string;
  title: string;
  difficulty: Difficulty;
}

export interface RoadmapNextItem {
  categorySlug: string;
  categoryName: string;
  description: string | null;
  unsolvedProblems: RoadmapNextProblem[];
}

export function getWeakTags(limit = 3) {
  return client.get<WeakCategoryItem[]>("/recommendations/weak-tags", {
    params: { limit },
  });
}

export function getRoadmapNext() {
  return client.get<RoadmapNextItem[]>("/recommendations/roadmap-next");
}
