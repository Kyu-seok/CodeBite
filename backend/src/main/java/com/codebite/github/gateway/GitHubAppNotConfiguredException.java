package com.codebite.github.gateway;

/** The GitHub App settings ({@code app.github.*}) are missing, so GitHub Links are unavailable. */
public class GitHubAppNotConfiguredException extends GitHubGatewayException {

    public GitHubAppNotConfiguredException() {
        super("GitHub App is not configured (app.github.*)");
    }
}
