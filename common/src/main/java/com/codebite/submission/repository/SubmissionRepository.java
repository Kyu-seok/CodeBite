package com.codebite.submission.repository;

import com.codebite.submission.entity.Submission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

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

    @Query("SELECT s.problem.id, COUNT(s), " +
           "SUM(CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED THEN 1 ELSE 0 END) " +
           "FROM Submission s WHERE s.status != com.codebite.submission.entity.SubmissionStatus.PENDING " +
           "GROUP BY s.problem.id")
    List<Object[]> findAcceptanceRates();
}
