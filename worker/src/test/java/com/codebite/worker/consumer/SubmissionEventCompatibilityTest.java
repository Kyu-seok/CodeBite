package com.codebite.worker.consumer;

import com.codebite.submission.event.SubmissionEvent;
import org.junit.jupiter.api.Test;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

/**
 * The backend rolls before the worker and a Kafka backlog can outlive both, so the worker must
 * read events from either side of the {@code language} field with the same deserializer the
 * application uses (a plain {@link JsonDeserializer}; see worker application.yml).
 */
class SubmissionEventCompatibilityTest {

    private static SubmissionEvent read(String json) {
        try (JsonDeserializer<SubmissionEvent> deserializer = new JsonDeserializer<>(SubmissionEvent.class)) {
            return deserializer.deserialize("submission-events", json.getBytes(StandardCharsets.UTF_8));
        }
    }

    @Test
    void anEventWithoutTheLanguageFieldReadsAsNullLanguage() {
        SubmissionEvent event = read(
                "{\"submissionId\":1,\"sourceCode\":\"s\",\"languageId\":71,\"problemId\":10,\"adminSubmission\":false}");

        assertEquals(1L, event.submissionId());
        assertEquals(71, event.languageId());
        assertNull(event.language());
    }

    @Test
    void anEventWithTheLanguageFieldCarriesIt() {
        SubmissionEvent event = read(
                "{\"submissionId\":1,\"sourceCode\":\"s\",\"languageId\":100,\"problemId\":10,"
                        + "\"adminSubmission\":false,\"language\":\"python\"}");

        assertEquals("python", event.language());
    }

    /** The same property that lets an old worker ignore the new field on a new event. */
    @Test
    void unknownFieldsAreIgnoredNotFatal() {
        SubmissionEvent event = read(
                "{\"submissionId\":1,\"sourceCode\":\"s\",\"languageId\":62,\"problemId\":10,"
                        + "\"adminSubmission\":false,\"language\":\"java\",\"somethingNewer\":true}");

        assertEquals("java", event.language());
    }
}
