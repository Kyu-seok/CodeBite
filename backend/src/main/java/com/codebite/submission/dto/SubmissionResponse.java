package com.codebite.submission.dto;

import com.codebite.submission.entity.SubmissionStatus;

import java.time.Instant;
import java.util.List;

public record SubmissionResponse(
        Long id,
        String problemSlug,
        String language,
        SubmissionStatus status,
        Integer runtimeMs,
        Integer memoryKb,
        List<SubmissionResultDto> results,
        Instant createdAt,
        String notes
) {
}
