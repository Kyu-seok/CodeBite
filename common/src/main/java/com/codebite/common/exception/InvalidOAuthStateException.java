package com.codebite.common.exception;

public class InvalidOAuthStateException extends RuntimeException {

    public InvalidOAuthStateException(String message) {
        super(message);
    }
}
