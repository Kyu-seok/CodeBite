package com.codebite.admin.dto;

import com.codebite.problem.entity.Difficulty;

public record ProblemAnalyticsDto(
        Long id,
        String title,
        String slug,
        Difficulty difficulty,
        long totalSubmissions,
        long acceptedCount,
        double acceptanceRate
) {
}
