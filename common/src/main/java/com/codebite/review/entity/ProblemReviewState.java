package com.codebite.review.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

/**
 * Per-(user, problem) cached state for spaced-repetition review scheduling.
 * Algorithm: SM-2 lite. Source of truth lives in submission_reviews; this row is derivable.
 */
@Entity
@Table(name = "problem_review_state")
@IdClass(ProblemReviewStateId.class)
public class ProblemReviewState {

    private static final BigDecimal EASE_FLOOR = new BigDecimal("1.30");
    private static final BigDecimal EASE_CEIL = new BigDecimal("3.00");
    private static final BigDecimal DEFAULT_EASE = new BigDecimal("2.50");
    private static final BigDecimal HARD_MULTIPLIER = new BigDecimal("1.2");
    private static final BigDecimal EASY_BONUS = new BigDecimal("1.3");

    @Id
    @Column(name = "user_id")
    private Long userId;

    @Id
    @Column(name = "problem_id")
    private Long problemId;

    @Column(name = "review_count", nullable = false)
    private int reviewCount;

    @Column(name = "ease_factor", nullable = false, precision = 4, scale = 2)
    private BigDecimal easeFactor = DEFAULT_EASE;

    @Column(name = "interval_days", nullable = false)
    private int intervalDays;

    @Column(name = "last_reviewed_at", nullable = false)
    private Instant lastReviewedAt;

    @Enumerated(EnumType.STRING)
    @Column(name = "last_confidence", nullable = false, length = 10)
    private Confidence lastConfidence;

    @Column(name = "next_due_at", nullable = false)
    private Instant nextDueAt;

    @Column(name = "mastered", nullable = false)
    private boolean mastered;

    public static ProblemReviewState newFor(Long userId, Long problemId) {
        ProblemReviewState s = new ProblemReviewState();
        s.userId = userId;
        s.problemId = problemId;
        s.reviewCount = 0;
        s.easeFactor = DEFAULT_EASE;
        s.intervalDays = 0;
        s.mastered = false;
        return s;
    }

    /**
     * Apply a new review using SM-2 lite. Mutates this state in-place.
     * Caller persists afterward.
     */
    public void applyReview(Confidence confidence, Instant reviewedAt) {
        if (confidence == Confidence.AGAIN) {
            this.intervalDays = 1;
            this.easeFactor = clampEase(easeFactor.subtract(new BigDecimal("0.20")));
        } else {
            int next;
            if (reviewCount == 0) {
                next = switch (confidence) {
                    case HARD, GOOD -> 1;
                    case EASY -> 4;
                    default -> 1;
                };
            } else if (reviewCount == 1) {
                next = switch (confidence) {
                    case HARD -> 3;
                    case GOOD -> 6;
                    case EASY -> 10;
                    default -> 1;
                };
            } else {
                // Anki-style spread from the third review on, using the ease held before this
                // rating (its ease change below only affects later reviews):
                //   Hard = interval × 1.2
                //   Good = interval × ease,                  at least Hard + 1
                //   Easy = interval × ease × 1.3 (easy bonus), at least Good + 1
                // each rounded half-up, so Hard < Good < Easy always holds.
                int hard = Math.max(1, scale(intervalDays, HARD_MULTIPLIER));
                int good = Math.max(hard + 1, scale(intervalDays, easeFactor));
                int easy = Math.max(good + 1, scale(intervalDays, easeFactor.multiply(EASY_BONUS)));
                next = switch (confidence) {
                    case HARD -> hard;
                    case EASY -> easy;
                    default -> good;
                };
            }
            this.intervalDays = next;

            BigDecimal delta = switch (confidence) {
                case EASY -> new BigDecimal("0.10");
                case GOOD -> BigDecimal.ZERO;
                case HARD -> new BigDecimal("-0.15");
                default -> BigDecimal.ZERO;
            };
            this.easeFactor = clampEase(easeFactor.add(delta));
        }

        this.reviewCount += 1;
        this.lastConfidence = confidence;
        this.lastReviewedAt = reviewedAt;
        this.nextDueAt = reviewedAt.plus(intervalDays, ChronoUnit.DAYS);
    }

    private static int scale(int days, BigDecimal factor) {
        return BigDecimal.valueOf(days).multiply(factor).setScale(0, RoundingMode.HALF_UP).intValue();
    }

    private static BigDecimal clampEase(BigDecimal v) {
        if (v.compareTo(EASE_FLOOR) < 0) return EASE_FLOOR;
        if (v.compareTo(EASE_CEIL) > 0) return EASE_CEIL;
        return v.setScale(2, RoundingMode.HALF_UP);
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getProblemId() { return problemId; }
    public void setProblemId(Long problemId) { this.problemId = problemId; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public BigDecimal getEaseFactor() { return easeFactor; }
    public void setEaseFactor(BigDecimal easeFactor) { this.easeFactor = easeFactor; }

    public int getIntervalDays() { return intervalDays; }
    public void setIntervalDays(int intervalDays) { this.intervalDays = intervalDays; }

    public Instant getLastReviewedAt() { return lastReviewedAt; }
    public void setLastReviewedAt(Instant lastReviewedAt) { this.lastReviewedAt = lastReviewedAt; }

    public Confidence getLastConfidence() { return lastConfidence; }
    public void setLastConfidence(Confidence lastConfidence) { this.lastConfidence = lastConfidence; }

    public Instant getNextDueAt() { return nextDueAt; }
    public void setNextDueAt(Instant nextDueAt) { this.nextDueAt = nextDueAt; }

    public boolean isMastered() { return mastered; }
    public void setMastered(boolean mastered) { this.mastered = mastered; }
}
