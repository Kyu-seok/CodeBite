package com.codebite.problem.repository;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProblemRepository extends JpaRepository<Problem, Long>, JpaSpecificationExecutor<Problem> {

    Optional<Problem> findBySlug(String slug);

    boolean existsBySlug(String slug);

    Page<Problem> findByPublishedTrue(Pageable pageable);

    Page<Problem> findByPublishedTrueAndDifficulty(Difficulty difficulty, Pageable pageable);

    @Query("SELECT p.difficulty, COUNT(p) FROM Problem p WHERE p.published = true GROUP BY p.difficulty")
    List<Object[]> countPublishedByDifficulty();

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugs(Pageable pageable);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugsByDifficulty(@Param("difficulty") Difficulty difficulty, Pageable pageable);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true " +
           "AND p.id NOT IN (SELECT DISTINCT s.problem.id FROM Submission s WHERE s.user.id = :userId AND s.status = 'ACCEPTED') " +
           "ORDER BY RANDOM()")
    List<String> findRandomUnsolvedSlugs(@Param("userId") Long userId, Pageable pageable);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty " +
           "AND p.id NOT IN (SELECT DISTINCT s.problem.id FROM Submission s WHERE s.user.id = :userId AND s.status = 'ACCEPTED') " +
           "ORDER BY RANDOM()")
    List<String> findRandomUnsolvedSlugsByDifficulty(@Param("difficulty") Difficulty difficulty, @Param("userId") Long userId, Pageable pageable);

    @Query("SELECT p FROM Problem p WHERE p.published = true AND LOWER(p.title) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<Problem> findByPublishedTrueAndTitleSearch(@Param("search") String search, Pageable pageable);

    @Query("SELECT p FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty AND LOWER(p.title) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<Problem> findByPublishedTrueAndDifficultyAndTitleSearch(@Param("difficulty") Difficulty difficulty, @Param("search") String search, Pageable pageable);
}
