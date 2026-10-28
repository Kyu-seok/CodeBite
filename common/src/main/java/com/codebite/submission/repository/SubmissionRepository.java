package com.codebite.submission.repository;

import com.codebite.common.time.DayCount;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

public interface SubmissionRepository extends JpaRepository<Submission, Long> {

    List<Submission> findByUserIdAndProblemIdOrderByCreatedAtDesc(Long userId, Long problemId);

    /**
     * What an Import covers: the user's Accepted submissions (admin ones included) made before
     * {@code before} (the GitHub Link's created_at), minus any already COMMITTED through that link,
     * oldest first. Problems are fetched for the repository layout.
     */
    @Query("""
            SELECT s FROM Submission s JOIN FETCH s.problem
            WHERE s.user.id = :userId
              AND s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED
              AND s.createdAt < :before
              AND NOT EXISTS (
                  SELECT 1 FROM SolutionCommit sc
                  WHERE sc.submissionId = s.id
                    AND sc.githubLinkId = :linkId
                    AND sc.status = com.codebite.github.entity.SolutionCommitStatus.COMMITTED)
            ORDER BY s.createdAt ASC, s.id ASC
            """)
    List<Submission> findImportable(@Param("userId") Long userId,
                                    @Param("before") Instant before,
                                    @Param("linkId") Long linkId);

    Optional<Submission> findFirstByUserIdOrderByCreatedAtDesc(Long userId);

    // Profile: recent submissions across all problems
    @Query("SELECT s FROM Submission s JOIN FETCH s.problem " +
           "WHERE s.user.id = :userId ORDER BY s.createdAt DESC")
    Page<Submission> findRecentByUserId(@Param("userId") Long userId, Pageable pageable);

    // Admin: submissions since a given time (excludes admin submissions)
    @Query("SELECT COUNT(s) FROM Submission s WHERE s.createdAt >= :since AND s.adminSubmission = false")
    long countSince(@Param("since") Instant since);

    // Admin: daily submission counts (all users, excludes admin submissions); a day without any
    // is absent. The day is the database session's, not UTC: see UserProgress.activity.
    @Query("SELECT new com.codebite.common.time.DayCount(CAST(s.createdAt AS LocalDate), COUNT(s)) " +
           "FROM Submission s WHERE s.createdAt >= :since AND s.adminSubmission = false " +
           "GROUP BY CAST(s.createdAt AS LocalDate) " +
           "ORDER BY CAST(s.createdAt AS LocalDate)")
    List<DayCount> countDailySubmissions(@Param("since") Instant since);

    // Admin: recent submissions across all users (excludes admin submissions)
    @Query("SELECT s FROM Submission s JOIN FETCH s.problem JOIN FETCH s.user " +
           "WHERE s.adminSubmission = false " +
           "ORDER BY s.createdAt DESC")
    List<Submission> findRecentGlobal(Pageable pageable);

    // Admin: all submissions for a specific user (paginated)
    Page<Submission> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);

    // Re-drive sweep: submissions whose event was likely lost in flight. The window is bounded on
    // both sides — younger than `from` is still legitimately in progress, older than `to` has been
    // retried long enough and is abandoned instead.
    @Query("SELECT s FROM Submission s JOIN FETCH s.problem " +
           "WHERE s.status = com.codebite.submission.entity.SubmissionStatus.PENDING " +
           "AND s.createdAt BETWEEN :from AND :to " +
           "ORDER BY s.createdAt ASC")
    List<Submission> findStalePending(@Param("from") Instant from, @Param("to") Instant to,
                                      Pageable pageable);

    // Re-drive sweep: submissions stuck in PENDING past the point of retrying.
    List<Submission> findByStatusAndCreatedAtBefore(SubmissionStatus status, Instant before);
}
