package com.codebite.common.exception;

public class RateLimitExceededException extends RuntimeException {

    private final String messageCode;

    public RateLimitExceededException(String messageCode) {
        super(messageCode);
        this.messageCode = messageCode;
    }

    public String getMessageCode() {
        return messageCode;
    }
}
