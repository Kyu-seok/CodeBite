package com.codebite.review.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import com.codebite.review.schedule.ReviewSchedule;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * The stored snapshot of one (user, problem)'s {@link ReviewSchedule}, which drives "due for
 * review". The Reviews on the submissions are the source of truth; this row is derivable and is
 * rewritten from the schedule whenever one of them changes.
 */
@Entity
@Table(name = "problem_review_state")
@IdClass(ProblemReviewStateId.class)
public class ProblemReviewState {

    @Id
    @Column(name = "user_id")
    private Long userId;

    @Id
    @Column(name = "problem_id")
    private Long problemId;

    @Column(name = "review_count", nullable = false)
    private int reviewCount;

    @Column(name = "ease_factor", nullable = false, precision = 4, scale = 2)
    private BigDecimal easeFactor;

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

    protected ProblemReviewState() {
        // JPA
    }

    /** The row that stores this Review Schedule; a schedule with no Review has no row. */
    public static ProblemReviewState of(Long userId, Long problemId, ReviewSchedule schedule) {
        if (schedule.isEmpty()) {
            throw new IllegalArgumentException("a schedule without Reviews is not stored");
        }
        ProblemReviewState s = new ProblemReviewState();
        s.userId = userId;
        s.problemId = problemId;
        s.reviewCount = schedule.reviewCount();
        s.easeFactor = schedule.ease();
        s.intervalDays = schedule.intervalDays();
        s.lastReviewedAt = schedule.lastReviewedAt();
        s.lastConfidence = schedule.lastConfidence();
        s.nextDueAt = schedule.nextDueAt();
        s.mastered = schedule.mastered();
        return s;
    }

    public Long getUserId() { return userId; }
    public Long getProblemId() { return problemId; }
    public int getReviewCount() { return reviewCount; }
    public BigDecimal getEaseFactor() { return easeFactor; }
    public int getIntervalDays() { return intervalDays; }
    public Instant getLastReviewedAt() { return lastReviewedAt; }
    public Confidence getLastConfidence() { return lastConfidence; }
    public Instant getNextDueAt() { return nextDueAt; }
    public boolean isMastered() { return mastered; }
}
