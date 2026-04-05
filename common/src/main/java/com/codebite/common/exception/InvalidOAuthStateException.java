package com.codebite.common.exception;

public class InvalidOAuthStateException extends RuntimeException {

    private final String messageCode;

    public InvalidOAuthStateException(String messageCode) {
        super(messageCode);
        this.messageCode = messageCode;
    }

    public String getMessageCode() {
        return messageCode;
    }
}
