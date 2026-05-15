package com.codebite.review.dto;

import com.codebite.problem.entity.Difficulty;
import com.codebite.review.entity.Confidence;

import java.time.Instant;
import java.util.List;

public record DueReviewItem(
        Long problemId,
        String slug,
        String title,
        Integer problemNumber,
        Difficulty difficulty,
        List<String> tags,
        Confidence lastConfidence,
        Instant lastReviewedAt,
        Instant nextDueAt,
        long daysOverdue
) {
}
