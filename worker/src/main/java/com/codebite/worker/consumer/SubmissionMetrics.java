package com.codebite.worker.consumer;

import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Owns the {@code codebite.submissions.completed} counter so the success path and the
 * retry-exhausted failure path tag it identically and share the admin-exclusion rule.
 */
@Component
public class SubmissionMetrics {

    private static final Map<Integer, String> LANGUAGE_NAMES = Map.of(
            62, "java", 71, "python", 63, "javascript", 54, "cpp");

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
                .tag("language", LANGUAGE_NAMES.getOrDefault(event.languageId(), "unknown"))
                .register(meterRegistry).increment();
    }
}
