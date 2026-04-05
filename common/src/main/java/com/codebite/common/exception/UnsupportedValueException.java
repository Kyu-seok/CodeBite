package com.codebite.common.exception;

public class UnsupportedValueException extends RuntimeException {

    private final String messageCode;
    private final Object[] messageArgs;

    public UnsupportedValueException(String messageCode, Object... args) {
        super(messageCode);
        this.messageCode = messageCode;
        this.messageArgs = args;
    }

    public String getMessageCode() {
        return messageCode;
    }

    public Object[] getMessageArgs() {
        return messageArgs;
    }
}
