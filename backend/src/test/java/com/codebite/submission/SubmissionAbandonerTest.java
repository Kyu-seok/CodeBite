package com.codebite.submission;

import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.service.SubmissionAbandoner;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

import java.time.Instant;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionAbandonerTest {

    private static final Instant CUTOFF = Instant.parse("2026-10-28T10:00:00Z");

    @Mock private SubmissionRepository submissionRepository;
    @Mock private ApplicationEventPublisher eventPublisher;
    @InjectMocks private SubmissionAbandoner abandoner;

    private static Submission pending(long id, long userId, long problemId) {
        User user = new User();
        user.setId(userId);
        user.setRole(Role.USER);
        Problem problem = new Problem();
        problem.setId(problemId);
        Submission submission = Submission.pending(user, problem, "python", "print(1)");
        submission.setId(id);
        return submission;
    }

    @Test
    void abandonsEveryExpiredRowSavesThemAndPublishesOneEventEach() {
        Submission first = pending(1L, 7L, 10L);
        Submission second = pending(2L, 8L, 11L);
        when(submissionRepository.findByStatusAndCreatedAtBefore(SubmissionStatus.PENDING, CUTOFF))
                .thenReturn(List.of(first, second));

        int abandoned = abandoner.abandonExpired(CUTOFF);

        assertEquals(2, abandoned);
        assertFalse(first.isPending());
        assertFalse(second.isPending());
        assertEquals(SubmissionStatus.INTERNAL_ERROR, first.getStatus());
        verify(submissionRepository).saveAll(List.of(first, second));

        // Waiting SSE clients and the stats consumer hear about an Abandoned row the same way they
        // hear about a graded one.
        ArgumentCaptor<SubmissionResultEvent> published = ArgumentCaptor.forClass(SubmissionResultEvent.class);
        verify(eventPublisher, times(2)).publishEvent(published.capture());
        assertEquals(List.of(
                new SubmissionResultEvent(1L, 7L, 10L, SubmissionStatus.INTERNAL_ERROR, null, null, "python", false),
                new SubmissionResultEvent(2L, 8L, 11L, SubmissionStatus.INTERNAL_ERROR, null, null, "python", false)),
                published.getAllValues());
    }

    @Test
    void nothingExpiredMeansNothingSavedOrPublished() {
        when(submissionRepository.findByStatusAndCreatedAtBefore(eq(SubmissionStatus.PENDING), any()))
                .thenReturn(List.of());

        assertEquals(0, abandoner.abandonExpired(CUTOFF));

        verify(submissionRepository, never()).saveAll(any());
        verify(eventPublisher, never()).publishEvent(any(Object.class));
    }
}
