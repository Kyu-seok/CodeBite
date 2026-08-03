package com.codebite.stats.dto;

import java.time.Instant;

public record LeaderboardEntry(
        long rank,
        Long userId,
        String username,
        int solvedCount,
        int attemptedCount,
        double acceptanceRate,
        Instant lastSolvedAt) {
}
