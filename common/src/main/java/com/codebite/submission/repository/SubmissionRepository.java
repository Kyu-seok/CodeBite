package com.codebite.submission.repository;

import com.codebite.submission.entity.Submission;
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

    Optional<Submission> findFirstByUserIdOrderByCreatedAtDesc(Long userId);

    @Query("SELECT s.problem.id, " +
           "CASE WHEN SUM(CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED THEN 1 ELSE 0 END) > 0 THEN 'SOLVED' " +
           "ELSE 'ATTEMPTED' END " +
           "FROM Submission s WHERE s.user.id = :userId GROUP BY s.problem.id")
    List<Object[]> findProblemStatusesByUserId(@Param("userId") Long userId);

    @Query("SELECT p.difficulty, COUNT(DISTINCT p.id) FROM Submission s JOIN s.problem p " +
           "WHERE s.user.id = :userId AND s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED AND p.published = true " +
           "GROUP BY p.difficulty")
    List<Object[]> countSolvedByDifficultyAndUserId(@Param("userId") Long userId);

    @Query("SELECT p.difficulty, COUNT(DISTINCT p.id) FROM Submission s JOIN s.problem p " +
           "WHERE s.user.id = :userId AND s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED AND p.published = true " +
           "AND p.problemNumber <= :maxNumber GROUP BY p.difficulty")
    List<Object[]> countSolvedByDifficultyAndUserIdAndCuration(@Param("userId") Long userId, @Param("maxNumber") int maxNumber);

    @Query("SELECT s.problem.id, COUNT(s), " +
           "SUM(CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED THEN 1 ELSE 0 END) " +
           "FROM Submission s WHERE s.status != com.codebite.submission.entity.SubmissionStatus.PENDING " +
           "GROUP BY s.problem.id")
    List<Object[]> findAcceptanceRates();

    // Profile: daily submission counts for activity heatmap
    @Query("SELECT CAST(s.createdAt AS LocalDate), COUNT(s) " +
           "FROM Submission s WHERE s.user.id = :userId AND s.createdAt >= :since " +
           "GROUP BY CAST(s.createdAt AS LocalDate) " +
           "ORDER BY CAST(s.createdAt AS LocalDate)")
    List<Object[]> countDailyActivity(@Param("userId") Long userId, @Param("since") Instant since);

    // Profile: solved problem count per tag
    @Query("SELECT t.name, t.slug, COUNT(DISTINCT s.problem.id) " +
           "FROM Submission s JOIN s.problem p JOIN p.tags t " +
           "WHERE s.user.id = :userId AND s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED " +
           "AND p.published = true GROUP BY t.name, t.slug")
    List<Object[]> countSolvedByTag(@Param("userId") Long userId);

    // Profile: recent submissions across all problems
    @Query("SELECT s FROM Submission s JOIN FETCH s.problem " +
           "WHERE s.user.id = :userId ORDER BY s.createdAt DESC")
    Page<Submission> findRecentByUserId(@Param("userId") Long userId, Pageable pageable);

    // Admin: submissions since a given time
    @Query("SELECT COUNT(s) FROM Submission s WHERE s.createdAt >= :since")
    long countSince(@Param("since") Instant since);

    // Admin: daily submission counts (all users)
    @Query("SELECT CAST(s.createdAt AS LocalDate), COUNT(s) " +
           "FROM Submission s WHERE s.createdAt >= :since " +
           "GROUP BY CAST(s.createdAt AS LocalDate) " +
           "ORDER BY CAST(s.createdAt AS LocalDate)")
    List<Object[]> countDailySubmissions(@Param("since") Instant since);

    // Admin: recent submissions across all users
    @Query("SELECT s FROM Submission s JOIN FETCH s.problem JOIN FETCH s.user " +
           "ORDER BY s.createdAt DESC")
    List<Submission> findRecentGlobal(Pageable pageable);
}
