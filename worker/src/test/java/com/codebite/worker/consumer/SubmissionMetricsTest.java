package com.codebite.worker.consumer;

import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class SubmissionMetricsTest {

    private final SimpleMeterRegistry registry = new SimpleMeterRegistry();

    private double completed(String language) {
        return registry.get("codebite.submissions.completed").tag("language", language).counter().count();
    }

    @Test
    void tagsWithTheLanguageTheEventNames() {
        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", 62, 10L, false, "java"), SubmissionStatus.ACCEPTED);

        assertEquals(1.0, completed("java"));
    }

    /** The Judge0 id is never read back into a language: Python's 71 and 100 tag as the event says. */
    @Test
    void tagsByTheLanguageCodeNotTheJudge0Id() {
        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", 71, 10L, false, "python"), SubmissionStatus.ACCEPTED);

        assertEquals(1.0, completed("python"));
    }

    @Test
    void anEventWithoutALanguageTagsUnknown() {
        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", 62, 10L, false, null), SubmissionStatus.INTERNAL_ERROR);

        assertEquals(1.0, completed("unknown"));
    }

    @Test
    void adminSubmissionsAreNotCounted() {
        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", 62, 10L, true, "java"), SubmissionStatus.ACCEPTED);

        assertNull(registry.find("codebite.submissions.completed").counter());
    }
}
