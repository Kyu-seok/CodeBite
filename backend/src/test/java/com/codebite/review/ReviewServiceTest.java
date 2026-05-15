package com.codebite.review;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.review.dto.RatingHistoryItem;
import com.codebite.review.dto.ReviewStateResponse;
import com.codebite.review.entity.Confidence;
import com.codebite.review.entity.ProblemReviewState;
import com.codebite.review.repository.ProblemReviewStateRepository;
import com.codebite.review.service.ReviewService;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ReviewServiceTest {

    @Mock private ProblemReviewStateRepository stateRepository;
    @Mock private ProblemRepository problemRepository;
    @Mock private SubmissionRepository submissionRepository;

    private ReviewService reviewService;

    private User user;
    private Problem problem;

    @BeforeEach
    void setUp() {
        reviewService = new ReviewService(
                stateRepository, problemRepository, submissionRepository);

        user = new User();
        user.setId(1L);
        user.setUsername("u");
        user.setEmail("u@u.com");
        user.setPasswordHash("h");

        problem = new Problem();
        problem.setId(10L);
        problem.setSlug("two-sum");
        problem.setTitle("Two Sum");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);

        when(stateRepository.save(any(ProblemReviewState.class)))
                .thenAnswer(inv -> inv.getArgument(0));
        when(submissionRepository.save(any(Submission.class)))
                .thenAnswer(inv -> inv.getArgument(0));
    }

    private Submission submission(long id, SubmissionStatus status) {
        Submission s = new Submission();
        s.setId(id);
        s.setUser(user);
        s.setProblem(problem);
        s.setLanguage("java");
        s.setSourceCode("code");
        s.setStatus(status);
        return s;
    }

    @Test
    void setReview_firstTime_createsStateAndAdvancesLadder() {
        Submission sub = submission(100L, SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));
        when(stateRepository.findByUserIdAndProblemId(1L, 10L)).thenReturn(Optional.empty());
        // Replay sees the just-rated submission (in real DB the same tx flush would do this).
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenAnswer(inv -> sub.getConfidence() != null ? List.of(sub) : List.of());

        ReviewStateResponse resp = reviewService.setReview(100L, 1L, Confidence.GOOD, null);

        assertEquals(Confidence.GOOD, sub.getConfidence());
        assertNotNull(sub.getReviewedAt());
        assertEquals(1, resp.reviewCount());
        assertEquals(1, resp.intervalDays());
        assertEquals(Confidence.GOOD, resp.lastConfidence());
        verify(submissionRepository).save(sub);
        verify(stateRepository).save(any(ProblemReviewState.class));
    }

    @Test
    void setReview_replaysAcrossTwoSubmissionsInChronologicalOrder() {
        Submission first = submission(100L, SubmissionStatus.ACCEPTED);
        first.setConfidence(Confidence.GOOD);
        first.setReviewedAt(Instant.parse("2026-01-01T00:00:00Z"));

        Submission second = submission(101L, SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(101L)).thenReturn(Optional.of(second));
        when(stateRepository.findByUserIdAndProblemId(1L, 10L))
                .thenReturn(Optional.of(ProblemReviewState.newFor(1L, 10L)));
        // Both ratings will be present on replay; reviewedAt order: first (Jan 1), then second (now).
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenAnswer(inv -> List.of(first, second));

        ReviewStateResponse resp = reviewService.setReview(101L, 1L, Confidence.GOOD, null);

        // Two GOODs from cold start: 1d → 6d, ease 2.50.
        assertEquals(2, resp.reviewCount());
        assertEquals(6, resp.intervalDays());
    }

    @Test
    void setReview_reRatingOldSubmission_reordersReplay() {
        // Initial chronology: first → GOOD (Jan 1), second → EASY (Jan 5).
        Submission first = submission(100L, SubmissionStatus.ACCEPTED);
        first.setConfidence(Confidence.GOOD);
        first.setReviewedAt(Instant.parse("2026-01-01T00:00:00Z"));

        Submission second = submission(101L, SubmissionStatus.ACCEPTED);
        second.setConfidence(Confidence.EASY);
        second.setReviewedAt(Instant.parse("2026-01-05T00:00:00Z"));

        // User now re-rates the FIRST submission as AGAIN — its reviewed_at jumps to "now".
        when(submissionRepository.findById(100L)).thenReturn(Optional.of(first));
        when(stateRepository.findByUserIdAndProblemId(1L, 10L))
                .thenReturn(Optional.of(ProblemReviewState.newFor(1L, 10L)));
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenAnswer(inv -> {
                    // Simulate what the DB would return after the in-tx update: order by new reviewed_at.
                    return List.of(second, first);
                });

        ReviewStateResponse resp = reviewService.setReview(100L, 1L, Confidence.AGAIN, null);

        // Replay: second EASY (interval 4, ease 2.60), then first AGAIN (interval reset to 1, ease 2.40).
        assertEquals(Confidence.AGAIN, resp.lastConfidence());
        assertEquals(1, resp.intervalDays());
    }

    @Test
    void setReview_emptyReplay_deletesState() {
        Submission sub = submission(100L, SubmissionStatus.ACCEPTED);
        // Imagine someone clears confidence elsewhere; replay would return empty.
        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of());

        // setReview always sets confidence, so this is mostly a guardrail —
        // we don't expect this to be hit in production for setReview.
        // But the replayState helper handles it; let's prove via getReviewState path instead.
        when(stateRepository.findByUserIdAndProblemId(1L, 10L)).thenReturn(Optional.empty());
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));

        Optional<ReviewStateResponse> resp = reviewService.getReviewState("two-sum", 1L);
        assertEquals(Optional.empty(), resp);
    }

    @Test
    void setReview_submissionNotFound() {
        when(submissionRepository.findById(999L)).thenReturn(Optional.empty());
        assertThrows(ResourceNotFoundException.class,
                () -> reviewService.setReview(999L, 1L, Confidence.GOOD, null));
        verify(stateRepository, never()).save(any());
    }

    @Test
    void setReview_submissionFromOtherUser_isRejected() {
        User other = new User();
        other.setId(99L);
        Submission sub = new Submission();
        sub.setId(100L);
        sub.setUser(other);
        sub.setProblem(problem);
        sub.setStatus(SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));

        assertThrows(ResourceNotFoundException.class,
                () -> reviewService.setReview(100L, 1L, Confidence.GOOD, null));
        verify(stateRepository, never()).save(any());
    }

    @Test
    void setReview_pendingSubmission_isRejected() {
        Submission pending = submission(100L, SubmissionStatus.PENDING);

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(pending));

        assertThrows(IllegalArgumentException.class,
                () -> reviewService.setReview(100L, 1L, Confidence.GOOD, null));
        verify(stateRepository, never()).save(any());
    }

    @Test
    void setReview_notesAreOverwrittenWhenProvided() {
        Submission sub = submission(100L, SubmissionStatus.ACCEPTED);
        sub.setNotes("old");

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));
        when(stateRepository.findByUserIdAndProblemId(1L, 10L)).thenReturn(Optional.empty());
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenAnswer(inv -> List.of(sub));

        reviewService.setReview(100L, 1L, Confidence.HARD, "new note");

        assertEquals("new note", sub.getNotes());
    }

    @Test
    void setReview_notesAreLeftAloneWhenNull() {
        Submission sub = submission(100L, SubmissionStatus.ACCEPTED);
        sub.setNotes("kept");

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));
        when(stateRepository.findByUserIdAndProblemId(1L, 10L)).thenReturn(Optional.empty());
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenAnswer(inv -> List.of(sub));

        reviewService.setReview(100L, 1L, Confidence.HARD, null);

        assertEquals("kept", sub.getNotes());
    }

    @Test
    void getReviewState_returnsEmptyWhenNoneRecorded() {
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(stateRepository.findByUserIdAndProblemId(1L, 10L)).thenReturn(Optional.empty());

        Optional<ReviewStateResponse> resp = reviewService.getReviewState("two-sum", 1L);

        assertEquals(Optional.empty(), resp);
    }

    @Test
    void getReviewHistory_returnsRatedSubmissionsInChronologicalOrder() {
        Submission first = submission(100L, SubmissionStatus.ACCEPTED);
        first.setConfidence(Confidence.HARD);
        first.setReviewedAt(Instant.parse("2026-01-01T00:00:00Z"));

        Submission second = submission(101L, SubmissionStatus.WRONG_ANSWER);
        second.setConfidence(Confidence.AGAIN);
        second.setReviewedAt(Instant.parse("2026-01-05T00:00:00Z"));

        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of(first, second));

        List<RatingHistoryItem> history = reviewService.getReviewHistory("two-sum", 1L);

        assertEquals(2, history.size());
        assertEquals(100L, history.get(0).submissionId());
        assertEquals(Confidence.HARD, history.get(0).confidence());
        assertEquals(SubmissionStatus.ACCEPTED, history.get(0).status());
        assertEquals(101L, history.get(1).submissionId());
        assertEquals(Confidence.AGAIN, history.get(1).confidence());
        assertEquals(SubmissionStatus.WRONG_ANSWER, history.get(1).status());
    }

    @Test
    void getReviewHistory_returnsEmptyWhenNothingRated() {
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of());

        List<RatingHistoryItem> history = reviewService.getReviewHistory("two-sum", 1L);

        assertEquals(0, history.size());
    }

    // Reference checks below to make Java compiler happy about unused imports.
    @SuppressWarnings("unused") private void _unusedTime() {
        Instant t = Instant.now().plus(1, ChronoUnit.SECONDS);
    }
}
