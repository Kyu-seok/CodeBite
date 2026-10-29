package com.codebite.judge;

import com.codebite.common.exception.UnsupportedValueException;

import java.util.Locale;
import java.util.Optional;

/**
 * One of the codes CodeBite accepts in a submission, each bound to one active Judge0 language id
 * and the file extension its Drivers, Starter Code and Solution Commits use.
 *
 * <p>The one place a language id lives. A runtime upgrade is a new id in the hand-built Judge0
 * image (docs/adr/0004) and a change to the constant here. Nothing maps an id back to a
 * language: events carry the code, and the worker sends Judge0 whatever id its event names, so an
 * event queued before a switch still runs on the id it was built for.
 */
public enum Language {

    JAVA("java", 62, "java"),
    /** 100 is Python 3.12 from our own image; it replaced Judge0's stock 71 (Python 3.8.1). */
    PYTHON("python", 100, "py"),
    JAVASCRIPT("javascript", 63, "js"),
    CPP("cpp", 54, "cpp");

    private final String code;
    private final int judge0Id;
    private final String extension;

    Language(String code, int judge0Id, String extension) {
        this.code = code;
        this.judge0Id = judge0Id;
        this.extension = extension;
    }

    /** The code as it appears in requests, events and the {@code submissions.language} column. */
    public String code() {
        return code;
    }

    /** The Judge0 language id submissions are sent with today. */
    public int judge0Id() {
        return judge0Id;
    }

    /** File extension without the dot: {@code java}, {@code py}, {@code js}, {@code cpp}. */
    public String extension() {
        return extension;
    }

    /**
     * The language a Run or Submit request names, as {@link #fromCode} reads it; a code CodeBite
     * does not accept is the client's error (400, {@code error.language.unsupported}).
     */
    public static Language ofRequest(String code) {
        return fromCode(code).orElseThrow(() -> new UnsupportedValueException(
                "error.language.unsupported", code == null ? null : code.toLowerCase(Locale.ROOT)));
    }

    /** Case-insensitive; empty for null and for any code CodeBite does not accept (e.g. {@code c}). */
    public static Optional<Language> fromCode(String code) {
        if (code == null) {
            return Optional.empty();
        }
        String normalized = code.toLowerCase(Locale.ROOT);
        for (Language language : values()) {
            if (language.code.equals(normalized)) {
                return Optional.of(language);
            }
        }
        return Optional.empty();
    }
}
