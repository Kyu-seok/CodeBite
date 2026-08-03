package com.codebite.submission;

import com.codebite.common.service.RateLimiterService;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.kafka.SubmissionEventProducer;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.service.StuckSubmissionRedriver;
import com.codebite.submission.service.SubmissionService;
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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class StuckSubmissionRedriverTest {

    @Mock private SubmissionRepository submissionRepository;
    @Mock private SubmissionService submissionService;
    @Mock private SubmissionEventProducer producer;
    @Mock private RateLimiterService rateLimiterService;

    private StuckSubmissionRedriver redriver(RateLimiterService limiter) {
        return new StuckSubmissionRedriver(
                submissionRepository, submissionService, producer, limiter,
                new SimpleMeterRegistry(),
                120, 1800, 50, 50);
    }

    private Submission pending(long id) {
        Problem problem = new Problem();
        problem.setId(7L);
        problem.setSlug("pair-sum");

        Submission submission = new Submission();
        submission.setId(id);
        submission.setProblem(problem);
        submission.setLanguage("python");
        submission.setSourceCode("print(1)");
        submission.setStatus(SubmissionStatus.PENDING);
        return submission;
    }

    @Test
    void republishesSubmissionsInsideTheStaleWindow() {
        Submission stuck = pending(42L);
        SubmissionEvent event = new SubmissionEvent(42L, "src", 71, 7L, false);

        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findByStatusAndCreatedAtBefore(any(), any())).thenReturn(List.of());
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of(stuck));
        when(submissionService.buildEvent(stuck)).thenReturn(event);

        redriver(rateLimiterService).sweep();

        verify(producer).send(event);
    }

    @Test
    void abandonsSubmissionsOlderThanTheMaxAge() {
        Submission expired = pending(99L);

        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findByStatusAndCreatedAtBefore(eq(SubmissionStatus.PENDING), any()))
                .thenReturn(List.of(expired));
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of());

        redriver(rateLimiterService).sweep();

        assertEquals(SubmissionStatus.INTERNAL_ERROR, expired.getStatus());

        ArgumentCaptor<List<Submission>> saved = ArgumentCaptor.forClass(List.class);
        verify(submissionRepository).saveAll(saved.capture());
        assertEquals(1, saved.getValue().size());
        // An abandoned submission must not also be re-published — that would resurrect it.
        verify(producer, never()).send(any());
    }

    @Test
    void skipsEntirelyWhenAnotherReplicaHoldsTheLock() {
        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(true);

        redriver(rateLimiterService).sweep();

        verifyNoInteractions(submissionRepository);
        verifyNoInteractions(producer);
    }

    @Test
    void sweepsWithoutRedisWhenNoRateLimiterIsPresent() {
        when(submissionRepository.findByStatusAndCreatedAtBefore(any(), any())).thenReturn(List.of());
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of());

        redriver(null).sweep();

        verify(submissionRepository).findStalePending(any(), any(), any(Pageable.class));
    }

    @Test
    void oneUnbuildableSubmissionDoesNotStopTheBatch() {
        Submission bad = pending(1L);
        Submission good = pending(2L);
        SubmissionEvent goodEvent = new SubmissionEvent(2L, "src", 71, 7L, false);

        when(rateLimiterService.isRateLimited(anyString(), anyString(), anyLong())).thenReturn(false);
        when(submissionRepository.findByStatusAndCreatedAtBefore(any(), any())).thenReturn(List.of());
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
        when(submissionRepository.findByStatusAndCreatedAtBefore(any(), any())).thenReturn(List.of());
        when(submissionRepository.findStalePending(any(), any(), any(Pageable.class)))
                .thenReturn(List.of());

        Instant before = Instant.now();
        redriver(rateLimiterService).sweep();

        ArgumentCaptor<Instant> from = ArgumentCaptor.forClass(Instant.class);
        ArgumentCaptor<Instant> to = ArgumentCaptor.forClass(Instant.class);
        verify(submissionRepository).findStalePending(from.capture(), to.capture(), any(Pageable.class));

        // from = now-maxAge (1800s), to = now-minAge (120s): the window must be non-empty and in the past.
        org.junit.jupiter.api.Assertions.assertTrue(from.getValue().isBefore(to.getValue()));
        org.junit.jupiter.api.Assertions.assertTrue(to.getValue().isBefore(before));
    }
}
