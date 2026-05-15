package com.codebite.review.dto;

import com.codebite.problem.entity.Difficulty;
import com.codebite.review.entity.Confidence;
import com.codebite.submission.entity.SubmissionStatus;

import java.time.Instant;
import java.util.List;

public record ReviewHistoryItem(
        Long submissionId,
        String problemSlug,
        String problemTitle,
        Integer problemNumber,
        Difficulty difficulty,
        List<String> tags,
        String language,
        SubmissionStatus status,
        Confidence confidence,
        Instant reviewedAt,
        Integer solveTimeSeconds
) {
}
