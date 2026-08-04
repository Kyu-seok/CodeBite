package com.codebite.submission.sse;

import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Holds the open SSE connections on <em>this</em> backend instance, keyed by submission id.
 *
 * <p>A submission can have more than one emitter — the same user with the problem open in two tabs —
 * so each key maps to a list.
 *
 * <p>Nothing here is shared between replicas. That is precisely why the Kafka listener that feeds it
 * uses a per-instance consumer group: every replica must receive every result event, because only
 * the replica holding the connection can deliver it.
 */
@Component
public class SubmissionEmitterRegistry {

    private static final Logger log = LoggerFactory.getLogger(SubmissionEmitterRegistry.class);

    private final Map<Long, List<SseEmitter>> emitters = new ConcurrentHashMap<>();

    public SubmissionEmitterRegistry(MeterRegistry meterRegistry) {
        Gauge.builder("codebite.sse.connections.open", emitters,
                        map -> map.values().stream().mapToInt(List::size).sum())
                .description("SSE connections currently held by this instance")
                .register(meterRegistry);
    }

    public void register(Long submissionId, SseEmitter emitter) {
        emitters.computeIfAbsent(submissionId, id -> new CopyOnWriteArrayList<>()).add(emitter);

        emitter.onCompletion(() -> remove(submissionId, emitter));
        emitter.onTimeout(() -> {
            emitter.complete();
            remove(submissionId, emitter);
        });
        emitter.onError(e -> remove(submissionId, emitter));
    }

    /**
     * Pushes a terminal result to every connection watching this submission and closes them —
     * the submission has reached a terminal status, so there is nothing further to send.
     */
    public void completeWith(Long submissionId, Object payload) {
        List<SseEmitter> watching = emitters.remove(submissionId);
        if (watching == null || watching.isEmpty()) {
            return;
        }
        for (SseEmitter emitter : watching) {
            try {
                emitter.send(SseEmitter.event().name("result").data(payload));
                emitter.complete();
            } catch (IOException | IllegalStateException e) {
                // Client hung up between the lookup and the send; nothing to recover.
                log.debug("Dropping closed SSE connection for submission {}", submissionId);
                emitter.completeWithError(e);
            }
        }
    }

    private void remove(Long submissionId, SseEmitter emitter) {
        emitters.computeIfPresent(submissionId, (id, list) -> {
            list.remove(emitter);
            return list.isEmpty() ? null : list;
        });
    }

    /** Visible for tests. */
    int openConnections() {
        return emitters.values().stream().mapToInt(List::size).sum();
    }
}
