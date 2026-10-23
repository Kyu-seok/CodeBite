package com.codebite.github.gateway;

/**
 * A GitHub call failed in a way retrying will not fix (bad request, unexpected response).
 * Subtypes narrow the cause; the message is technical and meant for logs, not users.
 */
public class GitHubGatewayException extends RuntimeException {

    public GitHubGatewayException(String message) {
        super(message);
    }

    public GitHubGatewayException(String message, Throwable cause) {
        super(message, cause);
    }
}
