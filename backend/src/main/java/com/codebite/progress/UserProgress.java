package com.codebite.progress;

import com.codebite.problem.entity.Difficulty;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Collection;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.OptionalInt;
import java.util.Set;
import java.util.TreeMap;

/**
 * A user's Progress: the problems they have Solved or Attempted. The one place that says what
 * those words mean, in queries over {@code submissions} bounded to one user.
 *
 * <p>Invariants, held by every method here:
 * <ul>
 *   <li><strong>Solved</strong>: at least one Accepted, non-admin submission to the problem. This
 *       is the Streak Day's rule (GLOSSARY) and what {@code user_stats} and the leaderboard count,
 *       so an admin's own validation runs do not make a problem Solved. Two Accepted submissions
 *       to one problem are one Solved problem.</li>
 *   <li><strong>Attempted</strong>: a graded, non-admin submission to the problem but never an
 *       Accepted one. PENDING is neither Solved nor Attempted; an admin's submissions are
 *       invisible here.</li>
 *   <li>{@link #statusByProblem} has no published filter: the caller passes the ids it shows.
 *       {@link #solvedByDifficulty} and {@link #solvedByTag} count published problems only,
 *       because they are shown against the published totals.</li>
 *   <li><strong>Activity</strong> is every submission the user made, whatever its status and
 *       whoever made it: the "did you show up" heatmap, not the Streak. Days are UTC calendar days
 *       (ADR 0001), bucketed in Java from the submission's instant, never by casting in SQL, whose
 *       day would depend on the database session's timezone.</li>
 * </ul>
 *
 * <p>The projection records are instantiated by Hibernate from the select list, so their
 * components are the boxed types the columns come back as.
 */
@Service
public class UserProgress {

    public enum Status { SOLVED, ATTEMPTED }

    /** One problem the user has a graded submission to, and how many of them were Accepted. */
    public record ProblemStatus(Long problemId, Long accepted) {
        public Status status() {
            return accepted > 0 ? Status.SOLVED : Status.ATTEMPTED;
        }
    }

    /** Solved published problems of one difficulty. */
    public record DifficultySolved(Difficulty difficulty, Long solved) {
    }

    /** Solved published problems carrying one tag. */
    public record TagProgress(String slug, String name, Long solved) {
    }

    /** How many submissions the user made on one UTC day. */
    public record ActivityDay(LocalDate day, int submissions) {
    }

    private static final String GRADED_NON_ADMIN =
            "s.adminSubmission = false AND s.status <> com.codebite.submission.entity.SubmissionStatus.PENDING";
    private static final String ACCEPTED_NON_ADMIN =
            "s.adminSubmission = false AND s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED";

    @PersistenceContext
    private EntityManager entityManager;

    /** Status of each of the given problems; a problem absent from the result was never graded. */
    @Transactional(readOnly = true)
    public Map<Long, Status> statusByProblem(Long userId, Collection<Long> problemIds) {
        Map<Long, Status> statuses = new HashMap<>();
        if (problemIds.isEmpty()) {
            return statuses;
        }
        var rows = entityManager.createQuery(
                        "SELECT s.problem.id, "
                                + "SUM(CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED THEN 1 ELSE 0 END) "
                                + "FROM Submission s WHERE s.user.id = :userId AND s.problem.id IN :problemIds "
                                + "AND " + GRADED_NON_ADMIN + " GROUP BY s.problem.id",
                        ProblemStatus.class)
                .setParameter("userId", userId)
                .setParameter("problemIds", problemIds)
                .getResultList();
        for (ProblemStatus row : rows) {
            statuses.put(row.problemId(), row.status());
        }
        return statuses;
    }

    /**
     * Solved published problems per difficulty, with a difficulty absent when none is Solved.
     * {@code maxProblemNumber} limits the count to a curation (CB50, CB100, ...).
     */
    @Transactional(readOnly = true)
    public Map<Difficulty, Integer> solvedByDifficulty(Long userId, OptionalInt maxProblemNumber) {
        String jpql = "SELECT p.difficulty, COUNT(DISTINCT p.id) FROM Submission s JOIN s.problem p "
                + "WHERE s.user.id = :userId AND " + ACCEPTED_NON_ADMIN + " AND p.published = true "
                + (maxProblemNumber.isPresent() ? "AND p.problemNumber <= :maxNumber " : "")
                + "GROUP BY p.difficulty";
        var query = entityManager.createQuery(jpql, DifficultySolved.class).setParameter("userId", userId);
        if (maxProblemNumber.isPresent()) {
            query.setParameter("maxNumber", maxProblemNumber.getAsInt());
        }
        Map<Difficulty, Integer> solved = new EnumMap<>(Difficulty.class);
        for (DifficultySolved row : query.getResultList()) {
            solved.put(row.difficulty(), row.solved().intValue());
        }
        return solved;
    }

    /** Solved published problems per tag, in no particular order; a tag with none Solved is absent. */
    @Transactional(readOnly = true)
    public List<TagProgress> solvedByTag(Long userId) {
        return entityManager.createQuery(
                        "SELECT t.slug, t.name, COUNT(DISTINCT p.id) "
                                + "FROM Submission s JOIN s.problem p JOIN p.tags t "
                                + "WHERE s.user.id = :userId AND " + ACCEPTED_NON_ADMIN + " AND p.published = true "
                                + "GROUP BY t.slug, t.name",
                        TagProgress.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    /** Activity per UTC day from {@code since} (inclusive) on, oldest first; days without any are absent. */
    @Transactional(readOnly = true)
    public List<ActivityDay> activity(Long userId, Instant since) {
        List<Instant> submittedAt = entityManager.createQuery(
                        "SELECT s.createdAt FROM Submission s WHERE s.user.id = :userId AND s.createdAt >= :since",
                        Instant.class)
                .setParameter("userId", userId)
                .setParameter("since", since)
                .getResultList();
        Map<LocalDate, Integer> perDay = new TreeMap<>();
        for (Instant at : submittedAt) {
            perDay.merge(at.atZone(ZoneOffset.UTC).toLocalDate(), 1, Integer::sum);
        }
        List<ActivityDay> days = new ArrayList<>(perDay.size());
        perDay.forEach((day, count) -> days.add(new ActivityDay(day, count)));
        return days;
    }

    /** Every problem the user has Solved, published or not. */
    @Transactional(readOnly = true)
    public Set<Long> solvedProblemIds(Long userId) {
        return new HashSet<>(entityManager.createQuery(
                        "SELECT DISTINCT s.problem.id FROM Submission s WHERE s.user.id = :userId "
                                + "AND " + ACCEPTED_NON_ADMIN,
                        Long.class)
                .setParameter("userId", userId)
                .getResultList());
    }
}
