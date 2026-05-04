package com.codebite.solution.repository;

import com.codebite.solution.entity.SolutionVote;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SolutionVoteRepository extends JpaRepository<SolutionVote, Long> {

    Optional<SolutionVote> findBySolutionIdAndUserId(Long solutionId, Long userId);

    List<SolutionVote> findBySolutionIdInAndUserId(List<Long> solutionIds, Long userId);
}
