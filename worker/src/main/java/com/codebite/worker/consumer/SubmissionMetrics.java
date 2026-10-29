package com.codebite.worker.consumer;

import com.codebite.judge.Language;
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
     * The event's language code, read through {@link Language} so the tag only ever takes one of
     * its codes or {@code unknown}. The retry-exhausted path records whatever event failed, so a
     * missing or unknown code must tag rather than throw.
     */
    private static String languageTag(SubmissionEvent event) {
        return Language.fromCode(event.language()).map(Language::code).orElse("unknown");
    }
}
