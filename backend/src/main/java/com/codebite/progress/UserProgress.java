package com.codebite.progress;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

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
 *   <li>{@link #statusByProblem} has no published filter: the caller passes the ids it shows.</li>
 * </ul>
 */
@Service
public class UserProgress {

    public enum Status { SOLVED, ATTEMPTED }

    /**
     * One problem the user has a graded submission to, and how many of them were Accepted.
     * Hibernate instantiates it from the select list, so the components are the boxed types the
     * columns come back as.
     */
    public record ProblemStatus(Long problemId, Long accepted) {
        public Status status() {
            return accepted > 0 ? Status.SOLVED : Status.ATTEMPTED;
        }
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
