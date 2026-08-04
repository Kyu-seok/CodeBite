package com.codebite.stats.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;

/**
 * Precomputed per-problem aggregates, maintained by the {@code codebite-stats} consumer.
 *
 * <p>Replaces the full group-by over {@code submissions} that
 * {@code SubmissionRepository.findAcceptanceRates()} runs on the problem-list read path.
 *
 * <p>Not to be confused with {@code com.codebite.problem.dto.ProblemStats}, which is the
 * per-user solved-count DTO for the problem list header.
 */
@Entity
@Table(name = "problem_stats")
public class ProblemStats {

    @Id
    @Column(name = "problem_id")
    private Long problemId;

    @Column(name = "total_submissions", nullable = false)
    private int totalSubmissions;

    @Column(name = "accepted_submissions", nullable = false)
    private int acceptedSubmissions;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected ProblemStats() {
    }

    public ProblemStats(Long problemId) {
        this.problemId = problemId;
    }

    public Long getProblemId() {
        return problemId;
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

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    /** Matches the rounding ProblemService already applies, so the read path is unchanged. */
    public double acceptanceRate() {
        return totalSubmissions == 0
                ? 0.0
                : Math.round(acceptedSubmissions * 1000.0 / totalSubmissions) / 10.0;
    }
}
