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

export type GitHubRepositoryVisibility = "public" | "private";

/** The two GitHub pages of linking a Solution Repository. */
export interface GitHubInstallUrl {
  /** Installs the CodeBite GitHub App; the state remembers the chosen repository name. */
  installUrl: string;
  /** GitHub's new-repository page, prefilled with the chosen name and visibility. */
  createRepositoryUrl: string;
}
