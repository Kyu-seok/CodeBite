import type { Difficulty } from './problem';

export interface AdminProblemListItem {
  id: number;
  title: string;
  slug: string;
  difficulty: Difficulty;
  tags: string[];
  status: string | null;
  acceptanceRate: number | null;
}

export interface AdminProblemDetail {
  id: number;
  title: string;
  slug: string;
  description: string;
  difficulty: Difficulty;
  starterCode: Record<string, string>;
  constraints: string | null;
  published: boolean;
  sampleTestCases: TestCaseDto[];
  createdAt: string;
  updatedAt: string;
}

export interface TestCaseDto {
  id: number;
  input: string;
  expectedOutput: string;
  sample: boolean;
  orderIndex: number;
}

export interface TagDto {
  id: number;
  name: string;
  slug: string;
}

export interface CreateProblemRequest {
  title: string;
  description: string;
  difficulty: Difficulty;
  constraints?: string;
  published?: boolean;
}

export interface UpdateProblemRequest {
  title?: string;
  description?: string;
  difficulty?: Difficulty;
  constraints?: string;
  published?: boolean;
}

export interface CreateTestCaseRequest {
  input: string;
  expectedOutput: string;
  sample?: boolean;
  orderIndex?: number;
}

// ── Analytics ──

export interface OverviewStats {
  totalUsers: number;
  totalProblems: number;
  totalSubmissions: number;
  submissionsToday: number;
}

export interface DailySubmission {
  date: string;
  count: number;
}

export interface ProblemAnalytics {
  id: number;
  title: string;
  slug: string;
  difficulty: Difficulty;
  totalSubmissions: number;
  acceptedCount: number;
  acceptanceRate: number;
}

export interface AdminRecentSubmission {
  id: number;
  username: string;
  problemTitle: string;
  problemSlug: string;
  status: string;
  language: string;
  runtimeMs: number | null;
  createdAt: string;
}

export interface AdminUser {
  id: number;
  username: string;
  email: string;
  role: string;
  avatarUrl: string | null;
  createdAt: string;
  solvedCount: number;
  lastActiveAt: string | null;
}
