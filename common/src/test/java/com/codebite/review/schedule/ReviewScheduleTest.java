package com.codebite.review.schedule;

import com.codebite.review.entity.Confidence;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.codebite.review.entity.Confidence.AGAIN;
import static com.codebite.review.entity.Confidence.EASY;
import static com.codebite.review.entity.Confidence.GOOD;
import static com.codebite.review.entity.Confidence.HARD;
import static com.codebite.review.schedule.ReviewSchedule.NONE;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ReviewScheduleTest {

    private final Instant T0 = Instant.parse("2026-01-01T00:00:00Z");

    // ---- NONE ----

    @Test
    void none_isEmptyWithDefaultEaseAndNoMoments() {
        assertTrue(NONE.isEmpty());
        assertEquals(0, NONE.reviewCount());
        assertEquals(0, NONE.intervalDays());
        assertEquals(0, NONE.ease().compareTo(new BigDecimal("2.50")));
        assertNull(NONE.lastConfidence());
        assertNull(NONE.lastReviewedAt());
        assertNull(NONE.nextDueAt());
        assertFalse(NONE.mastered());
        assertEquals(NONE, ReviewSchedule.replay(List.of()));
    }

    // ---- rating (cases from the former ProblemReviewStateTest) ----

    @Test
    void firstReview_good_setsIntervalToTwoDays() {
        ReviewSchedule s = NONE.rate(GOOD, T0);

        assertFalse(s.isEmpty());
        assertEquals(1, s.reviewCount());
        assertEquals(2, s.intervalDays());
        assertEquals(0, s.ease().compareTo(new BigDecimal("2.50"))); // GOOD doesn't move ease
        assertEquals(T0, s.lastReviewedAt());
        assertEquals(T0.plus(2, ChronoUnit.DAYS), s.nextDueAt());
        assertEquals(GOOD, s.lastConfidence());
    }

    @Test
    void firstReview_hard_setsIntervalToOneDay() {
        assertEquals(1, NONE.rate(HARD, T0).intervalDays());
    }

    @Test
    void firstReview_easy_setsIntervalToFourDaysAndBumpsEase() {
        ReviewSchedule s = NONE.rate(EASY, T0);

        assertEquals(4, s.intervalDays());
        assertEquals(0, s.ease().compareTo(new BigDecimal("2.60")));
    }

    @Test
    void secondReview_goodAfterGood_setsIntervalToSixDays() {
        ReviewSchedule s = NONE.rate(GOOD, T0)
                .rate(GOOD, T0.plus(1, ChronoUnit.DAYS));

        assertEquals(2, s.reviewCount());
        assertEquals(6, s.intervalDays());
    }

    @Test
    void thirdReview_goodAfterTwoGoods_multipliesByEase() {
        ReviewSchedule s = NONE.rate(GOOD, T0)                                // -> 2d, ease 2.50
                .rate(GOOD, T0.plus(1, ChronoUnit.DAYS))                     // -> 6d, ease 2.50
                .rate(GOOD, T0.plus(7, ChronoUnit.DAYS));                    // -> round(6 * 2.50) = 15

        assertEquals(15, s.intervalDays());
        assertEquals(0, s.ease().compareTo(new BigDecimal("2.50")));
    }

    @Test
    void again_resetsIntervalAndDropsEase() {
        ReviewSchedule s = NONE.rate(GOOD, T0)
                .rate(GOOD, T0.plus(1, ChronoUnit.DAYS))                     // ease 2.50, interval 6
                .rate(GOOD, T0.plus(7, ChronoUnit.DAYS))                     // ease 2.50, interval 15
                .rate(AGAIN, T0.plus(22, ChronoUnit.DAYS));

        assertEquals(1, s.intervalDays());
        assertEquals(0, s.ease().compareTo(new BigDecimal("2.30")));
        assertEquals(4, s.reviewCount());
    }

    @Test
    void hard_decreasesEase() {
        ReviewSchedule s = NONE.rate(GOOD, T0)
                .rate(GOOD, T0.plus(1, ChronoUnit.DAYS))
                .rate(HARD, T0.plus(7, ChronoUnit.DAYS));

        // Hard scales the interval by 1.2 (not by ease): round(6 * 1.2) = 7,
        // then ease drops by 0.15 for later reviews: 2.50 - 0.15 = 2.35
        assertEquals(7, s.intervalDays());
        assertEquals(0, s.ease().compareTo(new BigDecimal("2.35")));
    }

    @Test
    void easeIsClampedToFloor_after_repeatedAgain() {
        ReviewSchedule s = NONE;
        for (int i = 0; i < 20; i++) {
            s = s.rate(AGAIN, T0.plus(i, ChronoUnit.DAYS));
        }

        assertTrue(s.ease().compareTo(new BigDecimal("1.30")) == 0,
                "ease should clamp to 1.30, was " + s.ease());
    }

    @Test
    void easeIsClampedToCeiling_after_repeatedEasy() {
        ReviewSchedule s = NONE;
        for (int i = 0; i < 20; i++) {
            s = s.rate(EASY, T0.plus(i, ChronoUnit.DAYS));
        }

        assertTrue(s.ease().compareTo(new BigDecimal("3.00")) == 0,
                "ease should clamp to 3.00, was " + s.ease());
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
        ReviewSchedule s = NONE.rate(GOOD, T0)
                .rate(GOOD, T0.plus(2, ChronoUnit.DAYS))
                .rate(AGAIN, T0.plus(8, ChronoUnit.DAYS));                   // -> 1d

        s = s.rate(HARD, T0.plus(9, ChronoUnit.DAYS));
        assertEquals(2, s.intervalDays());
        s = s.rate(HARD, T0.plus(11, ChronoUnit.DAYS));
        assertEquals(3, s.intervalDays());
        s = s.rate(HARD, T0.plus(14, ChronoUnit.DAYS));
        assertEquals(4, s.intervalDays());
    }

    @Test
    void repeatedEasy_neverOverflowsPastTheCap() {
        ReviewSchedule s = NONE;
        for (int i = 0; i < 40; i++) {
            s = s.rate(EASY, T0);
        }

        assertEquals(36500, s.intervalDays());
        assertEquals(T0.plus(36500, ChronoUnit.DAYS), s.nextDueAt());
    }

    /** Intervals [Hard, Good, Easy] from a third-or-later review at the given interval and ease. */
    private List<Integer> spreadAt(int intervalDays, String ease) {
        List<Integer> out = new ArrayList<>();
        for (Confidence c : new Confidence[] {HARD, GOOD, EASY}) {
            out.add(ReviewSchedule.at(2, new BigDecimal(ease), intervalDays).rate(c, T0).intervalDays());
        }
        return out;
    }

    // ---- replay ----

    @Test
    void replay_ordersByMoment_notByListPosition() {
        // Chronologically: GOOD (Jan 1), EASY (Jan 5), AGAIN (Jan 9) -> interval 1, ease 2.40.
        List<Review> shuffled = List.of(
                new Review(AGAIN, T0.plus(8, ChronoUnit.DAYS)),
                new Review(GOOD, T0),
                new Review(EASY, T0.plus(4, ChronoUnit.DAYS)));

        ReviewSchedule s = ReviewSchedule.replay(shuffled);

        assertEquals(AGAIN, s.lastConfidence());
        assertEquals(1, s.intervalDays());
        assertEquals(0, s.ease().compareTo(new BigDecimal("2.40")));
        assertEquals(T0.plus(8, ChronoUnit.DAYS), s.lastReviewedAt());
    }

    @Test
    void replay_keepsListOrderForReviewsAtTheSameMoment() {
        List<Review> tie = List.of(new Review(GOOD, T0), new Review(HARD, T0), new Review(EASY, T0));
        List<Review> otherTie = List.of(new Review(EASY, T0), new Review(HARD, T0), new Review(GOOD, T0));

        assertEquals(EASY, ReviewSchedule.replay(tie).lastConfidence());
        assertEquals(GOOD, ReviewSchedule.replay(otherTie).lastConfidence());
        assertEquals(NONE.rate(GOOD, T0).rate(HARD, T0).rate(EASY, T0), ReviewSchedule.replay(tie));
    }

    @Test
    void replay_thenRate_equalsReplayOfTheLongerHistory() {
        List<Review> history = List.of(
                new Review(GOOD, T0),
                new Review(GOOD, T0.plus(2, ChronoUnit.DAYS)),
                new Review(HARD, T0.plus(8, ChronoUnit.DAYS)),
                new Review(EASY, T0.plus(15, ChronoUnit.DAYS)));
        Review next = new Review(GOOD, T0.plus(40, ChronoUnit.DAYS));
        List<Review> longer = new ArrayList<>(history);
        longer.add(next);

        assertEquals(ReviewSchedule.replay(longer),
                ReviewSchedule.replay(history).rate(next.confidence(), next.at()));
    }

    // ---- preview ----

    @Test
    void preview_firstRating_followsTheColdStartLadder() {
        assertEquals(Map.of(AGAIN, 1, HARD, 1, GOOD, 2, EASY, 4), NONE.preview(T0));
    }

    @Test
    void preview_equalsWhatRatingWouldSchedule() {
        ReviewSchedule[] schedules = {
                NONE,
                NONE.rate(GOOD, T0),
                NONE.rate(GOOD, T0).rate(GOOD, T0.plus(1, ChronoUnit.DAYS)),
                NONE.rate(EASY, T0).rate(EASY, T0.plus(1, ChronoUnit.DAYS)).rate(HARD, T0.plus(5, ChronoUnit.DAYS)),
                ReviewSchedule.at(7, new BigDecimal("1.30"), 10),
                ReviewSchedule.at(40, new BigDecimal("3.00"), 36500),
        };
        Instant now = T0.plus(100, ChronoUnit.DAYS);

        for (ReviewSchedule s : schedules) {
            Map<Confidence, Integer> preview = s.preview(now);
            assertEquals(1, preview.get(AGAIN), () -> "AGAIN from " + s);
            for (Confidence c : Confidence.values()) {
                assertEquals(s.rate(c, now).intervalDays(), preview.get(c), () -> c + " from " + s);
            }
        }
    }

    @Test
    void preview_doesNotChangeTheSchedule() {
        ReviewSchedule s = NONE.rate(GOOD, T0).rate(GOOD, T0.plus(1, ChronoUnit.DAYS));
        ReviewSchedule before = ReviewSchedule.replay(List.of(
                new Review(GOOD, T0), new Review(GOOD, T0.plus(1, ChronoUnit.DAYS))));

        s.preview(T0.plus(10, ChronoUnit.DAYS));

        assertEquals(before, s);
    }

    // ---- mastered ----

    @Test
    void mastered_afterThreeReviewsLastTwoGoodOrEasyAndThirtyDays() {
        // GOOD GOOD GOOD EASY: 2 -> 6 -> 15 -> round(15 × 2.50 × 1.3) = 49 days.
        ReviewSchedule s = NONE.rate(GOOD, T0)
                .rate(GOOD, T0.plus(2, ChronoUnit.DAYS))
                .rate(GOOD, T0.plus(8, ChronoUnit.DAYS))
                .rate(EASY, T0.plus(23, ChronoUnit.DAYS));

        assertTrue(s.mastered());
    }

    @Test
    void notMastered_whileTheIntervalIsUnderThirtyDays() {
        // GOOD GOOD GOOD: 15 days with two Good ratings last.
        ReviewSchedule s = NONE.rate(GOOD, T0)
                .rate(GOOD, T0.plus(2, ChronoUnit.DAYS))
                .rate(GOOD, T0.plus(8, ChronoUnit.DAYS));

        assertEquals(15, s.intervalDays());
        assertFalse(s.mastered());
    }

    @Test
    void notMastered_whenOneOfTheLastTwoReviewsWasHardOrAgain() {
        ReviewSchedule fourGoods = NONE.rate(GOOD, T0)
                .rate(GOOD, T0.plus(2, ChronoUnit.DAYS))
                .rate(GOOD, T0.plus(8, ChronoUnit.DAYS))
                .rate(GOOD, T0.plus(23, ChronoUnit.DAYS));                   // 38 days, mastered
        ReviewSchedule hardThenGood = fourGoods
                .rate(HARD, T0.plus(61, ChronoUnit.DAYS))                    // 46 days
                .rate(GOOD, T0.plus(107, ChronoUnit.DAYS));                  // 108 days, previous was Hard

        assertTrue(fourGoods.mastered());
        assertFalse(fourGoods.rate(HARD, T0.plus(61, ChronoUnit.DAYS)).mastered());
        assertFalse(hardThenGood.mastered());
        assertTrue(hardThenGood.rate(GOOD, T0.plus(215, ChronoUnit.DAYS)).mastered());
    }

    @Test
    void notMastered_withFewerThanThreeReviews() {
        // Two Easy ratings: 10 days, and in any case one Review short.
        assertFalse(NONE.rate(EASY, T0).rate(EASY, T0.plus(4, ChronoUnit.DAYS)).mastered());
    }
}
