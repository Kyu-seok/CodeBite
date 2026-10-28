package com.codebite.review.schedule;

import com.codebite.review.entity.Confidence;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * What replaying a user's Reviews of one problem through SM-2 lite yields: review count, ease,
 * interval, next due moment and whether the problem is Mastered. Immutable; the Reviews are the
 * source of truth and the {@code problem_review_state} row is a snapshot of this value.
 *
 * <p>Invariants: Hard &lt; Good &lt; Easy below the {@value #MAX_INTERVAL_DAYS}-day cap, where all three
 * meet; {@code nextDueAt() == lastReviewedAt() + intervalDays()}; ease stays in [1.30, 3.00] at
 * scale 2; {@code lastConfidence()}, {@code lastReviewedAt()} and {@code nextDueAt()} are null only
 * on {@link #NONE}.
 */
public final class ReviewSchedule {

    private static final BigDecimal EASE_FLOOR = new BigDecimal("1.30");
    private static final BigDecimal EASE_CEIL = new BigDecimal("3.00");
    private static final BigDecimal DEFAULT_EASE = new BigDecimal("2.50");
    private static final BigDecimal HARD_MULTIPLIER = new BigDecimal("1.2");
    private static final BigDecimal EASY_BONUS = new BigDecimal("1.3");
    private static final BigDecimal AGAIN_EASE_DROP = new BigDecimal("0.20");
    private static final BigDecimal HARD_EASE_DROP = new BigDecimal("0.15");
    private static final BigDecimal EASY_EASE_RISE = new BigDecimal("0.10");
    /** About 100 years: keeps repeated Easy ratings from overflowing the int interval. */
    static final int MAX_INTERVAL_DAYS = 36500;
    private static final int MASTERED_MIN_REVIEWS = 3;
    private static final int MASTERED_MIN_INTERVAL_DAYS = 30;

    /** No Reviews yet: nothing to store. */
    public static final ReviewSchedule NONE = new ReviewSchedule(0, DEFAULT_EASE, 0, null, null, null);

    private final int reviewCount;
    private final BigDecimal ease;
    private final int intervalDays;
    private final Confidence lastConfidence;
    private final Confidence previousConfidence;
    private final Instant lastReviewedAt;

    private ReviewSchedule(int reviewCount, BigDecimal ease, int intervalDays,
                           Confidence lastConfidence, Confidence previousConfidence,
                           Instant lastReviewedAt) {
        this.reviewCount = reviewCount;
        this.ease = ease;
        this.intervalDays = intervalDays;
        this.lastConfidence = lastConfidence;
        this.previousConfidence = previousConfidence;
        this.lastReviewedAt = lastReviewedAt;
    }

    /**
     * Folds the Reviews in order of {@link Review#at()}. The sort is stable, so Reviews at the same
     * moment keep the given order; a caller's ORDER BY is only an optimisation.
     */
    public static ReviewSchedule replay(List<Review> reviews) {
        List<Review> ordered = new ArrayList<>(reviews);
        ordered.sort(Comparator.comparing(Review::at));
        ReviewSchedule schedule = NONE;
        for (Review review : ordered) {
            schedule = schedule.rate(review.confidence(), review.at());
        }
        return schedule;
    }

    /**
     * One more Review after all previous ones: {@code replay(xs).rate(c, at)} equals
     * {@code replay(xs + Review(c, at))} whenever {@code at} is not before the others.
     */
    public ReviewSchedule rate(Confidence confidence, Instant at) {
        Objects.requireNonNull(confidence, "confidence");
        Objects.requireNonNull(at, "at");
        int nextInterval;
        BigDecimal nextEase;
        if (confidence == Confidence.AGAIN) {
            nextInterval = 1;
            nextEase = clampEase(ease.subtract(AGAIN_EASE_DROP));
        } else {
            if (reviewCount == 0) {
                nextInterval = switch (confidence) {
                    case HARD -> 1;
                    case GOOD -> 2;
                    case EASY -> 4;
                    default -> 1;
                };
            } else if (reviewCount == 1) {
                nextInterval = switch (confidence) {
                    case HARD -> 3;
                    case GOOD -> 6;
                    case EASY -> 10;
                    default -> 1;
                };
            } else {
                // Anki-style spread from the third review on, using the ease held before this
                // rating (its ease change below only affects later reviews):
                //   Hard = interval × 1.2,                     at least interval + 1
                //   Good = interval × ease,                    at least Hard + 1
                //   Easy = interval × ease × 1.3 (easy bonus), at least Good + 1
                // each rounded half-up and capped at MAX_INTERVAL_DAYS, so Hard < Good < Easy
                // holds below the cap and all three meet at it.
                int hard = capped(Math.max(intervalDays + 1L, scale(intervalDays, HARD_MULTIPLIER)));
                int good = capped(Math.max(hard + 1L, scale(intervalDays, ease)));
                int easy = capped(Math.max(good + 1L, scale(intervalDays, ease.multiply(EASY_BONUS))));
                nextInterval = switch (confidence) {
                    case HARD -> hard;
                    case EASY -> easy;
                    default -> good;
                };
            }
            BigDecimal delta = switch (confidence) {
                case EASY -> EASY_EASE_RISE;
                case HARD -> HARD_EASE_DROP.negate();
                default -> BigDecimal.ZERO;
            };
            nextEase = clampEase(ease.add(delta));
        }
        return new ReviewSchedule(reviewCount + 1, nextEase, nextInterval,
                confidence, lastConfidence, at);
    }

    /**
     * The interval each Confidence would set if rated now: {@code preview(now).get(c) ==
     * rate(c, now).intervalDays()} for every c, and AGAIN is always 1.
     */
    public Map<Confidence, Integer> preview(Instant now) {
        Map<Confidence, Integer> intervals = new EnumMap<>(Confidence.class);
        for (Confidence c : Confidence.values()) {
            intervals.put(c, rate(c, now).intervalDays());
        }
        return intervals;
    }

    /** At least three Reviews, the last two Good or Easy, and an interval of 30 days or more. */
    public boolean mastered() {
        return reviewCount >= MASTERED_MIN_REVIEWS
                && intervalDays >= MASTERED_MIN_INTERVAL_DAYS
                && isGoodOrEasy(lastConfidence)
                && isGoodOrEasy(previousConfidence);
    }

    /** True only for {@link #NONE}: no Review, so no row to store. */
    public boolean isEmpty() {
        return reviewCount == 0;
    }

    public int reviewCount() { return reviewCount; }
    public BigDecimal ease() { return ease; }
    public int intervalDays() { return intervalDays; }
    public Confidence lastConfidence() { return lastConfidence; }
    public Instant lastReviewedAt() { return lastReviewedAt; }

    public Instant nextDueAt() {
        return lastReviewedAt == null ? null : lastReviewedAt.plus(intervalDays, ChronoUnit.DAYS);
    }

    /**
     * Test fixture: a schedule mid-history, for states a short history cannot reach (10 days at
     * ease 1.30). Confidences and moments are unset, so only {@link #rate} is meaningful on it.
     */
    static ReviewSchedule at(int reviewCount, BigDecimal ease, int intervalDays) {
        return new ReviewSchedule(reviewCount, ease, intervalDays, null, null, null);
    }

    private static boolean isGoodOrEasy(Confidence c) {
        return c == Confidence.GOOD || c == Confidence.EASY;
    }

    /** days × factor rounded half-up, clamped to MAX_INTERVAL_DAYS before narrowing so it can't wrap. */
    private static long scale(int days, BigDecimal factor) {
        BigDecimal scaled = BigDecimal.valueOf(days).multiply(factor).setScale(0, RoundingMode.HALF_UP);
        return scaled.min(BigDecimal.valueOf(MAX_INTERVAL_DAYS)).longValueExact();
    }

    private static int capped(long days) {
        return (int) Math.min(days, MAX_INTERVAL_DAYS);
    }

    private static BigDecimal clampEase(BigDecimal v) {
        if (v.compareTo(EASE_FLOOR) < 0) return EASE_FLOOR;
        if (v.compareTo(EASE_CEIL) > 0) return EASE_CEIL;
        return v.setScale(2, RoundingMode.HALF_UP);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ReviewSchedule other)) return false;
        return reviewCount == other.reviewCount
                && intervalDays == other.intervalDays
                && ease.compareTo(other.ease) == 0
                && lastConfidence == other.lastConfidence
                && previousConfidence == other.previousConfidence
                && Objects.equals(lastReviewedAt, other.lastReviewedAt);
    }

    @Override
    public int hashCode() {
        return Objects.hash(reviewCount, intervalDays, ease.stripTrailingZeros(),
                lastConfidence, previousConfidence, lastReviewedAt);
    }

    @Override
    public String toString() {
        return "ReviewSchedule{reviews=" + reviewCount + ", ease=" + ease.toPlainString()
                + ", intervalDays=" + intervalDays + ", last=" + lastConfidence
                + ", previous=" + previousConfidence + ", lastReviewedAt=" + lastReviewedAt + '}';
    }
}
