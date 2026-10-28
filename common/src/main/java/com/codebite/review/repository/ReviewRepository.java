package com.codebite.review.repository;

import com.codebite.common.time.DayCount;
import com.codebite.problem.entity.Difficulty;
import com.codebite.review.entity.Confidence;
import com.codebite.submission.entity.Submission;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

/**
 * Reviews: the user's rated submissions (confidence set). Reads only; a submission is rated and
 * saved through {@code SubmissionRepository}.
 */
public interface ReviewRepository extends Repository<Submission, Long> {

    // SM-2 replay: rated submissions for a (user, problem) in chronological rating order.
    List<Submission> findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(
            Long userId, Long problemId);

    // Reviews stats: total ratings recorded by this user.
    @Query("SELECT COUNT(s) FROM Submission s WHERE s.user.id = :userId AND s.confidence IS NOT NULL")
    long countRated(@Param("userId") Long userId);

    // Reviews stats: total solve time across rated submissions (seconds).
    @Query("SELECT COALESCE(SUM(s.solveTimeSeconds), 0) FROM Submission s " +
           "WHERE s.user.id = :userId AND s.confidence IS NOT NULL AND s.solveTimeSeconds IS NOT NULL")
    long sumSolveTimeSecondsForRated(@Param("userId") Long userId);

    // Reviews stats: distinct local-dates a user has logged at least one rating on, in no
    // particular order.
    @Query("SELECT DISTINCT CAST(s.reviewedAt AS LocalDate) FROM Submission s " +
           "WHERE s.user.id = :userId AND s.confidence IS NOT NULL")
    List<LocalDate> findDistinctReviewDates(@Param("userId") Long userId);

    // Reviews stats: daily rating counts for the heatmap; a day without any is absent.
    @Query("SELECT new com.codebite.common.time.DayCount(CAST(s.reviewedAt AS LocalDate), COUNT(s)) " +
           "FROM Submission s " +
           "WHERE s.user.id = :userId AND s.confidence IS NOT NULL AND s.reviewedAt >= :since " +
           "GROUP BY CAST(s.reviewedAt AS LocalDate) " +
           "ORDER BY CAST(s.reviewedAt AS LocalDate)")
    List<DayCount> countDailyReviews(@Param("userId") Long userId, @Param("since") Instant since);

    // Reviews stats: per-tag confidence distribution, one row per (tag, confidence) that occurs.
    @Query("SELECT new com.codebite.review.repository.TagConfidenceCount(t.slug, t.name, s.confidence, COUNT(s)) " +
           "FROM Submission s JOIN s.problem p JOIN p.tags t " +
           "WHERE s.user.id = :userId AND s.confidence IS NOT NULL " +
           "GROUP BY t.slug, t.name, s.confidence")
    List<TagConfidenceCount> countConfidenceByTag(@Param("userId") Long userId);

    // Reviews history feed: rated submissions filtered by optional tag/difficulty/confidence.
    // Each filter applies only when its parameter is non-null.
    @Query("SELECT s FROM Submission s JOIN FETCH s.problem p " +
           "WHERE s.user.id = :userId AND s.confidence IS NOT NULL " +
           "AND (:confidence IS NULL OR s.confidence = :confidence) " +
           "AND (:difficulty IS NULL OR p.difficulty = :difficulty) " +
           "AND (:tagSlug IS NULL OR EXISTS (SELECT 1 FROM p.tags t WHERE t.slug = :tagSlug)) " +
           "ORDER BY s.reviewedAt DESC")
    Page<Submission> findRatedFiltered(
            @Param("userId") Long userId,
            @Param("confidence") Confidence confidence,
            @Param("difficulty") Difficulty difficulty,
            @Param("tagSlug") String tagSlug,
            Pageable pageable);
}
