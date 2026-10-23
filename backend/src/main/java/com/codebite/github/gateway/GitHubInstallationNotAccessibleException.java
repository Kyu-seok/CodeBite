package com.codebite.github.gateway;

/**
 * The install callback did not prove the GitHub account authorised the installation it named:
 * the authorization code was rejected, or the account cannot access that installation.
 */
public class GitHubInstallationNotAccessibleException extends GitHubGatewayException {

    public GitHubInstallationNotAccessibleException(String message) {
        super(message);
    }
}
