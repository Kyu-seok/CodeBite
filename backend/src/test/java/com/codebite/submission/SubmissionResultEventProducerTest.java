package com.codebite.submission;

import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.kafka.SubmissionResultEventProducer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

import java.lang.reflect.Method;
import java.util.concurrent.CompletableFuture;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionResultEventProducerTest {

    private static final String TOPIC = "submission-results";
    private static final SubmissionResultEvent EVENT = new SubmissionResultEvent(
            42L, 7L, 10L, SubmissionStatus.INTERNAL_ERROR, null, null, "python", false);

    @Mock private KafkaTemplate<String, SubmissionResultEvent> kafkaTemplate;

    @Test
    void publishesKeyedBySubmissionId() {
        when(kafkaTemplate.send(anyString(), anyString(), any(SubmissionResultEvent.class)))
                .thenReturn(new CompletableFuture<>());

        new SubmissionResultEventProducer(kafkaTemplate, TOPIC).onSubmissionCompleted(EVENT);

        verify(kafkaTemplate).send(eq(TOPIC), eq("42"), eq(EVENT));
    }

    /** The row is already durable; a publish failure must not fail the committed transaction. */
    @Test
    void aFailedPublishIsLoggedNotThrown() {
        CompletableFuture<SendResult<String, SubmissionResultEvent>> failed = new CompletableFuture<>();
        failed.completeExceptionally(new RuntimeException("broker down"));
        when(kafkaTemplate.send(anyString(), anyString(), any(SubmissionResultEvent.class))).thenReturn(failed);

        assertDoesNotThrow(() -> new SubmissionResultEventProducer(kafkaTemplate, TOPIC).onSubmissionCompleted(EVENT));
    }

    @Test
    void aSynchronousSendFailureIsLoggedNotThrown() {
        when(kafkaTemplate.send(anyString(), anyString(), any(SubmissionResultEvent.class)))
                .thenThrow(new IllegalStateException("producer closed"));

        assertDoesNotThrow(() -> new SubmissionResultEventProducer(kafkaTemplate, TOPIC).onSubmissionCompleted(EVENT));
    }

    /** The worker's rule, copied: never announce before the row's transaction has committed. */
    @Test
    void listensAfterCommit() throws NoSuchMethodException {
        Method listener = SubmissionResultEventProducer.class
                .getMethod("onSubmissionCompleted", SubmissionResultEvent.class);

        assertEquals(TransactionPhase.AFTER_COMMIT,
                listener.getAnnotation(TransactionalEventListener.class).phase());
    }
}
