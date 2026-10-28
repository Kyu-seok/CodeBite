package com.codebite.submission;

import com.codebite.common.service.RateLimiterService;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.kafka.SubmissionEventProducer;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.service.StuckSubmissionRedriver;
import com.codebite.submission.service.SubmissionAbandoner;
import com.codebite.submission.service.SubmissionService;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.domain.Pageable;

import java.time.Instant;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class StuckSubmissionRedriverTest {

    @Mock private SubmissionRepository submissionRepository;
    @Mock private SubmissionService submissionService;
    @Mock private SubmissionAbandoner abandoner;
    @Mock private SubmissionEventProducer producer;
    @Mock private RateLimiterService rateLimiterService;

    private final SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();

    private StuckSubmissionRedriver redriver(RateLimiterService limiter) {
        return new StuckSubmissionRedriver(
                submissionRepository, submissionService, abandoner, producer, limiter,
                meterRegistry,
                120, 1800, 50, 50);
    }

    private Submission pending(long id) {
        User user = new User();
        user.setId(3L);
        user.setRole(Role.USER);
        Problem problem = new Problem();
        problem.setId(7L);
        problem.setSlug("pair-sum");

        Submission submission = Submission.pending(user, problem, "python", "print(1)");
        submission.setId(id);
        return submission;
    }

    @Test
    void republishesSubmissionsInsideTheStaleWindow() {
        Submission stuck = pending(42L);
        SubmissionEvent event = new SubmissionEvent(42L, "src", 71, 7L, false, "python");

        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of(stuck));
        when(submissionService.buildEvent(stuck)).thenReturn(event);

        redriver(rateLimiterService).sweep();

        verify(producer).send(event);
    }

    @Test
    void abandonsSubmissionsOlderThanTheMaxAgeAndCountsThem() {
        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(abandoner.abandonExpired(any())).thenReturn(2);
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of());

        Instant before = Instant.now();
        redriver(rateLimiterService).sweep();

        // The cutoff is now - maxAge (1800s); the abandoner owns the transition and its event.
        ArgumentCaptor<Instant> cutoff = ArgumentCaptor.forClass(Instant.class);
        verify(abandoner).abandonExpired(cutoff.capture());
        assertTrue(cutoff.getValue().isBefore(before.minusSeconds(1799)));
        assertEquals(2.0, meterRegistry.get("codebite.submissions.abandoned").counter().count());
        // An abandoned submission must not also be re-published — that would resurrect it.
        verify(producer, never()).send(any());
    }

    @Test
    void skipsEntirelyWhenAnotherReplicaHoldsTheLock() {
        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(true);

        redriver(rateLimiterService).sweep();

        verifyNoInteractions(submissionRepository);
        verifyNoInteractions(abandoner);
        verifyNoInteractions(producer);
    }

    @Test
    void sweepsWithoutRedisWhenNoRateLimiterIsPresent() {
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of());

        redriver(null).sweep();

        verify(submissionRepository).findStalePending(any(), any(), any(Pageable.class));
    }

    @Test
    void oneUnbuildableSubmissionDoesNotStopTheBatch() {
        Submission bad = pending(1L);
        Submission good = pending(2L);
        SubmissionEvent goodEvent = new SubmissionEvent(2L, "src", 71, 7L, false, "python");

        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of(bad, good));
        when(submissionService.buildEvent(bad)).thenThrow(new IllegalStateException("no driver"));
        when(submissionService.buildEvent(good)).thenReturn(goodEvent);

        redriver(rateLimiterService).sweep();

        verify(producer).send(goodEvent);
    }

    @Test
    void staleWindowIsBoundedOnBothSides() {
        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of());

        Instant before = Instant.now();
        redriver(rateLimiterService).sweep();

        ArgumentCaptor<Instant> from = ArgumentCaptor.forClass(Instant.class);
        ArgumentCaptor<Instant> to = ArgumentCaptor.forClass(Instant.class);
        verify(submissionRepository).findStalePending(from.capture(), to.capture(), any(Pageable.class));

        // from = now-maxAge (1800s), to = now-minAge (120s): the window must be non-empty and in the past.
        assertTrue(from.getValue().isBefore(to.getValue()));
        assertTrue(to.getValue().isBefore(before));
    }
}
