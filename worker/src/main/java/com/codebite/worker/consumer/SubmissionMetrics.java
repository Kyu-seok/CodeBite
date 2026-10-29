package com.codebite.worker.consumer;

import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

/**
 * Owns the {@code codebite.submissions.completed} counter so the success path and the
 * retry-exhausted failure path tag it identically and share the admin-exclusion rule.
 */
@Component
public class SubmissionMetrics {

    private final MeterRegistry meterRegistry;

    public SubmissionMetrics(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    /** Admin submissions are excluded from stats. */
    public void recordCompleted(SubmissionEvent event, SubmissionStatus status) {
        if (event.adminSubmission()) {
            return;
        }
        Counter.builder("codebite.submissions.completed")
                .tag("status", status.name())
                .tag("language", languageTag(event))
                .register(meterRegistry).increment();
    }

    /**
     * The event's language code. Every event the backend publishes carries one; the guard keeps
     * the retry-exhausted path, which records whatever event failed, from throwing on one that
     * does not.
     */
    private static String languageTag(SubmissionEvent event) {
        return event.language() == null || event.language().isBlank() ? "unknown" : event.language();
    }
}
