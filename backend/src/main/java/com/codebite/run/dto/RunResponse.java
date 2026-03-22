package com.codebite.run.dto;

import com.codebite.submission.entity.SubmissionStatus;

import java.util.List;

public record RunResponse(
        SubmissionStatus overallStatus,
        List<RunTestCaseResult> results
) {
}
