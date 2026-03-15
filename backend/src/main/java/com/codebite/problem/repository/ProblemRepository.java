package com.codebite.problem.repository;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProblemRepository extends JpaRepository<Problem, Long> {

    Optional<Problem> findBySlug(String slug);

    boolean existsBySlug(String slug);

    Page<Problem> findByPublishedTrue(Pageable pageable);

    Page<Problem> findByPublishedTrueAndDifficulty(Difficulty difficulty, Pageable pageable);
}
