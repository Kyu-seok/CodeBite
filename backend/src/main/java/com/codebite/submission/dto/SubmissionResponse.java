package com.codebite.submission.dto;

import com.codebite.github.dto.SolutionCommitSummary;
import com.codebite.review.entity.Confidence;
import com.codebite.submission.entity.SubmissionStatus;

import java.time.Instant;
import java.util.List;
import java.util.Map;

public record SubmissionResponse(
        Long id,
        String problemSlug,
        String language,
        SubmissionStatus status,
        Integer runtimeMs,
        Integer memoryKb,
        String sourceCode,
        List<SubmissionResultDto> results,
        Instant createdAt,
        String notes,
        Confidence confidence,
        Integer solveTimeSeconds,
        /** Null when the submission has no Solution Commit (not Accepted, or no GitHub Link). */
        SolutionCommitSummary solutionCommit,
        /**
         * Days until the problem comes back for each confidence, if this submission were rated
         * now (the review scheduler's real result). Null while PENDING, and outside submission detail.
         */
        Map<Confidence, Integer> reviewIntervalDays
) {
}
