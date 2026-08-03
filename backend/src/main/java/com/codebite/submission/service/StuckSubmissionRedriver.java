package com.codebite.submission.service;

import com.codebite.common.service.RateLimiterService;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.kafka.SubmissionEventProducer;
import com.codebite.submission.repository.SubmissionRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.domain.PageRequest;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.time.Instant;
import java.util.List;

/**
 * Recovers submissions whose Kafka event never reached the worker.
 *
 * <p>The submit path writes the row PENDING and then publishes without blocking, so a broker outage
 * or a dropped in-flight record leaves the row PENDING with nothing to process it. This sweep finds
 * those rows and re-publishes them.
 *
 * <p>Re-driving is safe because the consumer is idempotent: {@code SubmissionConsumer} skips any
 * submission that is no longer PENDING, so a duplicate event for an already-graded submission is a
 * no-op. Bounding the window on both sides is what prevents an infinite retry loop — a row older
 * than {@code maxAge} is abandoned to INTERNAL_ERROR rather than re-published forever.
 */
@Component
@ConditionalOnProperty(name = "app.submission.redrive.enabled", havingValue = "true", matchIfMissing = true)
public class StuckSubmissionRedriver {

    private static final Logger log = LoggerFactory.getLogger(StuckSubmissionRedriver.class);

    /** Cluster-wide guard so only one backend replica runs a given sweep. */
    private static final String LOCK_ACTION = "redrive-sweep";
    private static final String LOCK_KEY = "global";

    private final SubmissionRepository submissionRepository;
    private final SubmissionService submissionService;
    private final SubmissionEventProducer producer;
    private final RateLimiterService rateLimiterService;
    private final Counter redrivenCounter;
    private final Counter abandonedCounter;

    private final Duration minAge;
    private final Duration maxAge;
    private final int batchSize;
    private final long lockTtlSeconds;

    public StuckSubmissionRedriver(
            SubmissionRepository submissionRepository,
            SubmissionService submissionService,
            SubmissionEventProducer producer,
            @Autowired(required = false) RateLimiterService rateLimiterService,
            MeterRegistry meterRegistry,
            @Value("${app.submission.redrive.min-age-seconds:120}") long minAgeSeconds,
            @Value("${app.submission.redrive.max-age-seconds:1800}") long maxAgeSeconds,
            @Value("${app.submission.redrive.batch-size:50}") int batchSize,
            @Value("${app.submission.redrive.lock-ttl-seconds:50}") long lockTtlSeconds) {
        this.submissionRepository = submissionRepository;
        this.submissionService = submissionService;
        this.producer = producer;
        this.rateLimiterService = rateLimiterService;
        this.minAge = Duration.ofSeconds(minAgeSeconds);
        this.maxAge = Duration.ofSeconds(maxAgeSeconds);
        this.batchSize = batchSize;
        this.lockTtlSeconds = lockTtlSeconds;
        this.redrivenCounter = Counter.builder("codebite.submissions.redriven")
                .description("Stuck PENDING submissions re-published to Kafka")
                .register(meterRegistry);
        this.abandonedCounter = Counter.builder("codebite.submissions.abandoned")
                .description("Submissions abandoned to INTERNAL_ERROR after exceeding the re-drive window")
                .register(meterRegistry);
    }

    @Scheduled(fixedDelayString = "${app.submission.redrive.interval-ms:60000}")
    public void sweep() {
        if (!acquireLock()) {
            return;
        }
        try {
            abandonExpired();
            redriveStale();
        } catch (Exception e) {
            // Never let a sweep failure kill the scheduler thread.
            log.error("Re-drive sweep failed", e);
        }
    }

    /**
     * Only one replica should sweep per interval. Reuses the existing SET NX EX cooldown: the
     * first replica to claim the key wins and the others see themselves as rate limited. The TTL
     * is shorter than the interval so a crashed holder cannot block the next sweep for long.
     *
     * <p>When Redis is absent (single-instance dev), there is no contention to arbitrate, so the
     * sweep simply proceeds.
     */
    private boolean acquireLock() {
        if (rateLimiterService == null) {
            return true;
        }
        return !rateLimiterService.isRateLimited(LOCK_ACTION, LOCK_KEY, lockTtlSeconds);
    }

    // Not @Transactional: these are called via this.sweep(), so a Spring proxy would never apply.
    // saveAll() supplies its own transaction, and findStalePending JOIN FETCHes the problem, so
    // nothing here touches an uninitialised lazy association outside a transaction.
    private void abandonExpired() {
        Instant cutoff = Instant.now().minus(maxAge);
        List<Submission> expired =
                submissionRepository.findByStatusAndCreatedAtBefore(SubmissionStatus.PENDING, cutoff);
        if (expired.isEmpty()) {
            return;
        }
        for (Submission submission : expired) {
            log.error("Submission {} still PENDING after {} — abandoning to INTERNAL_ERROR",
                    submission.getId(), maxAge);
            submission.setStatus(SubmissionStatus.INTERNAL_ERROR);
            abandonedCounter.increment();
        }
        submissionRepository.saveAll(expired);
    }

    private void redriveStale() {
        Instant now = Instant.now();
        List<Submission> stale = submissionRepository.findStalePending(
                now.minus(maxAge), now.minus(minAge), PageRequest.of(0, batchSize));
        if (stale.isEmpty()) {
            return;
        }
        log.warn("Re-driving {} submission(s) stuck in PENDING", stale.size());
        for (Submission submission : stale) {
            try {
                producer.send(submissionService.buildEvent(submission));
                redrivenCounter.increment();
            } catch (Exception e) {
                // One bad row (e.g. a problem whose driver was deleted) must not stop the batch.
                log.error("Could not re-drive submission {}", submission.getId(), e);
            }
        }
    }
}
