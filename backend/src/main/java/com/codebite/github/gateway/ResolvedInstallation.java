package com.codebite.github.gateway;

import java.util.List;

/** An install callback resolved against GitHub: who authorised it and what it grants. */
public record ResolvedInstallation(GitHubAccount account, long installationId, List<GitHubRepo> repositories) {

    public ResolvedInstallation {
        repositories = List.copyOf(repositories);
    }
}
