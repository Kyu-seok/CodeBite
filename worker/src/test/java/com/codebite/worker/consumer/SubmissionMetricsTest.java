package com.codebite.worker.consumer;

import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

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

    // Events published before the language field existed carry none; 100 is Python 3.12 and
    // 71 (Python 3.8) is still carried by events queued before the switch.
    @ParameterizedTest
    @ValueSource(ints = {71, 100})
    void withoutALanguageFallsBackToTheJudge0IdAndTagsBothPythonIdsAsPython(int languageId) {
        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", languageId, 10L, false, null), SubmissionStatus.ACCEPTED);

        assertEquals(1.0, completed("python"));
    }

    @Test
    void unknownJudge0IdWithoutALanguageTagsUnknown() {
        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", 999, 10L, false, null), SubmissionStatus.ACCEPTED);

        assertEquals(1.0, completed("unknown"));
    }

    @Test
    void adminSubmissionsAreNotCounted() {
        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", 62, 10L, true, "java"), SubmissionStatus.ACCEPTED);

        assertNull(registry.find("codebite.submissions.completed").counter());
    }
}
