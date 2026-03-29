package com.codebite.admin.dto;

import com.codebite.submission.entity.SubmissionStatus;

import java.time.Instant;

public record AdminRecentSubmission(
        Long id,
        String username,
        String problemTitle,
        String problemSlug,
        SubmissionStatus status,
        String language,
        Integer runtimeMs,
        Instant createdAt
) {
}
