package com.codebite.submission.dto;

import com.codebite.submission.entity.SubmissionStatus;

public record SubmissionResultDto(
        Long testCaseId,
        SubmissionStatus status,
        String input,
        String expectedOutput,
        String actualOutput,
        Integer runtimeMs,
        Integer memoryKb
) {
}
