package com.codebite.submission.event;

/**
 * Asks the worker to grade one submission.
 *
 * <p>{@code languageId} is what the worker sends to Judge0; {@code language} is the code the
 * submission was made in (see {@code Language}), carried as a plain string so that neither side
 * ever has to agree on an enum. {@code language} is null on events produced before the field
 * existed; readers fall back to resolving {@code languageId}.
 */
public record SubmissionEvent(
        Long submissionId,
        String sourceCode,
        int languageId,
        Long problemId,
        boolean adminSubmission,
        String language
) {}
