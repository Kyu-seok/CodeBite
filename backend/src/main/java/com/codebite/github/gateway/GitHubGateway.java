package com.codebite.github.gateway;

/**
 * The single seam through which CodeBite talks to GitHub, as the CodeBite GitHub App (ADR 0003).
 *
 * <p>Every operation authenticates on demand: user tokens and installation tokens are minted per
 * call and never stored. Failures surface as {@link GitHubGatewayException} subtypes so callers
 * can tell a retryable outage ({@link GitHubTransientException}) from a GitHub Link that can no
 * longer work ({@link GitHubInstallationGoneException}).
 *
 * <p>Tests replace this with {@code FakeGitHubGateway}; the real adapter is {@link GitHubAppGateway}.
 */
public interface GitHubGateway {

    /**
     * Resolves the redirect GitHub sends after the user installs the App.
     *
     * @param authorizationCode the user authorization code from the callback
     * @param installationId    the installation id from the callback, which is untrusted input
     * @return the GitHub account that authorised the App and the repositories the installation
     *         grants
     * @throws GitHubInstallationNotAccessibleException if the code is rejected or the account
     *         cannot access {@code installationId}. That check stops anyone binding a GitHub Link
     *         to an installation they did not authorise.
     */
    ResolvedInstallation resolveInstallCallback(String authorizationCode, long installationId);

    /**
     * Adds one new file to a repository's branch as a single commit, authored as
     * {@code file.author()} at {@code file.authorDate()}. The committer is the App.
     *
     * @param installationId     the installation that grants access to the repository
     * @param repositoryFullName {@code owner/name}
     * @param branch             the branch to commit to, normally the default branch
     * @return the new commit
     * @throws GitHubFileExistsException       if {@code file.path()} already exists; nothing is
     *         replaced
     * @throws GitHubInstallationGoneException if the installation or repository is gone
     * @throws GitHubTransientException        on an outage worth retrying
     */
    CommittedFile addFile(long installationId, String repositoryFullName, String branch, NewFile file);
}
