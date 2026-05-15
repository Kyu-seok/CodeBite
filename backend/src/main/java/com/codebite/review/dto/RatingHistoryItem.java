package com.codebite.review.dto;

import com.codebite.review.entity.Confidence;
import com.codebite.submission.entity.SubmissionStatus;

import java.time.Instant;

public record RatingHistoryItem(
        Long submissionId,
        Confidence confidence,
        Instant reviewedAt,
        String language,
        SubmissionStatus status
) {
}
