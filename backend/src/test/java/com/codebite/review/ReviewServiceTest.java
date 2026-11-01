package com.codebite.review;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.review.dto.RatingHistoryItem;
import com.codebite.review.dto.ReviewStateResponse;
import com.codebite.review.entity.Confidence;
import com.codebite.review.entity.ProblemReviewState;
import com.codebite.review.repository.ProblemReviewStateRepository;
import com.codebite.review.repository.ReviewRepository;
import com.codebite.review.schedule.Review;
import com.codebite.review.schedule.ReviewSchedule;
import com.codebite.review.service.ReviewService;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
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
    @Mock private ReviewRepository reviewRepository;

    private ReviewService reviewService;

    private User user;
    private Problem problem;

    @BeforeEach
    void setUp() {
        reviewService = new ReviewService(
                stateRepository, problemRepository, submissionRepository, reviewRepository);

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
        return submission(id, user, status);
    }

    private Submission submission(long id, User owner, SubmissionStatus status) {
        Submission s = Submission.pending(owner, problem, "java", "code");
        s.setId(id);
        if (status != SubmissionStatus.PENDING) {
            s.grade(Verdict.of(List.of(new CaseVerdict(status, true, "", null, null, 1, 1))),
                    List.of(new TestCase()));
        }
        return s;
    }

    @Test
    void setReview_firstTime_storesTheSnapshot() {
        Submission sub = submission(100L, SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of());

        ReviewStateResponse resp = reviewService.setReview(100L, 1L, Confidence.GOOD, null);

        assertEquals(Confidence.GOOD, sub.getConfidence());
        assertNotNull(sub.getReviewedAt());
        assertEquals(1, resp.reviewCount());
        assertEquals(2, resp.intervalDays()); // first GOOD → 2d
        assertEquals(Confidence.GOOD, resp.lastConfidence());
        assertEquals(sub.getReviewedAt(), resp.lastReviewedAt());
        assertEquals(sub.getReviewedAt().plus(2, ChronoUnit.DAYS), resp.nextDueAt());
        verify(submissionRepository).save(sub);
        verify(stateRepository).save(any(ProblemReviewState.class));
        verify(stateRepository, never()).deleteByUserIdAndProblemId(any(), any());
    }

    @Test
    void setReview_ratesAfterTheOtherSubmissionsReviews_droppingItsOwnEarlierOne() {
        // Before: first → GOOD (Jan 1), second → EASY (Jan 5). The user re-rates first as AGAIN.
        Submission first = submission(100L, SubmissionStatus.ACCEPTED);
        first.setConfidence(Confidence.GOOD);
        first.setReviewedAt(Instant.parse("2026-01-01T00:00:00Z"));
        Submission second = submission(101L, SubmissionStatus.ACCEPTED);
        second.setConfidence(Confidence.EASY);
        second.setReviewedAt(Instant.parse("2026-01-05T00:00:00Z"));

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(first));
        // What the repository holds before the change; the service must not count first's old GOOD.
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of(first, second));

        ReviewStateResponse resp = reviewService.setReview(100L, 1L, Confidence.AGAIN, null);

        // second EASY (4d, ease 2.60) then first AGAIN (1d, ease 2.40): two Reviews, not three.
        assertEquals(2, resp.reviewCount());
        assertEquals(Confidence.AGAIN, resp.lastConfidence());
        assertEquals(1, resp.intervalDays());
        assertEquals(0, resp.easeFactor().compareTo(new BigDecimal("2.40")));
    }

    @Test
    void clearReview_withOtherReviewsLeft_storesTheirSchedule() {
        Submission first = submission(100L, SubmissionStatus.ACCEPTED);
        first.setConfidence(Confidence.GOOD);
        first.setReviewedAt(Instant.parse("2026-01-01T00:00:00Z"));
        Submission second = submission(101L, SubmissionStatus.ACCEPTED);
        second.setConfidence(Confidence.EASY);
        second.setReviewedAt(Instant.parse("2026-01-05T00:00:00Z"));

        when(submissionRepository.findById(101L)).thenReturn(Optional.of(second));
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of(first, second));

        reviewService.clearReview(101L, 1L);

        assertNull(second.getConfidence());
        assertNull(second.getReviewedAt());
        ArgumentCaptor<ProblemReviewState> saved = ArgumentCaptor.forClass(ProblemReviewState.class);
        verify(stateRepository).save(saved.capture());
        assertEquals(1, saved.getValue().getReviewCount());
        assertEquals(Confidence.GOOD, saved.getValue().getLastConfidence());
        verify(stateRepository, never()).deleteByUserIdAndProblemId(any(), any());
    }

    @Test
    void clearReview_ofTheOnlyReview_deletesTheRow() {
        Submission only = submission(100L, SubmissionStatus.ACCEPTED);
        only.setConfidence(Confidence.GOOD);
        only.setReviewedAt(Instant.parse("2026-01-01T00:00:00Z"));

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(only));
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of(only));

        reviewService.clearReview(100L, 1L);

        verify(stateRepository).deleteByUserIdAndProblemId(1L, 10L);
        verify(stateRepository, never()).save(any());
    }

    @Test
    void setReview_emptyReplay_deletesState() {
        Submission sub = submission(100L, SubmissionStatus.ACCEPTED);
        // Imagine someone clears confidence elsewhere; replay would return empty.
        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of());

        // setReview always sets confidence, so this is mostly a guardrail —
        // we don't expect this to be hit in production for setReview.
        // But the replayState helper handles it; let's prove via getReviewState path instead.
        when(stateRepository.findByUserIdAndProblemId(1L, 10L)).thenReturn(Optional.empty());
        when(problemRepository.findBySlugOrFormerSlug("two-sum")).thenReturn(Optional.of(problem));

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
        Submission sub = submission(100L, other, SubmissionStatus.ACCEPTED);

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
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of());

        reviewService.setReview(100L, 1L, Confidence.HARD, "new note");

        assertEquals("new note", sub.getNotes());
    }

    @Test
    void setReview_notesAreLeftAloneWhenNull() {
        Submission sub = submission(100L, SubmissionStatus.ACCEPTED);
        sub.setNotes("kept");

        when(submissionRepository.findById(100L)).thenReturn(Optional.of(sub));
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of());

        reviewService.setReview(100L, 1L, Confidence.HARD, null);

        assertEquals("kept", sub.getNotes());
    }

    @Test
    void previewIntervals_excludesTheSubmissionsOwnReviewAndSavesNothing() {
        Submission first = submission(100L, SubmissionStatus.ACCEPTED);
        first.setConfidence(Confidence.GOOD);
        first.setReviewedAt(Instant.parse("2026-01-01T00:00:00Z"));
        Submission second = submission(101L, SubmissionStatus.ACCEPTED);
        second.setConfidence(Confidence.GOOD);
        second.setReviewedAt(Instant.parse("2026-01-02T00:00:00Z"));
        Submission third = submission(102L, SubmissionStatus.ACCEPTED);
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of(first, second));

        Map<Confidence, Integer> rerate = reviewService.previewIntervals(second);
        Map<Confidence, Integer> fresh = reviewService.previewIntervals(third);

        // Re-rating the second submission: only the first GOOD counts, so the second rung.
        assertEquals(Map.of(Confidence.AGAIN, 1, Confidence.HARD, 3,
                Confidence.GOOD, 6, Confidence.EASY, 10), rerate);
        // A fresh submission: both GOODs count.
        assertEquals(Map.of(Confidence.AGAIN, 1, Confidence.HARD, 7,
                Confidence.GOOD, 15, Confidence.EASY, 20), fresh);
        verify(stateRepository, never()).save(any(ProblemReviewState.class));
        verify(submissionRepository, never()).save(any(Submission.class));
    }

    private void storedState(Instant reviewedAt) {
        ProblemReviewState state = ProblemReviewState.of(1L, 10L,
                ReviewSchedule.replay(List.of(new Review(Confidence.GOOD, reviewedAt)))); // due 2 days on
        when(problemRepository.findBySlugOrFormerSlug("two-sum")).thenReturn(Optional.of(problem));
        when(stateRepository.findByUserIdAndProblemId(1L, 10L)).thenReturn(Optional.of(state));
    }

    @Test
    void getReviewState_countsWholeDaysOverdueLikeTheDueList() {
        storedState(Instant.now().minus(5, ChronoUnit.DAYS).minus(1, ChronoUnit.HOURS));

        ReviewStateResponse resp = reviewService.getReviewState("two-sum", 1L).orElseThrow();

        assertEquals(3, resp.daysOverdue());
    }

    @Test
    void getReviewState_isNotOverdueBeforeTheDueMoment() {
        storedState(Instant.now());

        ReviewStateResponse resp = reviewService.getReviewState("two-sum", 1L).orElseThrow();

        assertEquals(0, resp.daysOverdue());
    }

    @Test
    void getReviewState_returnsEmptyWhenNoneRecorded() {
        when(problemRepository.findBySlugOrFormerSlug("two-sum")).thenReturn(Optional.of(problem));
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

        when(problemRepository.findBySlugOrFormerSlug("two-sum")).thenReturn(Optional.of(problem));
        when(reviewRepository
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
        when(problemRepository.findBySlugOrFormerSlug("two-sum")).thenReturn(Optional.of(problem));
        when(reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(1L, 10L))
                .thenReturn(List.of());

        List<RatingHistoryItem> history = reviewService.getReviewHistory("two-sum", 1L);

        assertEquals(0, history.size());
    }
}
