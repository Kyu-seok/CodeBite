package com.codebite.submission.repository;

import com.codebite.submission.entity.SubmissionResult;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SubmissionResultRepository extends JpaRepository<SubmissionResult, Long> {

    List<SubmissionResult> findBySubmissionIdOrderById(Long submissionId);
}
