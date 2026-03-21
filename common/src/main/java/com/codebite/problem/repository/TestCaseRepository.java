package com.codebite.problem.repository;

import com.codebite.problem.entity.TestCase;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TestCaseRepository extends JpaRepository<TestCase, Long> {

    List<TestCase> findByProblemIdOrderByOrderIndexAsc(Long problemId);

    List<TestCase> findByProblemIdAndSampleTrueOrderByOrderIndexAsc(Long problemId);
}
