package com.codebite.judge;

import java.util.Locale;
import java.util.Optional;
import java.util.Set;

/**
 * One of the codes CodeBite accepts in a submission, each bound to one active Judge0 language id
 * and the file extension its Drivers, Starter Code and Solution Commits use.
 *
 * <p>The one place a language id lives. A runtime upgrade is a new id in the hand-built Judge0
 * image (docs/adr/0004) and a change to the constant here; the id it replaces stays listed as
 * retired so events already queued in Kafka still name a known language.
 */
public enum Language {

    JAVA("java", 62, "java"),
    /** 100 is Python 3.12 from our own image; 71 (Python 3.8.1) is Judge0's stock id, retired. */
    PYTHON("python", 100, "py", 71),
    JAVASCRIPT("javascript", 63, "js"),
    CPP("cpp", 54, "cpp");

    private final String code;
    private final int judge0Id;
    private final String extension;
    private final Set<Integer> retiredJudge0Ids;

    Language(String code, int judge0Id, String extension, Integer... retiredJudge0Ids) {
        this.code = code;
        this.judge0Id = judge0Id;
        this.extension = extension;
        this.retiredJudge0Ids = Set.of(retiredJudge0Ids);
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

    /** The language sent as this Judge0 id, matching retired ids too so in-flight events resolve. */
    public static Optional<Language> fromJudge0Id(int judge0Id) {
        for (Language language : values()) {
            if (language.judge0Id == judge0Id || language.retiredJudge0Ids.contains(judge0Id)) {
                return Optional.of(language);
            }
        }
        return Optional.empty();
    }
}
