import client from "./client";
import type { SubmissionResponse, SubmissionListItem, SubmitRequest, RunRequest, RunResponse } from "../types/submission";

export function submitCode(slug: string, data: SubmitRequest) {
  return client.post<SubmissionResponse>(`/problems/${slug}/submit`, data);
}

export function getSubmission(id: number) {
  return client.get<SubmissionResponse>(`/submissions/${id}`);
}

export function getSubmissionsByProblem(slug: string) {
  return client.get<SubmissionListItem[]>(`/problems/${slug}/submissions`);
}

export function runCode(slug: string, data: RunRequest) {
  return client.post<RunResponse>(`/problems/${slug}/run`, data);
}

export function updateSubmissionNote(id: number, notes: string) {
  return client.patch(`/submissions/${id}/note`, { notes });
}

export function setSolveTime(id: number, solveTimeSeconds: number) {
  return client.patch(`/submissions/${id}/solve-time`, { solveTimeSeconds });
}

export interface StreamTokenResponse {
  token: string;
  expiresInSeconds: number;
}

/**
 * Exchanges the stored JWT for a short-lived token that opens the result stream.
 * 404 means SSE is unavailable server-side (no Redis) — callers fall back to polling.
 */
export function getStreamToken(id: number) {
  return client.post<StreamTokenResponse>(`/submissions/${id}/stream-token`);
}

/**
 * Builds the EventSource URL. The token rides in the query string because EventSource
 * cannot set an Authorization header; it is scoped to this one submission and expires
 * in minutes, unlike the JWT.
 */
export function submissionStreamUrl(id: number, token: string) {
  const base = import.meta.env.VITE_API_URL || "/api";
  return `${base}/submissions/${id}/stream?token=${encodeURIComponent(token)}`;
}
