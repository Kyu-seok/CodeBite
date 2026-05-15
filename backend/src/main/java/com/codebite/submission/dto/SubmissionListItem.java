package com.codebite.submission.dto;

import com.codebite.review.entity.Confidence;
import com.codebite.submission.entity.SubmissionStatus;

import java.time.Instant;

public record SubmissionListItem(
        Long id,
        SubmissionStatus status,
        String language,
        Integer runtimeMs,
        Integer memoryKb,
        Instant createdAt,
        String notes,
        Confidence confidence,
        Integer solveTimeSeconds
) {
}
