package com.codebite.review.dto;

import com.codebite.review.entity.Confidence;

import java.math.BigDecimal;
import java.time.Instant;

/** {@code daysOverdue}: whole days past {@code nextDueAt}, counted as the due list counts them ({@link DueReviewItem}). */
public record ReviewStateResponse(
        Long problemId,
        int reviewCount,
        BigDecimal easeFactor,
        int intervalDays,
        Instant lastReviewedAt,
        Confidence lastConfidence,
        Instant nextDueAt,
        boolean mastered,
        long daysOverdue
) {
}
