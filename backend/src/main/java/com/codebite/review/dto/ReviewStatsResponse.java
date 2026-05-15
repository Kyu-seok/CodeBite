package com.codebite.review.dto;

public record ReviewStatsResponse(
        long totalReviews,
        long totalSolveTimeSeconds,
        int currentStreak,
        int longestStreak
) {
}
