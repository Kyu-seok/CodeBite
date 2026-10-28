package com.codebite.problem.repository;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface ProblemRepository extends JpaRepository<Problem, Long>, JpaSpecificationExecutor<Problem> {

    Optional<Problem> findBySlug(String slug);

    boolean existsBySlug(String slug);

    Page<Problem> findByPublishedTrue(Pageable pageable);

    Page<Problem> findByPublishedTrueAndDifficulty(Difficulty difficulty, Pageable pageable);

    // Totals the user's Progress is shown against; a difficulty with no published problem is absent.
    @Query("SELECT new com.codebite.problem.repository.DifficultyCount(p.difficulty, COUNT(p)) "
           + "FROM Problem p WHERE p.published = true GROUP BY p.difficulty")
    List<DifficultyCount> countPublishedByDifficulty();

    @Query("SELECT new com.codebite.problem.repository.DifficultyCount(p.difficulty, COUNT(p)) "
           + "FROM Problem p WHERE p.published = true AND p.problemNumber <= :maxNumber GROUP BY p.difficulty")
    List<DifficultyCount> countPublishedByDifficultyAndCuration(@Param("maxNumber") int maxNumber);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugs(Pageable pageable);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugsByDifficulty(@Param("difficulty") Difficulty difficulty, Pageable pageable);

    // Random pick among published problems other than the given ones (the user's Solved ids from
    // UserProgress). `excluded` must not be empty: NOT IN () is not SQL; callers use the plain
    // random query then.
    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND p.id NOT IN :excluded ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugsExcluding(@Param("excluded") Collection<Long> excluded, Pageable pageable);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty "
           + "AND p.id NOT IN :excluded ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugsByDifficultyExcluding(@Param("difficulty") Difficulty difficulty,
                                                               @Param("excluded") Collection<Long> excluded,
                                                               Pageable pageable);

    @Query("SELECT p FROM Problem p WHERE p.published = true AND LOWER(p.title) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<Problem> findByPublishedTrueAndTitleSearch(@Param("search") String search, Pageable pageable);

    @Query("SELECT p FROM Problem p WHERE p.published = true AND p.difficulty = :difficulty AND LOWER(p.title) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<Problem> findByPublishedTrueAndDifficultyAndTitleSearch(@Param("difficulty") Difficulty difficulty, @Param("search") String search, Pageable pageable);

    // Profile: published problems per tag; a tag no published problem carries is absent.
    @Query("SELECT new com.codebite.problem.repository.TagCount(t.name, t.slug, COUNT(p)) "
           + "FROM Problem p JOIN p.tags t WHERE p.published = true GROUP BY t.name, t.slug")
    List<TagCount> countPublishedByTag();
}
