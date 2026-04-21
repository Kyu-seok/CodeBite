package com.codebite.submission.dto;

import com.codebite.judge.dto.CodeError;
import com.codebite.submission.entity.SubmissionStatus;

import java.util.List;

public record SubmissionResultDto(
        Long testCaseId,
        SubmissionStatus status,
        String input,
        String expectedOutput,
        String actualOutput,
        Integer runtimeMs,
        Integer memoryKb,
        List<CodeError> errors
) {
}
