package com.codebite.review.repository;

import com.codebite.review.entity.ProblemReviewState;
import com.codebite.review.entity.ProblemReviewStateId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.Optional;

public interface ProblemReviewStateRepository
        extends JpaRepository<ProblemReviewState, ProblemReviewStateId> {

    Optional<ProblemReviewState> findByUserIdAndProblemId(Long userId, Long problemId);

    @Modifying
    void deleteByUserIdAndProblemId(Long userId, Long problemId);

    @Query("SELECT s FROM ProblemReviewState s " +
           "WHERE s.userId = :userId AND s.nextDueAt <= :cutoff " +
           "ORDER BY s.nextDueAt ASC")
    Page<ProblemReviewState> findDue(@Param("userId") Long userId,
                                     @Param("cutoff") Instant cutoff,
                                     Pageable pageable);

    @Query("SELECT COUNT(s) FROM ProblemReviewState s " +
           "WHERE s.userId = :userId AND s.nextDueAt <= :cutoff")
    long countDue(@Param("userId") Long userId, @Param("cutoff") Instant cutoff);
}
