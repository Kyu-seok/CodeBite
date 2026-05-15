export type Confidence = "AGAIN" | "HARD" | "GOOD" | "EASY";

export interface ReviewState {
  problemId: number;
  reviewCount: number;
  easeFactor: number;
  intervalDays: number;
  lastReviewedAt: string;
  lastConfidence: Confidence;
  nextDueAt: string;
  mastered: boolean;
}

export interface SetReviewRequest {
  confidence: Confidence;
  notes?: string | null;
}

export interface ReviewHistoryItem {
  submissionId: number;
  problemSlug: string;
  problemTitle: string;
  problemNumber: number | null;
  difficulty: "EASY" | "MEDIUM" | "HARD";
  tags: string[];
  language: string;
  status:
    | "PENDING"
    | "ACCEPTED"
    | "WRONG_ANSWER"
    | "TIME_LIMIT_EXCEEDED"
    | "RUNTIME_ERROR"
    | "COMPILATION_ERROR"
    | "INTERNAL_ERROR";
  confidence: Confidence;
  reviewedAt: string;
  solveTimeSeconds: number | null;
}

export interface ReviewHistoryFilters {
  confidence?: Confidence;
  difficulty?: "EASY" | "MEDIUM" | "HARD";
  tag?: string;
  page?: number;
  size?: number;
}

export interface ReviewHistoryPage {
  content: ReviewHistoryItem[];
  totalPages: number;
  totalElements: number;
  number: number;
  size: number;
}

export interface TagConfidenceItem {
  tagSlug: string;
  tagName: string;
  again: number;
  hard: number;
  good: number;
  easy: number;
}

export interface ReviewStats {
  totalReviews: number;
  totalSolveTimeSeconds: number;
  currentStreak: number;
  longestStreak: number;
}

export interface RatingHistoryItem {
  submissionId: number;
  confidence: Confidence;
  reviewedAt: string;
  language: string;
  status:
    | "PENDING"
    | "ACCEPTED"
    | "WRONG_ANSWER"
    | "TIME_LIMIT_EXCEEDED"
    | "RUNTIME_ERROR"
    | "COMPILATION_ERROR"
    | "INTERNAL_ERROR";
}

export interface DueReviewItem {
  problemId: number;
  slug: string;
  title: string;
  problemNumber: number | null;
  difficulty: "EASY" | "MEDIUM" | "HARD";
  tags: string[];
  lastConfidence: Confidence;
  lastReviewedAt: string;
  nextDueAt: string;
  daysOverdue: number;
}

export interface DueReviewsPage {
  content: DueReviewItem[];
  totalPages: number;
  totalElements: number;
  number: number;
  size: number;
}
