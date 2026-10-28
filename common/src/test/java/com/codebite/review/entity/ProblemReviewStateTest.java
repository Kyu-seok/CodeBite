package com.codebite.review.entity;

import com.codebite.review.schedule.ReviewSchedule;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ProblemReviewStateTest {

    private final Instant T0 = Instant.parse("2026-01-01T00:00:00Z");

    // ---- the row as a snapshot of a Review Schedule ----

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

    @Test
    void firstReview_good_setsIntervalToTwoDays() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);

        s.applyReview(Confidence.GOOD, T0);

        assertEquals(1, s.getReviewCount());
        assertEquals(2, s.getIntervalDays());
        assertEquals(0, s.getEaseFactor().compareTo(new BigDecimal("2.50"))); // GOOD doesn't move ease
        assertEquals(T0, s.getLastReviewedAt());
        assertEquals(T0.plus(2, ChronoUnit.DAYS), s.getNextDueAt());
        assertEquals(Confidence.GOOD, s.getLastConfidence());
    }

    @Test
    void firstReview_hard_setsIntervalToOneDay() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);

        s.applyReview(Confidence.HARD, T0);

        assertEquals(1, s.getIntervalDays());
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
        s.applyReview(Confidence.GOOD, T0);                                  // -> 2d, ease 2.50
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

        // Hard scales the interval by 1.2 (not by ease): round(6 * 1.2) = 7,
        // then ease drops by 0.15 for later reviews: 2.50 - 0.15 = 2.35
        assertEquals(7, s.getIntervalDays());
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

    // --- third rung onward: the rating spreads the interval (state set up directly) ---

    @Test
    void laterReview_atOneDay_eachRatingStillGrowsAndStaysOrdered() {
        // max(1 + 1, round(1.2)) = 2; max(2 + 1, round(2.5)) = 3; max(3 + 1, round(3.25)) = 4
        assertEquals(List.of(2, 3, 4), spreadAt(1, "2.50"));
    }

    @Test
    void laterReview_atTwoDays_eachRatingStillGrowsAndStaysOrdered() {
        // max(3, round(2.4)) = 3; max(4, round(5.0)) = 5; max(6, round(6.5)) = 7
        assertEquals(List.of(3, 5, 7), spreadAt(2, "2.50"));
    }

    @Test
    void laterReview_atEaseFloor_goodStillBeatsHard() {
        // max(11, round(12.0)) = 12; max(13, round(13.0)) = 13; max(14, round(16.9)) = 17
        assertEquals(List.of(12, 13, 17), spreadAt(10, "1.30"));
    }

    @Test
    void laterReview_intervalIsCappedAtOneHundredYears() {
        assertEquals(List.of(36500, 36500, 36500), spreadAt(36500, "3.00"));
        // Hard = 30000 × 1.2 = 36000 stays under the cap; Good and Easy hit it.
        assertEquals(List.of(36000, 36500, 36500), spreadAt(30000, "3.00"));
    }

    @Test
    void repeatedHard_afterAgain_growsByAtLeastADay() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        s.applyReview(Confidence.GOOD, T0);
        s.applyReview(Confidence.GOOD, T0.plus(2, ChronoUnit.DAYS));
        s.applyReview(Confidence.AGAIN, T0.plus(8, ChronoUnit.DAYS));        // -> 1d

        s.applyReview(Confidence.HARD, T0.plus(9, ChronoUnit.DAYS));
        assertEquals(2, s.getIntervalDays());
        s.applyReview(Confidence.HARD, T0.plus(11, ChronoUnit.DAYS));
        assertEquals(3, s.getIntervalDays());
        s.applyReview(Confidence.HARD, T0.plus(14, ChronoUnit.DAYS));
        assertEquals(4, s.getIntervalDays());
    }

    @Test
    void repeatedEasy_neverOverflowsPastTheCap() {
        ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
        for (int i = 0; i < 40; i++) {
            s.applyReview(Confidence.EASY, T0);
        }

        assertEquals(36500, s.getIntervalDays());
        assertEquals(T0.plus(36500, ChronoUnit.DAYS), s.getNextDueAt());
    }

    /** Intervals [Hard, Good, Easy] from a third-or-later review at the given interval and ease. */
    private List<Integer> spreadAt(int intervalDays, String ease) {
        List<Integer> out = new ArrayList<>();
        for (Confidence c : new Confidence[] {Confidence.HARD, Confidence.GOOD, Confidence.EASY}) {
            ProblemReviewState s = ProblemReviewState.newFor(1L, 2L);
            s.setReviewCount(2);
            s.setIntervalDays(intervalDays);
            s.setEaseFactor(new BigDecimal(ease));
            s.applyReview(c, T0);
            out.add(s.getIntervalDays());
        }
        return out;
    }
}
