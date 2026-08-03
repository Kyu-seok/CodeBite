package com.codebite.submission.sse;

import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.assertEquals;

class SubmissionEmitterRegistryTest {

    private SubmissionEmitterRegistry registry;
    private SimpleMeterRegistry meterRegistry;

    @BeforeEach
    void setUp() {
        meterRegistry = new SimpleMeterRegistry();
        registry = new SubmissionEmitterRegistry(meterRegistry);
    }

    /** Counts sends so tests can assert delivery without a servlet container. */
    private static class CountingEmitter extends SseEmitter {
        final AtomicInteger sends = new AtomicInteger();

        @Override
        public void send(SseEmitter.SseEventBuilder builder) throws IOException {
            sends.incrementAndGet();
        }
    }

    @Test
    void deliversToEveryConnectionWatchingTheSameSubmission() {
        CountingEmitter tabOne = new CountingEmitter();
        CountingEmitter tabTwo = new CountingEmitter();
        registry.register(1L, tabOne);
        registry.register(1L, tabTwo);

        registry.completeWith(1L, Map.of("status", "ACCEPTED"));

        // The same user with the problem open twice must see the result in both tabs.
        assertEquals(1, tabOne.sends.get());
        assertEquals(1, tabTwo.sends.get());
    }

    @Test
    void doesNotDeliverToConnectionsForOtherSubmissions() {
        CountingEmitter mine = new CountingEmitter();
        CountingEmitter theirs = new CountingEmitter();
        registry.register(1L, mine);
        registry.register(2L, theirs);

        registry.completeWith(1L, Map.of("status", "ACCEPTED"));

        assertEquals(1, mine.sends.get());
        assertEquals(0, theirs.sends.get());
    }

    @Test
    void releasesConnectionsAfterDelivery() {
        registry.register(1L, new CountingEmitter());
        assertEquals(1, registry.openConnections());

        registry.completeWith(1L, Map.of("status", "ACCEPTED"));

        // A terminal result closes the stream; leaking the entry would grow the map forever.
        assertEquals(0, registry.openConnections());
    }

    @Test
    void completingAnUnwatchedSubmissionIsANoOp() {
        registry.completeWith(999L, Map.of("status", "ACCEPTED"));

        assertEquals(0, registry.openConnections());
    }

    @Test
    void aFailedSendDoesNotBlockDeliveryToOtherConnections() {
        CountingEmitter healthy = new CountingEmitter();
        SseEmitter broken = new SseEmitter() {
            @Override
            public void send(SseEmitter.SseEventBuilder builder) throws IOException {
                throw new IOException("client hung up");
            }
        };
        registry.register(1L, broken);
        registry.register(1L, healthy);

        registry.completeWith(1L, Map.of("status", "ACCEPTED"));

        assertEquals(1, healthy.sends.get());
        assertEquals(0, registry.openConnections());
    }

    @Test
    void exposesOpenConnectionsAsAGauge() {
        registry.register(1L, new CountingEmitter());
        registry.register(2L, new CountingEmitter());

        assertEquals(2.0, meterRegistry.get("codebite.sse.connections.open").gauge().value());
    }
}
