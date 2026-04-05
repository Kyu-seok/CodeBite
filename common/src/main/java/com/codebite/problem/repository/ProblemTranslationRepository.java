package com.codebite.problem.repository;

import com.codebite.problem.entity.ProblemTranslation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProblemTranslationRepository extends JpaRepository<ProblemTranslation, Long> {

    Optional<ProblemTranslation> findByProblemIdAndLocale(Long problemId, String locale);

    List<ProblemTranslation> findByProblemIdInAndLocale(List<Long> problemIds, String locale);
}
