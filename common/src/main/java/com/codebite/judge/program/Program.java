package com.codebite.judge.program;

import com.codebite.judge.Language;
import com.codebite.judge.dto.CodeError;
import com.codebite.judge.parser.CppErrorParser;
import com.codebite.judge.parser.JavaErrorParser;
import com.codebite.judge.parser.JavaScriptErrorParser;
import com.codebite.judge.parser.JudgeErrorParser;
import com.codebite.judge.parser.PythonErrorParser;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.event.SubmissionEvent;

import java.util.List;
import java.util.Objects;

/**
 * A Driver with the user's code substituted, as sent to Judge0, and the Judge0 language id to run
 * it with. Built by {@link ProblemAssets#assemble}, which bakes in where the user's code sits, so
 * {@link #diagnostics} is the only place that knows which combined line is which user line.
 *
 * <p>A Program read back from a {@link SubmissionEvent} was assembled by the backend, and one
 * recalled for a submission whose problem has lost its Driver has no Driver at all; neither knows
 * the user's coordinates, so their diagnostics are always empty.
 */
public final class Program {

    private static final JudgeErrorParser JAVA_PARSER = new JavaErrorParser();
    private static final JudgeErrorParser PYTHON_PARSER = new PythonErrorParser();
    private static final JudgeErrorParser JAVASCRIPT_PARSER = new JavaScriptErrorParser();
    private static final JudgeErrorParser CPP_PARSER = new CppErrorParser();
    private static final UserCodeLineMapper LINE_MAPPER = new UserCodeLineMapper();

    /** No user coordinates: the Program came from an event or has no Driver. */
    private static final int UNLOCATED = 0;

    private final String source;
    private final Language language;
    private final int judge0Id;
    private final int userCodeStartLine;
    private final int userCodeLineCount;

    private Program(String source, Language language, int judge0Id,
                    int userCodeStartLine, int userCodeLineCount) {
        this.source = source;
        this.language = language;
        this.judge0Id = judge0Id;
        this.userCodeStartLine = userCodeStartLine;
        this.userCodeLineCount = userCodeLineCount;
    }

    /** The driver with {@code userCode} at its placeholder, which starts on {@code userCodeStartLine}. */
    static Program assembled(String source, Language language, int userCodeStartLine, String userCode) {
        return new Program(source, language, language.judge0Id(), userCodeStartLine, countLines(userCode));
    }

    /** The user's code alone, for a submission whose problem no longer has this Driver. */
    static Program withoutDriver(String userCode, Language language) {
        return new Program(userCode, language, language.judge0Id(), UNLOCATED, 0);
    }

    /** The Program a submission event carries; the event's Judge0 id is kept as sent. */
    public static Program fromEvent(SubmissionEvent event) {
        Language language = Language.fromCode(event.language())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Submission " + event.submissionId() + " has unknown language " + event.language()));
        return new Program(event.sourceCode(), language, event.languageId(), UNLOCATED, 0);
    }

    /** The event that asks the worker to grade {@code submission} as this Program. */
    public SubmissionEvent toEvent(Submission submission) {
        return new SubmissionEvent(
                submission.getId(),
                source,
                judge0Id,
                submission.getProblem().getId(),
                submission.isAdminSubmission(),
                language.code());
    }

    public String source() {
        return source;
    }

    public Language language() {
        return language;
    }

    public int judge0Id() {
        return judge0Id;
    }

    /**
     * Judge0's compile output and stderr for one run of this Program, as errors on the lines of
     * the user's buffer. Errors in the driver collapse into one banner entry.
     */
    public List<CodeError> diagnostics(String compileOutput, String stderr) {
        if (userCodeStartLine == UNLOCATED) {
            return List.of();
        }
        List<CodeError> combined = parserFor(language).parse(compileOutput, stderr);
        return LINE_MAPPER.mapToUserSpace(combined, userCodeStartLine, userCodeLineCount);
    }

    private static JudgeErrorParser parserFor(Language language) {
        return switch (language) {
            case JAVA -> JAVA_PARSER;
            case PYTHON -> PYTHON_PARSER;
            case JAVASCRIPT -> JAVASCRIPT_PARSER;
            case CPP -> CPP_PARSER;
        };
    }

    private static int countLines(String source) {
        if (source == null || source.isEmpty()) return 0;
        return newlines(source, source.length()) + 1;
    }

    /** How many line breaks {@code text} has before {@code end}. */
    static int newlines(String text, int end) {
        int count = 0;
        for (int i = 0; i < end; i++) {
            if (text.charAt(i) == '\n') count++;
        }
        return count;
    }

    /** Equal when Judge0 would be sent the same thing. */
    @Override
    public boolean equals(Object o) {
        return o instanceof Program other
                && source.equals(other.source)
                && language == other.language
                && judge0Id == other.judge0Id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(source, language, judge0Id);
    }

    @Override
    public String toString() {
        return "Program[" + language.code() + ", judge0Id=" + judge0Id + ", " + source.length() + " chars]";
    }
}
