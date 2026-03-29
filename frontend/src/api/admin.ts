import client from './client';
import type {
  AdminProblemListItem,
  AdminProblemDetail,
  TestCaseDto,
  TagDto,
  CreateProblemRequest,
  UpdateProblemRequest,
  CreateTestCaseRequest,
  OverviewStats,
  DailySubmission,
  ProblemAnalytics,
  AdminRecentSubmission,
  AdminUser,
} from '../types/admin';

// ── Problems ──

export function listProblems(params?: {
  page?: number;
  size?: number;
  difficulty?: string;
  search?: string;
  published?: boolean;
}) {
  return client.get<{ content: AdminProblemListItem[]; totalPages: number; totalElements: number }>(
    '/admin/problems',
    { params },
  );
}

export function getProblem(id: number) {
  return client.get<AdminProblemDetail>(`/admin/problems/${id}`);
}

export function createProblem(data: CreateProblemRequest) {
  return client.post<AdminProblemDetail>('/admin/problems', data);
}

export function updateProblem(id: number, data: UpdateProblemRequest) {
  return client.put<AdminProblemDetail>(`/admin/problems/${id}`, data);
}

export function deleteProblem(id: number) {
  return client.delete(`/admin/problems/${id}`);
}

// ── Test Cases ──

export function getTestCases(problemId: number) {
  return client.get<TestCaseDto[]>(`/admin/problems/${problemId}/test-cases`);
}

export function addTestCase(problemId: number, data: CreateTestCaseRequest) {
  return client.post<TestCaseDto>(`/admin/problems/${problemId}/test-cases`, data);
}

export function updateTestCase(problemId: number, testCaseId: number, data: CreateTestCaseRequest) {
  return client.put<TestCaseDto>(`/admin/problems/${problemId}/test-cases/${testCaseId}`, data);
}

export function deleteTestCase(problemId: number, testCaseId: number) {
  return client.delete(`/admin/problems/${problemId}/test-cases/${testCaseId}`);
}

// ── Tags ──

export function listTags() {
  return client.get<TagDto[]>('/admin/problems/tags');
}

export function getProblemTags(problemId: number) {
  return client.get<string[]>(`/admin/problems/${problemId}/tags`);
}

export function updateProblemTags(problemId: number, tagIds: number[]) {
  return client.put<string[]>(`/admin/problems/${problemId}/tags`, tagIds);
}

// ── Analytics ──

export function getOverviewStats() {
  return client.get<OverviewStats>('/admin/analytics/overview');
}

export function getDailySubmissions(days = 30) {
  return client.get<DailySubmission[]>('/admin/analytics/submissions', { params: { days } });
}

export function getProblemAnalytics() {
  return client.get<ProblemAnalytics[]>('/admin/analytics/problems');
}

export function getRecentSubmissions(limit = 10) {
  return client.get<AdminRecentSubmission[]>('/admin/analytics/recent-submissions', { params: { limit } });
}

export function getUsers(page = 0, size = 50) {
  return client.get<{ content: AdminUser[]; totalPages: number; totalElements: number }>(
    '/admin/analytics/users',
    { params: { page, size } },
  );
}
