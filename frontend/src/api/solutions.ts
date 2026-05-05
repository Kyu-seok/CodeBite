import client from "./client"
import type {
  CreateCommentRequest,
  CreateSolutionRequest,
  ReportRequest,
  SolutionComment,
  SolutionDetail,
  SolutionListItem,
  SolutionSort,
  UpdateCommentRequest,
  UpdateSolutionRequest,
  VoteRequest,
  VoteResponse,
} from "@/types/solution"

interface PageResponse<T> {
  content: T[]
  totalElements: number
  totalPages: number
  number: number
  size: number
}

export interface ListSolutionsParams {
  language?: string
  tag?: string
  search?: string
  sort?: SolutionSort
  page?: number
  size?: number
}

export function listSolutions(slug: string, params: ListSolutionsParams = {}) {
  return client.get<PageResponse<SolutionListItem>>(`/problems/${slug}/solutions`, {
    params,
  })
}

export function getSolution(id: number) {
  return client.get<SolutionDetail>(`/solutions/${id}`)
}

export function createSolution(slug: string, data: CreateSolutionRequest) {
  return client.post<SolutionDetail>(`/problems/${slug}/solutions`, data)
}

export function updateSolution(id: number, data: UpdateSolutionRequest) {
  return client.put<SolutionDetail>(`/solutions/${id}`, data)
}

export function deleteSolution(id: number) {
  return client.delete(`/solutions/${id}`)
}

export function voteSolution(id: number, data: VoteRequest) {
  return client.post<VoteResponse>(`/solutions/${id}/vote`, data)
}

export function clearVote(id: number) {
  return client.delete<VoteResponse>(`/solutions/${id}/vote`)
}

export function listComments(id: number, page = 0, size = 20) {
  return client.get<PageResponse<SolutionComment>>(`/solutions/${id}/comments`, {
    params: { page, size },
  })
}

export function createComment(id: number, data: CreateCommentRequest) {
  return client.post<SolutionComment>(`/solutions/${id}/comments`, data)
}

export function updateComment(commentId: number, data: UpdateCommentRequest) {
  return client.put<SolutionComment>(`/comments/${commentId}`, data)
}

export function deleteComment(commentId: number) {
  return client.delete(`/comments/${commentId}`)
}

export function reportSolution(id: number, data: ReportRequest) {
  return client.post(`/solutions/${id}/report`, data)
}

export function reportComment(commentId: number, data: ReportRequest) {
  return client.post(`/comments/${commentId}/report`, data)
}
