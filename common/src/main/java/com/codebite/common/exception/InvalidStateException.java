package com.codebite.common.exception;

/**
 * The request is valid but the resource's current state does not allow it, e.g. starting an
 * Import on a BROKEN GitHub Link or one whose Import already ran. Answered with 409 Conflict and
 * the localized {@code messageCode}.
 */
public class InvalidStateException extends RuntimeException {

    private final String messageCode;
    private final Object[] messageArgs;

    public InvalidStateException(String messageCode, Object... args) {
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
