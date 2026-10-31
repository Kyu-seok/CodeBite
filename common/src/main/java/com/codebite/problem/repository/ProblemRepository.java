package com.codebite.problem.repository;

import com.codebite.problem.entity.Curation;
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

    /** JPQL for "{@code p} is not the Tutorial Problem": the random pick never offers it (docs/adr/0007). */
    String NOT_TUTORIAL = "(p.problemNumber IS NULL OR p.problemNumber <> " + Problem.TUTORIAL_NUMBER + ")";

    Optional<Problem> findBySlug(String slug);

    /** The problem {@code slug} names: by its current Slug, or else by a Former Slug. */
    default Optional<Problem> findBySlugOrFormerSlug(String slug) {
        return findBySlug(slug).or(() -> findByFormerSlug(slug));
    }

    @Query("SELECT f.problem FROM FormerSlug f WHERE f.slug = :slug")
    Optional<Problem> findByFormerSlug(@Param("slug") String slug);

    boolean existsBySlug(String slug);

    /** Whether {@code slug} is, or ever was, a problem's Slug: a new problem may not take it. */
    @Query("SELECT COUNT(p) > 0 FROM Problem p WHERE p.slug = :slug "
           + "OR EXISTS (SELECT 1 FROM FormerSlug f WHERE f.slug = :slug)")
    boolean isSlugTaken(@Param("slug") String slug);

    Page<Problem> findByPublishedTrue(Pageable pageable);

    Page<Problem> findByPublishedTrueAndDifficulty(Difficulty difficulty, Pageable pageable);

    // Totals the user's Progress is shown against; a difficulty with no published problem is absent.
    @Query("SELECT new com.codebite.problem.repository.DifficultyCount(p.difficulty, COUNT(p)) "
           + "FROM Problem p WHERE p.published = true GROUP BY p.difficulty")
    List<DifficultyCount> countPublishedByDifficulty();

    /** {@link #countPublishedByDifficulty()} over one curation's problems, so without the Tutorial Problem. */
    default List<DifficultyCount> countPublishedByDifficultyIn(Curation curation) {
        return countPublishedByDifficultyNumbered(curation.firstNumber(), curation.lastNumber());
    }

    @Query("SELECT new com.codebite.problem.repository.DifficultyCount(p.difficulty, COUNT(p)) "
           + "FROM Problem p WHERE p.published = true AND p.problemNumber BETWEEN :firstNumber AND :lastNumber "
           + "GROUP BY p.difficulty")
    List<DifficultyCount> countPublishedByDifficultyNumbered(@Param("firstNumber") int firstNumber,
                                                             @Param("lastNumber") int lastNumber);

    // Random picks: published problems other than the Tutorial Problem.
    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND " + NOT_TUTORIAL + " ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugs(Pageable pageable);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND " + NOT_TUTORIAL
           + " AND p.difficulty = :difficulty ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugsByDifficulty(@Param("difficulty") Difficulty difficulty, Pageable pageable);

    // Random pick among published problems other than the given ones (the user's Solved ids from
    // UserProgress). `excluded` must not be empty: NOT IN () is not SQL; callers use the plain
    // random query then.
    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND " + NOT_TUTORIAL
           + " AND p.id NOT IN :excluded ORDER BY RANDOM()")
    List<String> findRandomPublishedSlugsExcluding(@Param("excluded") Collection<Long> excluded, Pageable pageable);

    @Query("SELECT p.slug FROM Problem p WHERE p.published = true AND " + NOT_TUTORIAL
           + " AND p.difficulty = :difficulty AND p.id NOT IN :excluded ORDER BY RANDOM()")
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
