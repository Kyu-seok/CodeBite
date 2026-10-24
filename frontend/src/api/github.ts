import client from "./client";
import type {
  GitHubInstallUrl,
  GitHubLink,
  GitHubLinkCallbackResponse,
} from "../types/github";

/** The current GitHub Link, or `null` when the user has none (204). */
export async function getGitHubLink(): Promise<GitHubLink | null> {
  const res = await client.get<GitHubLink | "">("/github/link");
  return res.status === 204 || !res.data ? null : res.data;
}

/** The GitHub App install page, carrying a state bound to the signed-in user. */
export function getGitHubInstallUrl() {
  return client.get<GitHubInstallUrl>("/github/link/install");
}

/** Sends the browser to the GitHub App install page; GitHub returns to `/github/callback`. */
export async function startGitHubInstall() {
  const res = await getGitHubInstallUrl();
  window.location.assign(res.data.installUrl);
}

/** Completes the install GitHub redirected back to `/github/callback` from. */
export function completeGitHubLink(code: string, installationId: number, state: string) {
  return client.post<GitHubLinkCallbackResponse>("/github/link/callback", {
    code,
    installationId,
    state,
  });
}

/** Chooses the Solution Repository after an install granted several. */
export function chooseGitHubRepository(selectionToken: string, repositoryId: number) {
  return client.put<GitHubLink>("/github/link/repository", { selectionToken, repositoryId });
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
