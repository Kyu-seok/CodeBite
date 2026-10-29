package com.codebite.common.exception;

import com.codebite.judge.Language;

/**
 * The problem has no Driver for the requested Language, so no Program can be assembled. An
 * {@link IllegalArgumentException} so the API keeps answering it with 400, as it always has.
 */
public class NoDriverException extends IllegalArgumentException {

    public NoDriverException(String slug, Language language) {
        super("No driver code available for " + slug + " in " + language.code());
    }
}
