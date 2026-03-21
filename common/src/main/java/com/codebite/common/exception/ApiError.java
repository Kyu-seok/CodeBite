package com.codebite.common.exception;

import java.time.Instant;

public record ApiError(int status, String message, Instant timestamp) {

    public ApiError(int status, String message) {
        this(status, message, Instant.now());
    }
}
