package com.codebite.submission;

import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.kafka.SubmissionEventProducer;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;

import java.util.concurrent.CompletableFuture;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionEventProducerTest {

    private static final String USER_TOPIC = "submission-events";
    private static final String ADMIN_TOPIC = "submission-events-admin";

    @Mock private KafkaTemplate<String, SubmissionEvent> kafkaTemplate;

    private SimpleMeterRegistry meterRegistry;
    private SubmissionEventProducer producer;

    @BeforeEach
    void setUp() {
        meterRegistry = new SimpleMeterRegistry();
        producer = new SubmissionEventProducer(kafkaTemplate, USER_TOPIC, ADMIN_TOPIC, meterRegistry);
    }

    private void stubSend(CompletableFuture<SendResult<String, SubmissionEvent>> future) {
        when(kafkaTemplate.send(anyString(), anyString(), any(SubmissionEvent.class)))
                .thenReturn(future);
    }

    @Test
    void userSubmissionsGoToTheUserTopic() {
        stubSend(new CompletableFuture<>());

        producer.send(new SubmissionEvent(1L, "src", 62, 10L, false));

        verify(kafkaTemplate).send(eq(USER_TOPIC), anyString(), any());
    }

    @Test
    void adminSubmissionsGoToTheAdminTopic() {
        stubSend(new CompletableFuture<>());

        producer.send(new SubmissionEvent(1L, "src", 62, 10L, true));

        // Isolation is the whole point: admin batches must not share partitions with users.
        verify(kafkaTemplate).send(eq(ADMIN_TOPIC), anyString(), any());
    }

    @Test
    void partitionsBySubmissionId() {
        stubSend(new CompletableFuture<>());

        producer.send(new SubmissionEvent(4242L, "src", 62, 10L, false));

        ArgumentCaptor<String> key = ArgumentCaptor.forClass(String.class);
        verify(kafkaTemplate).send(anyString(), key.capture(), any());
        assertEquals("4242", key.getValue());
    }

    @Test
    void aFailedPublishIsCountedRatherThanThrown() {
        CompletableFuture<SendResult<String, SubmissionEvent>> failed = new CompletableFuture<>();
        failed.completeExceptionally(new RuntimeException("broker down"));
        stubSend(failed);

        // Must not propagate: the row stays PENDING and the re-drive sweep recovers it.
        producer.send(new SubmissionEvent(1L, "src", 62, 10L, false));

        assertEquals(1.0, meterRegistry.get("codebite.submissions.publish.failures").counter().count());
    }

    @Test
    void aSuccessfulPublishIsNotCountedAsAFailure() {
        stubSend(CompletableFuture.completedFuture(null));

        producer.send(new SubmissionEvent(1L, "src", 62, 10L, false));

        assertEquals(0.0, meterRegistry.get("codebite.submissions.publish.failures").counter().count());
    }
}
