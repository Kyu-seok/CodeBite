package com.codebite.recommendation.dto;

public record WeakCategoryItem(
        String tagSlug,
        String tagName,
        double avgConfidence,        // 1.0 = AGAIN, 2.0 = HARD, 3.0 = GOOD, 4.0 = EASY
        long ratedSubmissionCount
) {
}
