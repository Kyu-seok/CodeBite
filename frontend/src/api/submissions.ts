import client from "./client";
import type { SubmissionResponse, SubmissionListItem, SubmitRequest, RunResponse } from "../types/submission";

export function submitCode(slug: string, data: SubmitRequest) {
  return client.post<SubmissionResponse>(`/problems/${slug}/submit`, data);
}

export function getSubmission(id: number) {
  return client.get<SubmissionResponse>(`/submissions/${id}`);
}

export function getSubmissionsByProblem(slug: string) {
  return client.get<SubmissionListItem[]>(`/problems/${slug}/submissions`);
}

export function runCode(slug: string, data: SubmitRequest) {
  return client.post<RunResponse>(`/problems/${slug}/run`, data);
}

export function updateSubmissionNote(id: number, notes: string) {
  return client.patch(`/submissions/${id}/note`, { notes });
}
