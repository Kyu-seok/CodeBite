import client from "./client";
import type {
  DueReviewsPage,
  RatingHistoryItem,
  ReviewHistoryFilters,
  ReviewHistoryPage,
  ReviewState,
  ReviewStats,
  SetReviewRequest,
  TagConfidenceItem,
} from "../types/review";

/** Fired on `window` after a confidence rating is saved or cleared, so review views refetch. */
export const REVIEW_CHANGED_EVENT = "codebite:review-changed";

function notifyReviewChanged() {
  window.dispatchEvent(new Event(REVIEW_CHANGED_EVENT));
}

export async function setSubmissionReview(id: number, body: SetReviewRequest) {
  const res = await client.put<ReviewState>(`/submissions/${id}/review`, body);
  notifyReviewChanged();
  return res;
}

export async function clearSubmissionReview(id: number) {
  const res = await client.delete(`/submissions/${id}/review`);
  notifyReviewChanged();
  return res;
}

export function getReviewHistory(slug: string) {
  return client.get<RatingHistoryItem[]>(`/problems/${slug}/review-history`);
}

export function getReviewState(slug: string) {
  return client.get<ReviewState | "">(`/problems/${slug}/review-state`, {
    // 204 No Content arrives as empty body; axios returns "" for it
    validateStatus: (s) => s === 200 || s === 204,
  });
}

export function getDueReviews(page = 0, size = 10) {
  return client.get<DueReviewsPage>("/reviews/due", { params: { page, size } });
}

export function getDueCount() {
  return client.get<{ count: number }>("/reviews/due/count");
}

export function getReviewStats() {
  return client.get<ReviewStats>("/reviews/stats");
}

export function getReviewActivity(months = 12) {
  return client.get<{ date: string; count: number }[]>("/reviews/activity", {
    params: { months },
  });
}

export function getTagConfidence() {
  return client.get<TagConfidenceItem[]>("/reviews/tag-confidence");
}

export function getReviewHistoryFiltered(filters: ReviewHistoryFilters = {}) {
  const params: Record<string, string | number> = {
    page: filters.page ?? 0,
    size: filters.size ?? 20,
  };
  if (filters.confidence) params.confidence = filters.confidence;
  if (filters.difficulty) params.difficulty = filters.difficulty;
  if (filters.tag) params.tag = filters.tag;
  return client.get<ReviewHistoryPage>("/reviews/history", { params });
}
