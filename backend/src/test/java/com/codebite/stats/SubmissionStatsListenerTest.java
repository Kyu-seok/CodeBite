package com.codebite.stats;

import com.codebite.stats.consumer.SubmissionStatsListener;
import com.codebite.stats.service.StatsService;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class SubmissionStatsListenerTest {

    @Mock private StatsService statsService;
    @InjectMocks private SubmissionStatsListener listener;

    private static SubmissionResultEvent event(boolean admin) {
        return new SubmissionResultEvent(
                1L, 7L, 42L, SubmissionStatus.ACCEPTED, 10, 100, "python", admin);
    }

    @Test
    void recomputesForTheUserAndProblemOnTheEvent() {
        listener.onResult(event(false));

        verify(statsService).recompute(eq(7L), eq(42L));
    }

    @Test
    void ignoresAdminSubmissions() {
        listener.onResult(event(true));

        // Bulk validation would inflate every problem's counts and put a service account on the board.
        verify(statsService, never()).recompute(anyLong(), anyLong());
    }

    @Test
    void swallowsFailuresSoThePartitionKeepsMoving() {
        doThrow(new RuntimeException("db down")).when(statsService).recompute(anyLong(), anyLong());

        // Stats are derived data; a failure here must not stall every later event on the partition.
        assertDoesNotThrow(() -> listener.onResult(event(false)));
    }
}
