export type VoteDirection = "UP" | "DOWN"
export type ReportTargetType = "SOLUTION" | "COMMENT"
export type ReportStatus = "OPEN" | "DISMISSED" | "RESOLVED"
export type SolutionSort = "NET_SCORE" | "RECENT" | "COMMENTS" | "OLDEST"
export type ResolveAction = "DISMISS" | "HIDE_CONTENT" | "DELETE_CONTENT"

export interface TagSummary {
  id: number
  name: string
  slug: string
}

export interface SolutionListItem {
  id: number
  title: string
  authorUsername: string
  authorAvatarUrl: string | null
  languages: string[]
  tags: TagSummary[]
  upvotesCount: number
  downvotesCount: number
  commentsCount: number
  createdAt: string
}

export interface SolutionDetail {
  id: number
  problemSlug: string
  title: string
  content: string
  authorUsername: string
  authorAvatarUrl: string | null
  authorId: number
  languages: string[]
  tags: TagSummary[]
  upvotesCount: number
  downvotesCount: number
  commentsCount: number
  viewsCount: number
  published: boolean
  sourceSubmissionId: number | null
  viewerVote: VoteDirection | null
  ownedByViewer: boolean
  createdAt: string
  updatedAt: string
}

export interface CreateSolutionRequest {
  title: string
  content: string
  languages: string[]
  tagSlugs: string[]
  fromSubmissionId?: number | null
}

export interface UpdateSolutionRequest {
  title: string
  content: string
  languages: string[]
  tagSlugs: string[]
}

export interface VoteRequest {
  direction: VoteDirection
}

export interface VoteResponse {
  viewerVote: VoteDirection | null
  upvotesCount: number
  downvotesCount: number
}

export interface SolutionComment {
  id: number
  solutionId: number
  parentCommentId: number | null
  authorUsername: string
  authorAvatarUrl: string | null
  authorId: number
  content: string
  edited: boolean
  ownedByViewer: boolean
  createdAt: string
  updatedAt: string
  replies: SolutionComment[]
}

export interface CreateCommentRequest {
  content: string
  parentCommentId?: number | null
}

export interface UpdateCommentRequest {
  content: string
}

export interface ReportRequest {
  reason: string
}

export interface ReportListItem {
  id: number
  targetType: ReportTargetType
  targetId: number
  reporterUsername: string
  reason: string
  status: ReportStatus
  preview: string
  createdAt: string
}
