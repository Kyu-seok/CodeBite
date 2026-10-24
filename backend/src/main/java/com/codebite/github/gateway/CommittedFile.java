package com.codebite.github.gateway;

/** The commit that added a {@link NewFile}: its sha and its page on GitHub. */
public record CommittedFile(String sha, String url) {
}
