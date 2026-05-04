package com.codebite.solution.repository;

import com.codebite.solution.entity.SolutionComment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SolutionCommentRepository extends JpaRepository<SolutionComment, Long> {

    Page<SolutionComment> findBySolutionIdAndParentCommentIsNullOrderByCreatedAtAsc(
            Long solutionId, Pageable pageable);

    List<SolutionComment> findByParentCommentIdInOrderByCreatedAtAsc(List<Long> parentIds);

    long countBySolutionId(Long solutionId);
}
