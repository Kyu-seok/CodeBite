package com.codebite.review.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.common.time.DayRuns;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.profile.dto.ActivityDay;
import com.codebite.review.dto.DueReviewItem;
import com.codebite.review.dto.RatingHistoryItem;
import com.codebite.review.dto.ReviewHistoryItem;
import com.codebite.review.dto.ReviewStateResponse;
import com.codebite.review.dto.ReviewStatsResponse;
import com.codebite.review.dto.TagConfidenceItem;
import com.codebite.review.entity.Confidence;
import com.codebite.review.entity.ProblemReviewState;
import com.codebite.review.repository.ProblemReviewStateRepository;
import com.codebite.review.repository.ReviewRepository;
import com.codebite.review.repository.TagConfidenceCount;
import com.codebite.review.schedule.Review;
import com.codebite.review.schedule.ReviewSchedule;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ReviewService {

    private final ProblemReviewStateRepository stateRepository;
    private final ProblemRepository problemRepository;
    private final SubmissionRepository submissionRepository;
    private final ReviewRepository reviewRepository;

    public ReviewService(ProblemReviewStateRepository stateRepository,
                         ProblemRepository problemRepository,
                         SubmissionRepository submissionRepository,
                         ReviewRepository reviewRepository) {
        this.stateRepository = stateRepository;
        this.problemRepository = problemRepository;
        this.submissionRepository = submissionRepository;
        this.reviewRepository = reviewRepository;
    }

    @Transactional
    public ReviewStateResponse setReview(Long submissionId, Long userId,
                                         Confidence confidence, String notes) {
        Submission submission = submissionRepository.findById(submissionId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "error.submission.notFound", submissionId));
        if (!submission.getUser().getId().equals(userId)) {
            // Don't leak existence to non-owner.
            throw new ResourceNotFoundException("error.submission.notFound", submissionId);
        }
        if (submission.getStatus() == SubmissionStatus.PENDING) {
            throw new IllegalArgumentException("error.review.pending");
        }

        Instant now = Instant.now();
        submission.setConfidence(confidence);
        submission.setReviewedAt(now);
        if (notes != null) {
            submission.setNotes(notes);
        }
        submissionRepository.save(submission);

        Long problemId = submission.getProblem().getId();
        ReviewSchedule schedule = ReviewSchedule
                .replay(reviewsExcept(userId, problemId, submission.getId()))
                .rate(confidence, now);
        return toStateResponse(store(userId, problemId, schedule), now);
    }

    @Transactional
    public void clearReview(Long submissionId, Long userId) {
        Submission submission = submissionRepository.findById(submissionId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "error.submission.notFound", submissionId));
        if (!submission.getUser().getId().equals(userId)) {
            throw new ResourceNotFoundException("error.submission.notFound", submissionId);
        }
        // No-op if already cleared.
        if (submission.getConfidence() == null) return;

        submission.setConfidence(null);
        submission.setReviewedAt(null);
        submissionRepository.save(submission);

        Long problemId = submission.getProblem().getId();
        store(userId, problemId,
                ReviewSchedule.replay(reviewsExcept(userId, problemId, submission.getId())));
    }

    @Transactional(readOnly = true)
    public Optional<ReviewStateResponse> getReviewState(String slug, Long userId) {
        Problem problem = problemRepository.findBySlugOrFormerSlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));
        return stateRepository.findByUserIdAndProblemId(userId, problem.getId())
                .map(s -> toStateResponse(s, Instant.now()));
    }

    @Transactional(readOnly = true)
    public Page<ReviewHistoryItem> getFilteredHistory(
            Long userId,
            Confidence confidence,
            Difficulty difficulty,
            String tagSlug,
            int page,
            int size) {
        Page<Submission> submissions = reviewRepository.findRatedFiltered(
                userId, confidence, difficulty, tagSlug, PageRequest.of(page, size));
        return submissions.map(this::toHistoryItem);
    }

    private ReviewHistoryItem toHistoryItem(Submission s) {
        Problem p = s.getProblem();
        List<String> tagSlugs = p.getTags().stream().map(Tag::getSlug).sorted().toList();
        return new ReviewHistoryItem(
                s.getId(),
                p.getSlug(),
                p.getTitle(),
                p.getProblemNumber(),
                p.getDifficulty(),
                tagSlugs,
                s.getLanguage(),
                s.getStatus(),
                s.getConfidence(),
                s.getReviewedAt(),
                s.getSolveTimeSeconds()
        );
    }

    @Transactional(readOnly = true)
    public List<RatingHistoryItem> getReviewHistory(String slug, Long userId) {
        Problem problem = problemRepository.findBySlugOrFormerSlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));
        return reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(
                        userId, problem.getId())
                .stream()
                .map(s -> new RatingHistoryItem(
                        s.getId(),
                        s.getConfidence(),
                        s.getReviewedAt(),
                        s.getLanguage(),
                        s.getStatus()))
                .toList();
    }

    @Transactional(readOnly = true)
    public Page<DueReviewItem> getDueReviews(Long userId, int page, int size) {
        Instant now = Instant.now();
        Page<ProblemReviewState> states = stateRepository.findDue(
                userId, now, PageRequest.of(page, size));
        return states.map(s -> toDueItem(s, now));
    }

    @Transactional(readOnly = true)
    public long getDueCount(Long userId) {
        return stateRepository.countDue(userId, Instant.now());
    }

    @Transactional(readOnly = true)
    public List<ActivityDay> getReviewActivity(Long userId, int months) {
        Instant since = Instant.now().minus(months * 30L, ChronoUnit.DAYS);
        return reviewRepository.countDailyReviews(userId, since).stream()
                .map(day -> new ActivityDay(day.day(), (int) day.count()))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<TagConfidenceItem> getTagConfidenceDistribution(Long userId) {
        // Pivot one row per (tag, confidence) into one DTO per tag.
        record TagKey(String slug, String name) {}
        Map<TagKey, long[]> byTag = new LinkedHashMap<>();
        for (TagConfidenceCount row : reviewRepository.countConfidenceByTag(userId)) {
            long[] counts = byTag.computeIfAbsent(new TagKey(row.slug(), row.name()), k -> new long[4]);
            int idx = switch (row.confidence()) {
                case AGAIN -> 0;
                case HARD -> 1;
                case GOOD -> 2;
                case EASY -> 3;
            };
            counts[idx] += row.count();
        }
        return byTag.entrySet().stream()
                .map(e -> new TagConfidenceItem(
                        e.getKey().slug(),
                        e.getKey().name(),
                        e.getValue()[0],
                        e.getValue()[1],
                        e.getValue()[2],
                        e.getValue()[3]))
                .sorted((a, b) -> Long.compare(b.total(), a.total()))
                .toList();
    }

    @Transactional(readOnly = true)
    public ReviewStatsResponse getStats(Long userId) {
        long totalReviews = reviewRepository.countRated(userId);
        long totalSolveTimeSeconds = reviewRepository.sumSolveTimeSecondsForRated(userId);
        List<LocalDate> reviewDates = reviewRepository.findDistinctReviewDates(userId);
        int currentStreak = DayRuns.current(reviewDates, LocalDate.now(ZoneOffset.UTC));
        int longestStreak = DayRuns.longest(reviewDates);
        return new ReviewStatsResponse(
                totalReviews, totalSolveTimeSeconds, currentStreak, longestStreak);
    }

    /**
     * Keep problem_review_state for (userId, problemId) as the snapshot of this schedule. The
     * Reviews are the source of truth; the row is deleted when none is left and null is returned.
     */
    private ProblemReviewState store(Long userId, Long problemId, ReviewSchedule schedule) {
        if (schedule.isEmpty()) {
            stateRepository.deleteByUserIdAndProblemId(userId, problemId);
            return null;
        }
        return stateRepository.save(ProblemReviewState.of(userId, problemId, schedule));
    }

    /**
     * The Reviews of the user's other submissions of the problem: a re-rated submission drops
     * its earlier Review, so its new one goes in through {@link ReviewSchedule#rate} last, and
     * a cleared one is simply gone. Neither depends on the submission's own change having been
     * flushed yet.
     */
    private List<Review> reviewsExcept(Long userId, Long problemId, Long submissionId) {
        return reviewRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(userId, problemId)
                .stream()
                .filter(s -> !s.getId().equals(submissionId))
                .map(s -> new Review(s.getConfidence(), s.getReviewedAt()))
                .toList();
    }

    /**
     * The interval, in days, each confidence would schedule if the learner rated this
     * submission now. Mirrors {@link #setReview}: the submission's own earlier rating (if any)
     * drops out and the new one is replayed last, after every other rated submission.
     */
    @Transactional(readOnly = true)
    public Map<Confidence, Integer> previewIntervals(Submission submission) {
        List<Review> others = reviewsExcept(
                submission.getUser().getId(), submission.getProblem().getId(), submission.getId());
        return ReviewSchedule.replay(others).preview(Instant.now());
    }

    private ReviewStateResponse toStateResponse(ProblemReviewState s, Instant now) {
        return new ReviewStateResponse(
                s.getProblemId(),
                s.getReviewCount(),
                s.getEaseFactor(),
                s.getIntervalDays(),
                s.getLastReviewedAt(),
                s.getLastConfidence(),
                s.getNextDueAt(),
                s.isMastered(),
                daysOverdue(s, now)
        );
    }

    private DueReviewItem toDueItem(ProblemReviewState s, Instant now) {
        Problem problem = problemRepository.findById(s.getProblemId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "error.problem.notFound", s.getProblemId()));
        List<String> tagSlugs = problem.getTags().stream().map(Tag::getSlug).sorted().toList();
        return new DueReviewItem(
                problem.getId(),
                problem.getSlug(),
                problem.getTitle(),
                problem.getProblemNumber(),
                problem.getDifficulty(),
                tagSlugs,
                s.getLastConfidence(),
                s.getLastReviewedAt(),
                s.getNextDueAt(),
                daysOverdue(s, now)
        );
    }

    /** Whole days past the due moment, 0 before it; the due list and ReviewStateResponse both use it. */
    private static long daysOverdue(ProblemReviewState s, Instant now) {
        return Math.max(0, ChronoUnit.DAYS.between(s.getNextDueAt(), now));
    }
}
