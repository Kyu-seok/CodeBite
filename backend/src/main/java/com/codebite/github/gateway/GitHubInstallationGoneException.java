package com.codebite.github.gateway;

/**
 * The App was uninstalled or suspended, or the repository was deleted or removed from the
 * installation. A GitHub Link that gets this is BROKEN until the user relinks.
 */
public class GitHubInstallationGoneException extends GitHubGatewayException {

    public GitHubInstallationGoneException(String message) {
        super(message);
    }
}
