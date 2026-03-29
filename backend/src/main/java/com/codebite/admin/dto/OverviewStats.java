package com.codebite.admin.dto;

public record OverviewStats(
        long totalUsers,
        long totalProblems,
        long totalSubmissions,
        long submissionsToday
) {
}
