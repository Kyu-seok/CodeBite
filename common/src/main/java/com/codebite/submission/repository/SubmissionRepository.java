package com.codebite.submission.repository;

import com.codebite.submission.entity.Submission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SubmissionRepository extends JpaRepository<Submission, Long> {

    List<Submission> findByUserIdAndProblemIdOrderByCreatedAtDesc(Long userId, Long problemId);

    Optional<Submission> findFirstByUserIdOrderByCreatedAtDesc(Long userId);
}
