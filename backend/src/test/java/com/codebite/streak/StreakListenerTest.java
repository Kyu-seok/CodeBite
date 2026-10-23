package com.codebite.streak;

import com.codebite.streak.consumer.StreakListener;
import com.codebite.streak.service.StreakService;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class StreakListenerTest {

    @Mock private StreakService streakService;
    @InjectMocks private StreakListener listener;

    private static SubmissionResultEvent event(SubmissionStatus status, boolean admin) {
        return new SubmissionResultEvent(1L, 7L, 42L, status, 10, 100, "python", admin);
    }

    @Test
    void acceptedSubmissionRecordsASolve() {
        listener.onResult(event(SubmissionStatus.ACCEPTED, false));

        verify(streakService).recordSolve(7L, 1L);
    }

    @Test
    void failedSubmissionsDoNotCount() {
        listener.onResult(event(SubmissionStatus.WRONG_ANSWER, false));

        verify(streakService, never()).recordSolve(anyLong(), anyLong());
    }

    @Test
    void adminSubmissionsDoNotCount() {
        listener.onResult(event(SubmissionStatus.ACCEPTED, true));

        verify(streakService, never()).recordSolve(anyLong(), anyLong());
    }
}
