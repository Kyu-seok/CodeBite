export type GitHubLinkStatus = "ACTIVE" | "BROKEN" | "UNLINKED";
export type GitHubImportState = "AVAILABLE" | "RUNNING" | "DONE" | "FAILED";

/** The signed-in user's GitHub Link. Mirrors the backend `GitHubLinkResponse`. */
export interface GitHubLink {
  githubAccountId: number;
  githubLogin: string;
  repositoryId: number;
  /** `owner/name` of the Solution Repository. */
  repositoryFullName: string;
  repositoryUrl: string;
  defaultBranch: string;
  /** Private repositories only show on the graph with "Include private contributions" on. */
  repositoryPrivate: boolean;
  status: GitHubLinkStatus;
  importState: GitHubImportState;
  createdAt: string;
}

export interface GitHubInstallUrl {
  installUrl: string;
}

export interface GitHubRepositoryOption {
  id: number;
  fullName: string;
  repositoryPrivate: boolean;
}

/**
 * Outcome of an install callback: `link` when exactly one repository was granted,
 * otherwise `null` with the granted `repositories`.
 */
export interface GitHubLinkCallbackResponse {
  link: GitHubLink | null;
  repositories: GitHubRepositoryOption[];
}
