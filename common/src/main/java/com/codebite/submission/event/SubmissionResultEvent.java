package com.codebite.submission.event;

import com.codebite.submission.entity.SubmissionStatus;

/**
 * Published by the worker once a submission reaches a terminal status.
 *
 * <p>Unlike {@link SubmissionEvent} this carries no source code — it is a notification that the
 * result is durable in PostgreSQL, not the result payload itself. Consumers that need the full
 * result (test-case breakdown, stderr) read the row.
 *
 * <p>This is the fan-out point: the SSE push, and any future consumer such as stats or
 * notifications, subscribe here independently without the worker knowing they exist.
 */
public record SubmissionResultEvent(
        Long submissionId,
        Long userId,
        Long problemId,
        SubmissionStatus status,
        Integer runtimeMs,
        Integer memoryKb,
        String language,
        boolean adminSubmission) {
}
