package com.codebite.github.gateway;

import java.util.List;

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
     * Lists the repositories an installation grants right now, as the App. Only call this with an
     * installation id CodeBite already verified the user can access.
     *
     * @throws GitHubInstallationGoneException if the installation was removed or suspended
     */
    List<GitHubRepo> listInstallationRepositories(long installationId);
}
