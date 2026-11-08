package com.codebite.submission.dto;

import com.codebite.judge.dto.CodeError;
import com.codebite.submission.entity.SubmissionStatus;

import java.util.List;

/**
 * One graded case of a submission. {@code input} and {@code expectedOutput} are set only for a
 * sample case; a hidden case shows them through the {@link FailingCase} alone (docs/adr/0006).
 */
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
