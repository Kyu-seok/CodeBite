package com.codebite.submission.event;

public record SubmissionEvent(
        Long submissionId,
        String sourceCode,
        int languageId,
        Long problemId
) {}
