package com.codebite.github.gateway;

/** GitHub was unreachable, erroring (5xx) or rate limiting; the same call may succeed later. */
public class GitHubTransientException extends GitHubGatewayException {

    public GitHubTransientException(String message) {
        super(message);
    }

    public GitHubTransientException(String message, Throwable cause) {
        super(message, cause);
    }
}
