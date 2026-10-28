package com.codebite.submission.entity;

import com.codebite.common.base.BaseEntity;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.review.entity.Confidence;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * One attempt at a problem. A submission starts PENDING and moves exactly once to a terminal
 * status, through {@link #grade}, {@link #fail} or {@link #abandon}; each returns the
 * {@link SubmissionResultEvent} the caller publishes once the row is committed. Every field the
 * event carries comes from the row, so a stale message can never disagree with it.
 */
@Entity
@Table(name = "submissions")
public class Submission extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "problem_id", nullable = false)
    private Problem problem;

    @Column(nullable = false, length = 20)
    private String language;

    @Column(name = "source_code", nullable = false, columnDefinition = "TEXT")
    private String sourceCode;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private SubmissionStatus status = SubmissionStatus.PENDING;

    @Column(name = "runtime_ms")
    private Integer runtimeMs;

    @Column(name = "memory_kb")
    private Integer memoryKb;

    @Column(length = 500)
    private String notes;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Confidence confidence;

    @Column(name = "reviewed_at")
    private Instant reviewedAt;

    @Column(name = "solve_time_seconds")
    private Integer solveTimeSeconds;

    @Column(name = "admin_submission", nullable = false)
    private boolean adminSubmission = false;

    @OneToMany(mappedBy = "submission", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SubmissionResult> results = new ArrayList<>();

    /** A new submission awaiting grading. An admin's submission is flagged from the user's role. */
    public static Submission pending(User user, Problem problem, String language, String sourceCode) {
        Submission submission = new Submission();
        submission.user = user;
        submission.problem = problem;
        submission.language = language;
        submission.sourceCode = sourceCode;
        submission.status = SubmissionStatus.PENDING;
        submission.adminSubmission = user.getRole() == Role.ADMIN;
        return submission;
    }

    public boolean isPending() {
        return status == SubmissionStatus.PENDING;
    }

    /**
     * Records the {@link Verdict} of grading this submission against {@code testCases}, one case
     * per verdict entry in order: the overall status, the largest runtime and memory any case
     * used, and one {@link SubmissionResult} per case (persisted by cascade on save).
     *
     * @throws IllegalStateException unless PENDING; callers that expect redelivery check
     *         {@link #isPending()} before paying for a Judge0 run
     * @throws IllegalArgumentException when the verdict does not have one case per test case
     */
    public SubmissionResultEvent grade(Verdict verdict, List<TestCase> testCases) {
        requirePending("grade");
        if (verdict.cases().size() != testCases.size()) {
            throw new IllegalArgumentException("Verdict has " + verdict.cases().size()
                    + " cases for " + testCases.size() + " test cases");
        }
        for (int i = 0; i < testCases.size(); i++) {
            results.add(toResult(testCases.get(i), verdict.cases().get(i)));
        }
        return complete(verdict.overall(), verdict.maxRuntimeMs(), verdict.maxMemoryKb());
    }

    /**
     * INTERNAL_ERROR after the worker exhausted its retries; no runtime, memory or results.
     *
     * @throws IllegalStateException unless PENDING
     */
    public SubmissionResultEvent fail() {
        requirePending("fail");
        return complete(SubmissionStatus.INTERNAL_ERROR, null, null);
    }

    /**
     * INTERNAL_ERROR without ever being judged: Abandoned by the re-drive sweep after staying
     * PENDING past its window. Lands where {@link #fail()} does but is a different verb, because
     * nothing ran and the logs and metrics say so.
     *
     * @throws IllegalStateException unless PENDING
     */
    public SubmissionResultEvent abandon() {
        requirePending("abandon");
        return complete(SubmissionStatus.INTERNAL_ERROR, null, null);
    }

    private void requirePending(String transition) {
        if (!isPending()) {
            throw new IllegalStateException(
                    "Cannot " + transition + " submission " + getId() + ": status is " + status);
        }
    }

    private SubmissionResultEvent complete(SubmissionStatus terminal, Integer runtimeMs, Integer memoryKb) {
        this.status = terminal;
        this.runtimeMs = runtimeMs;
        this.memoryKb = memoryKb;
        // getId() on an uninitialised lazy proxy returns the identifier without a query.
        return new SubmissionResultEvent(
                getId(), user.getId(), problem.getId(), terminal, runtimeMs, memoryKb,
                language, adminSubmission);
    }

    private SubmissionResult toResult(TestCase testCase, CaseVerdict verdict) {
        SubmissionResult result = new SubmissionResult();
        result.setSubmission(this);
        result.setTestCase(testCase);
        result.setStatus(verdict.status());
        result.setActualOutput(verdict.stdout());
        result.setStderr(verdict.stderr());
        result.setCompileOutput(verdict.compileOutput());
        result.setRuntimeMs(verdict.runtimeMs());
        result.setMemoryKb(verdict.memoryKb());
        return result;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Problem getProblem() {
        return problem;
    }

    public void setProblem(Problem problem) {
        this.problem = problem;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getSourceCode() {
        return sourceCode;
    }

    public void setSourceCode(String sourceCode) {
        this.sourceCode = sourceCode;
    }

    /** Set only by {@link #grade}, {@link #fail} and {@link #abandon}. */
    public SubmissionStatus getStatus() {
        return status;
    }

    public Integer getRuntimeMs() {
        return runtimeMs;
    }

    public Integer getMemoryKb() {
        return memoryKb;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Confidence getConfidence() {
        return confidence;
    }

    public void setConfidence(Confidence confidence) {
        this.confidence = confidence;
    }

    public Instant getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Instant reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public Integer getSolveTimeSeconds() {
        return solveTimeSeconds;
    }

    public void setSolveTimeSeconds(Integer solveTimeSeconds) {
        this.solveTimeSeconds = solveTimeSeconds;
    }

    public boolean isAdminSubmission() {
        return adminSubmission;
    }

    public List<SubmissionResult> getResults() {
        return results;
    }
}
