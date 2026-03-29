package com.codebite.profile.dto;

import java.time.Instant;

public record ProfileStats(
        int totalSolved,
        int totalProblems,
        int solvedEasy,
        int solvedMedium,
        int solvedHard,
        int totalEasy,
        int totalMedium,
        int totalHard,
        int currentStreak,
        int longestStreak,
        int totalActiveDays,
        Instant memberSince
) {}
