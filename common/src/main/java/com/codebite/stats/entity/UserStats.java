package com.codebite.stats.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;

/**
 * Precomputed per-user aggregates, maintained by the {@code codebite-stats} consumer.
 *
 * <p>Keyed by user id rather than a generated id: there is exactly one row per user, and a natural
 * key is what makes the consumer's upsert idempotent under at-least-once redelivery.
 *
 * <p>Every field is derivable from {@code submissions}, which stays the source of truth.
 */
@Entity
@Table(name = "user_stats")
public class UserStats {

    @Id
    @Column(name = "user_id")
    private Long userId;

    /** Distinct problems with at least one ACCEPTED submission. */
    @Column(name = "solved_count", nullable = false)
    private int solvedCount;

    /** Distinct problems submitted to, solved or not. */
    @Column(name = "attempted_count", nullable = false)
    private int attemptedCount;

    @Column(name = "total_submissions", nullable = false)
    private int totalSubmissions;

    @Column(name = "accepted_submissions", nullable = false)
    private int acceptedSubmissions;

    @Column(name = "last_solved_at")
    private Instant lastSolvedAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected UserStats() {
    }

    public UserStats(Long userId) {
        this.userId = userId;
    }

    public Long getUserId() {
        return userId;
    }

    public int getSolvedCount() {
        return solvedCount;
    }

    public void setSolvedCount(int solvedCount) {
        this.solvedCount = solvedCount;
    }

    public int getAttemptedCount() {
        return attemptedCount;
    }

    public void setAttemptedCount(int attemptedCount) {
        this.attemptedCount = attemptedCount;
    }

    public int getTotalSubmissions() {
        return totalSubmissions;
    }

    public void setTotalSubmissions(int totalSubmissions) {
        this.totalSubmissions = totalSubmissions;
    }

    public int getAcceptedSubmissions() {
        return acceptedSubmissions;
    }

    public void setAcceptedSubmissions(int acceptedSubmissions) {
        this.acceptedSubmissions = acceptedSubmissions;
    }

    public Instant getLastSolvedAt() {
        return lastSolvedAt;
    }

    public void setLastSolvedAt(Instant lastSolvedAt) {
        this.lastSolvedAt = lastSolvedAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    /** Submissions accepted out of submissions made, as a percentage rounded to one decimal. */
    public double acceptanceRate() {
        return totalSubmissions == 0
                ? 0.0
                : Math.round(acceptedSubmissions * 1000.0 / totalSubmissions) / 10.0;
    }
}
