package com.codebite.run.dto;

import com.codebite.submission.entity.SubmissionStatus;

public record RunTestCaseResult(
        String input,
        String expectedOutput,
        String actualOutput,
        SubmissionStatus status,
        String stderr,
        String compileOutput
) {
}
