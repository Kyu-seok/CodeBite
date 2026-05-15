package com.codebite.review;

import com.codebite.review.service.ReviewService;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class StreakComputationTest {

    private final LocalDate today = LocalDate.parse("2026-05-07");

    // ---- currentStreak ----

    @Test
    void currentStreak_emptyList_isZero() {
        assertEquals(0, ReviewService.computeCurrentStreak(List.of(), today));
    }

    @Test
    void currentStreak_lastReviewToday_countsAllConsecutiveDays() {
        // Most recent first.
        List<LocalDate> dates = List.of(
                today,
                today.minusDays(1),
                today.minusDays(2));
        assertEquals(3, ReviewService.computeCurrentStreak(dates, today));
    }

    @Test
    void currentStreak_lastReviewYesterday_stillActive() {
        List<LocalDate> dates = List.of(
                today.minusDays(1),
                today.minusDays(2));
        assertEquals(2, ReviewService.computeCurrentStreak(dates, today));
    }

    @Test
    void currentStreak_lastReviewTwoDaysAgo_isZero() {
        List<LocalDate> dates = List.of(
                today.minusDays(2),
                today.minusDays(3));
        assertEquals(0, ReviewService.computeCurrentStreak(dates, today));
    }

    @Test
    void currentStreak_gapBreaksTheRun() {
        List<LocalDate> dates = List.of(
                today,
                today.minusDays(1),
                today.minusDays(3));  // gap on day -2
        assertEquals(2, ReviewService.computeCurrentStreak(dates, today));
    }

    // ---- longestStreak ----

    @Test
    void longestStreak_emptyList_isZero() {
        assertEquals(0, ReviewService.computeLongestStreak(List.of()));
    }

    @Test
    void longestStreak_singleDay_isOne() {
        assertEquals(1, ReviewService.computeLongestStreak(List.of(today)));
    }

    @Test
    void longestStreak_pickedFromMiddle() {
        List<LocalDate> dates = List.of(
                LocalDate.parse("2026-01-01"),
                // gap
                LocalDate.parse("2026-02-10"),
                LocalDate.parse("2026-02-11"),
                LocalDate.parse("2026-02-12"),
                LocalDate.parse("2026-02-13"),  // 4-day run
                // gap
                LocalDate.parse("2026-03-05"),
                LocalDate.parse("2026-03-06"));  // 2-day run
        assertEquals(4, ReviewService.computeLongestStreak(dates));
    }

    @Test
    void longestStreak_handlesUnsortedInput() {
        List<LocalDate> dates = List.of(
                LocalDate.parse("2026-02-12"),
                LocalDate.parse("2026-02-10"),
                LocalDate.parse("2026-02-11"));
        assertEquals(3, ReviewService.computeLongestStreak(dates));
    }
}
