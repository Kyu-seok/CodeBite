package com.codebite.review.entity;

import com.codebite.review.schedule.ReviewSchedule;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ProblemReviewStateTest {

    private final Instant T0 = Instant.parse("2026-01-01T00:00:00Z");

    @Test
    void of_storesEveryFieldOfTheSchedule() {
        ReviewSchedule schedule = ReviewSchedule.NONE
                .rate(Confidence.GOOD, T0)
                .rate(Confidence.GOOD, T0.plus(2, ChronoUnit.DAYS))
                .rate(Confidence.GOOD, T0.plus(8, ChronoUnit.DAYS))
                .rate(Confidence.EASY, T0.plus(23, ChronoUnit.DAYS));       // 49d, mastered

        ProblemReviewState row = ProblemReviewState.of(7L, 11L, schedule);

        assertEquals(7L, row.getUserId());
        assertEquals(11L, row.getProblemId());
        assertEquals(4, row.getReviewCount());
        assertEquals(0, row.getEaseFactor().compareTo(new BigDecimal("2.60")));
        assertEquals(49, row.getIntervalDays());
        assertEquals(Confidence.EASY, row.getLastConfidence());
        assertEquals(T0.plus(23, ChronoUnit.DAYS), row.getLastReviewedAt());
        assertEquals(T0.plus(23 + 49, ChronoUnit.DAYS), row.getNextDueAt());
        assertTrue(row.isMastered());
    }

    @Test
    void of_notMasteredIsStoredToo() {
        ProblemReviewState row = ProblemReviewState.of(7L, 11L, ReviewSchedule.NONE.rate(Confidence.HARD, T0));

        assertEquals(1, row.getIntervalDays());
        assertFalse(row.isMastered());
    }

    @Test
    void of_refusesAScheduleWithoutReviews() {
        assertThrows(IllegalArgumentException.class,
                () -> ProblemReviewState.of(7L, 11L, ReviewSchedule.NONE));
    }
}
