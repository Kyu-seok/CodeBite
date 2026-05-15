package com.codebite.review.entity;

import java.io.Serializable;
import java.util.Objects;

public class ProblemReviewStateId implements Serializable {

    private Long userId;
    private Long problemId;

    public ProblemReviewStateId() {
    }

    public ProblemReviewStateId(Long userId, Long problemId) {
        this.userId = userId;
        this.problemId = problemId;
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getProblemId() { return problemId; }
    public void setProblemId(Long problemId) { this.problemId = problemId; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ProblemReviewStateId other)) return false;
        return Objects.equals(userId, other.userId) && Objects.equals(problemId, other.problemId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, problemId);
    }
}
