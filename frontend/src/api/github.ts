import client from "./client";
import type { GitHubInstallUrl, GitHubLink, GitHubRepositoryVisibility } from "../types/github";

/** The Solution Repository name suggested when linking. */
export const DEFAULT_REPOSITORY_NAME = "codebite-solutions";

const REPOSITORY_NAME_KEY = "codebite.github.repositoryName";

/** The current GitHub Link, or `null` when the user has none (204). */
export async function getGitHubLink(): Promise<GitHubLink | null> {
  const res = await client.get<GitHubLink | "">("/github/link");
  return res.status === 204 || !res.data ? null : res.data;
}

/** The GitHub pages that create the named Solution Repository and install the App on it. */
export function getGitHubInstallUrl(
  repositoryName: string,
  visibility: GitHubRepositoryVisibility = "public",
) {
  return client.get<GitHubInstallUrl>("/github/link/install", {
    params: { repositoryName, visibility },
  });
}

/** The name the user last chose to link, so the callback page can retry with it. */
export function rememberedRepositoryName() {
  try {
    return sessionStorage.getItem(REPOSITORY_NAME_KEY) ?? DEFAULT_REPOSITORY_NAME;
  } catch {
    return DEFAULT_REPOSITORY_NAME;
  }
}

/**
 * Sends the browser to the GitHub App install page for the named Solution Repository; GitHub
 * returns to `/github/callback`.
 */
export async function startGitHubInstall(repositoryName: string) {
  const res = await getGitHubInstallUrl(repositoryName);
  try {
    sessionStorage.setItem(REPOSITORY_NAME_KEY, repositoryName);
  } catch {
    // Only the callback page's retry uses it, and it falls back to the default name.
  }
  window.location.assign(res.data.installUrl);
}

/** Completes the install GitHub redirected back to `/github/callback` from. */
export function completeGitHubLink(code: string, installationId: number, state: string) {
  return client.post<GitHubLink>("/github/link/callback", {
    code,
    installationId,
    state,
  });
}

/**
 * Starts the Import of earlier Accepted submissions (202, import state RUNNING). 409 when it is
 * already RUNNING or DONE. It runs in the background: poll `getGitHubLink()` for the outcome.
 */
export function startGitHubImport() {
  return client.post<GitHubLink>("/github/link/import");
}

/** Unlinks the current GitHub Link. Stops future Solution Commits; the repository is untouched. */
export function unlinkGitHub() {
  return client.delete<void>("/github/link");
}
