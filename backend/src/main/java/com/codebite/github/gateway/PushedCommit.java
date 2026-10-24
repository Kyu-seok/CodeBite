package com.codebite.github.gateway;

import java.util.Set;

/**
 * What one {@link BatchCommit} became in a batch push: its sha and page on GitHub, and the paths it
 * actually added. Paths already on the branch are left alone, so {@code addedPaths} can be a subset
 * of the commit's files; a commit that added nothing was not made and has a null sha and URL.
 */
public record PushedCommit(String sha, String url, Set<String> addedPaths) {

    public PushedCommit {
        addedPaths = Set.copyOf(addedPaths);
    }

    /** Whether this commit added {@code path}, rather than finding it already there. */
    public boolean added(String path) {
        return addedPaths.contains(path);
    }
}
