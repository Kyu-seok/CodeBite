package com.codebite.run.dto;

import com.codebite.judge.dto.CodeError;
import com.codebite.submission.entity.SubmissionStatus;

import java.util.List;

public record RunTestCaseResult(
        String input,
        String expectedOutput,
        String actualOutput,
        SubmissionStatus status,
        String stderr,
        String compileOutput,
        List<CodeError> errors,
        boolean isCustom,
        boolean judged
) {
}
