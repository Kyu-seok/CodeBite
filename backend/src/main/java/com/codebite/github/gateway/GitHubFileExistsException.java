package com.codebite.github.gateway;

/**
 * The path given to {@link GitHubGateway#addFile} already exists. Solution Repositories are
 * append-only, so the existing file is left as it is and no commit is made.
 */
public class GitHubFileExistsException extends GitHubGatewayException {

    public GitHubFileExistsException(String message) {
        super(message);
    }
}
