package com.codebite.submission.event;

/**
 * Asks the worker to grade one submission.
 *
 * <p>Built by {@code Program.toEvent} and read back by {@code Program.fromEvent}.
 * {@code languageId} is what the worker sends to Judge0; {@code language} is the code the
 * submission was made in (see {@code Language}), carried as a plain string so that neither side
 * ever has to agree on an enum. The worker rejects an event without a known {@code language}.
 */
public record SubmissionEvent(
        Long submissionId,
        String sourceCode,
        int languageId,
        Long problemId,
        boolean adminSubmission,
        String language
) {}
