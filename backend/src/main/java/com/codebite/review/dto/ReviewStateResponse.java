package com.codebite.review.dto;

import com.codebite.review.entity.Confidence;

import java.math.BigDecimal;
import java.time.Instant;

public record ReviewStateResponse(
        Long problemId,
        int reviewCount,
        BigDecimal easeFactor,
        int intervalDays,
        Instant lastReviewedAt,
        Confidence lastConfidence,
        Instant nextDueAt,
        boolean mastered
) {
}
