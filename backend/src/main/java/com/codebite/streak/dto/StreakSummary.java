package com.codebite.streak.dto;

/**
 * The owner's view of their Streak. {@code solvedToday} drives the nav flame: greyed out until
 * today is a Streak Day.
 */
public record StreakSummary(
        int currentStreak,
        int bestStreak,
        boolean solvedToday,
        int repairs,
        int repairProgress
) {
}
