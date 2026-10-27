package com.codebite.worker.consumer;

import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.assertEquals;

class SubmissionMetricsTest {

    // 100 is Python 3.12; 71 (Python 3.8) is still carried by events queued before the switch.
    @ParameterizedTest
    @ValueSource(ints = {71, 100})
    void tagsBothPythonIdsAsPython(int languageId) {
        SimpleMeterRegistry registry = new SimpleMeterRegistry();

        new SubmissionMetrics(registry).recordCompleted(
                new SubmissionEvent(1L, "source", languageId, 10L, false), SubmissionStatus.ACCEPTED);

        assertEquals(1.0, registry.get("codebite.submissions.completed")
                .tag("language", "python").counter().count());
    }
}
