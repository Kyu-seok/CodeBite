package com.codebite.submission;

import com.codebite.common.service.RateLimiterService;
import com.codebite.judge.Language;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.kafka.SubmissionEventProducer;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.service.StuckSubmissionRedriver;
import com.codebite.submission.service.SubmissionAbandoner;
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
    @Mock private SubmissionAbandoner abandoner;
    @Mock private SubmissionEventProducer producer;
    @Mock private RateLimiterService rateLimiterService;

    /** A one-problem fixture: {@code pair-sum} has a Java driver and nothing else. */
    private static final ProblemAssets ASSETS = new ProblemAssets("classpath:problem-assets/");

    private final SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();

    private StuckSubmissionRedriver redriver(RateLimiterService limiter) {
        return new StuckSubmissionRedriver(
                submissionRepository, ASSETS, abandoner, producer, limiter,
                meterRegistry,
                120, 1800, 50, 50);
    }

    private Submission pending(long id) {
        return pending(id, "pair-sum");
    }

    private Submission pending(long id, String slug) {
        User user = new User();
        user.setId(3L);
        user.setRole(Role.USER);
        Problem problem = new Problem();
        problem.setId(7L);
        problem.setSlug(slug);

        Submission submission = Submission.pending(user, problem, "java", "class Solution {}");
        submission.setId(id);
        return submission;
    }

    @Test
    void republishesSubmissionsInsideTheStaleWindow() {
        Submission stuck = pending(42L);

        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of(stuck));

        redriver(rateLimiterService).sweep();

        verify(producer).send(new SubmissionEvent(42L,
                ASSETS.assemble("pair-sum", Language.JAVA, "class Solution {}").source(),
                Language.JAVA.judge0Id(), 7L, false, "java"));
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
        // The fixture has no driver for this problem, so assembling it throws NoDriverException.
        Submission bad = pending(1L, "driver-deleted");
        Submission good = pending(2L);

        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of(bad, good));

        redriver(rateLimiterService).sweep();

        ArgumentCaptor<SubmissionEvent> sent = ArgumentCaptor.forClass(SubmissionEvent.class);
        verify(producer).send(sent.capture());
        assertEquals(2L, sent.getValue().submissionId());
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
