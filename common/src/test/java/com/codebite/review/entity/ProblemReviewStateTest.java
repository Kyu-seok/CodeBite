package com.codebite.review.entity;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ProblemReviewStateTest {

    private final Instant T0 = Instant.parse("2026-01-01T00:00:00Z");

    @Test
    void firstReview_good_setsIntervalToOneDay() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);

        s.applyReview(Confidence.GOOD, T0);

        assertEquals(1, s.getReviewCount());
        assertEquals(1, s.getIntervalDays());
        assertEquals(0, s.getEaseFactor().compareTo(new BigDecimal("2.50"))); // GOOD doesn't move ease
        assertEquals(T0, s.getLastReviewedAt());
        assertEquals(T0.plus(1, ChronoUnit.DAYS), s.getNextDueAt());
        assertEquals(Confidence.GOOD, s.getLastConfidence());
    }

    @Test
    void firstReview_easy_setsIntervalToFourDaysAndBumpsEase() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);

        s.applyReview(Confidence.EASY, T0);

        assertEquals(4, s.getIntervalDays());
        assertEquals(0, s.getEaseFactor().compareTo(new BigDecimal("2.60")));
    }

    @Test
    void secondReview_goodAfterGood_setsIntervalToSixDays() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        s.applyReview(Confidence.GOOD, T0);

        s.applyReview(Confidence.GOOD, T0.plus(1, ChronoUnit.DAYS));

        assertEquals(2, s.getReviewCount());
        assertEquals(6, s.getIntervalDays());
    }

    @Test
    void thirdReview_goodAfterTwoGoods_multipliesByEase() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        s.applyReview(Confidence.GOOD, T0);                                  // -> 1d, ease 2.50
        s.applyReview(Confidence.GOOD, T0.plus(1, ChronoUnit.DAYS));         // -> 6d, ease 2.50

        s.applyReview(Confidence.GOOD, T0.plus(7, ChronoUnit.DAYS));         // -> round(6 * 2.50) = 15

        assertEquals(15, s.getIntervalDays());
        assertEquals(0, s.getEaseFactor().compareTo(new BigDecimal("2.50")));
    }

    @Test
    void again_resetsIntervalAndDropsEase() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        s.applyReview(Confidence.GOOD, T0);
        s.applyReview(Confidence.GOOD, T0.plus(1, ChronoUnit.DAYS));         // ease 2.50, interval 6
        s.applyReview(Confidence.GOOD, T0.plus(7, ChronoUnit.DAYS));         // ease 2.50, interval 15

        s.applyReview(Confidence.AGAIN, T0.plus(22, ChronoUnit.DAYS));

        assertEquals(1, s.getIntervalDays());
        assertEquals(0, s.getEaseFactor().compareTo(new BigDecimal("2.30")));
        assertEquals(4, s.getReviewCount());
    }

    @Test
    void hard_decreasesEase() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        s.applyReview(Confidence.GOOD, T0);
        s.applyReview(Confidence.GOOD, T0.plus(1, ChronoUnit.DAYS));

        s.applyReview(Confidence.HARD, T0.plus(7, ChronoUnit.DAYS));

        // interval is computed with the OLD ease (2.50), then ease drops by 0.15
        // so: round(6 * 2.50) = 15, ease 2.50 - 0.15 = 2.35
        assertEquals(15, s.getIntervalDays());
        assertEquals(0, s.getEaseFactor().compareTo(new BigDecimal("2.35")));
    }

    @Test
    void easeIsClampedToFloor_after_repeatedAgain() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        for (int i = 0; i < 20; i++) {
            s.applyReview(Confidence.AGAIN, T0.plus(i, ChronoUnit.DAYS));
        }

        assertTrue(s.getEaseFactor().compareTo(new BigDecimal("1.30")) == 0,
                "ease should clamp to 1.30, was " + s.getEaseFactor());
    }

    @Test
    void easeIsClampedToCeiling_after_repeatedEasy() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        for (int i = 0; i < 20; i++) {
            s.applyReview(Confidence.EASY, T0.plus(i, ChronoUnit.DAYS));
        }

        assertTrue(s.getEaseFactor().compareTo(new BigDecimal("3.00")) == 0,
                "ease should clamp to 3.00, was " + s.getEaseFactor());
    }
}
