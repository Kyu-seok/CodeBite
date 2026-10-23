package com.codebite.github.repository;

import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface SolutionCommitRepository extends JpaRepository<SolutionCommit, Long> {

    Optional<SolutionCommit> findBySubmissionIdAndGithubLinkId(Long submissionId, Long githubLinkId);

    /** The submission's newest Solution Commit: the one for its most recent GitHub Link. */
    Optional<SolutionCommit> findFirstBySubmissionIdOrderByIdDesc(Long submissionId);

    /**
     * Whether this link already has a Solution Commit in the given status for a submission of this
     * problem, i.e. whether the problem's folder has been started through this link.
     */
    @Query("""
            SELECT COUNT(sc) > 0 FROM SolutionCommit sc, Submission s
            WHERE s.id = sc.submissionId
              AND sc.githubLinkId = :linkId
              AND s.problem.id = :problemId
              AND sc.status = :status
            """)
    boolean existsForProblem(@Param("linkId") Long linkId,
                             @Param("problemId") Long problemId,
                             @Param("status") SolutionCommitStatus status);
}
