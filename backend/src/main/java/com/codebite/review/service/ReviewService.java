package com.codebite.review.service;

import com.codebite.common.exception.ResourceNotFoundException;
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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ReviewService {

    private final ProblemReviewStateRepository stateRepository;
    private final ProblemRepository problemRepository;
    private final SubmissionRepository submissionRepository;

    public ReviewService(ProblemReviewStateRepository stateRepository,
                         ProblemRepository problemRepository,
                         SubmissionRepository submissionRepository) {
        this.stateRepository = stateRepository;
        this.problemRepository = problemRepository;
        this.submissionRepository = submissionRepository;
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

        submission.setConfidence(confidence);
        submission.setReviewedAt(Instant.now());
        if (notes != null) {
            submission.setNotes(notes);
        }
        submissionRepository.save(submission);

        ProblemReviewState state = replayState(userId, submission.getProblem().getId());
        return toStateResponse(state);
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

        replayState(userId, submission.getProblem().getId());
    }

    @Transactional(readOnly = true)
    public Optional<ReviewStateResponse> getReviewState(String slug, Long userId) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));
        return stateRepository.findByUserIdAndProblemId(userId, problem.getId())
                .map(this::toStateResponse);
    }

    @Transactional(readOnly = true)
    public Page<ReviewHistoryItem> getFilteredHistory(
            Long userId,
            Confidence confidence,
            Difficulty difficulty,
            String tagSlug,
            int page,
            int size) {
        Page<Submission> submissions = submissionRepository.findRatedFiltered(
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
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));
        return submissionRepository
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
        List<Object[]> rows = submissionRepository.countDailyReviews(userId, since);
        List<ActivityDay> result = new ArrayList<>();
        for (Object[] row : rows) {
            result.add(new ActivityDay((LocalDate) row[0], ((Long) row[1]).intValue()));
        }
        return result;
    }

    @Transactional(readOnly = true)
    public List<TagConfidenceItem> getTagConfidenceDistribution(Long userId) {
        List<Object[]> rows = submissionRepository.countConfidenceByTag(userId);
        // Pivot (tagSlug, tagName, confidence, count) rows into one DTO per tag.
        record TagKey(String slug, String name) {}
        Map<TagKey, long[]> byTag = new LinkedHashMap<>();
        for (Object[] row : rows) {
            String slug = (String) row[0];
            String name = (String) row[1];
            Confidence conf = (Confidence) row[2];
            long count = (Long) row[3];
            long[] counts = byTag.computeIfAbsent(new TagKey(slug, name), k -> new long[4]);
            int idx = switch (conf) {
                case AGAIN -> 0;
                case HARD -> 1;
                case GOOD -> 2;
                case EASY -> 3;
            };
            counts[idx] += count;
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
        long totalReviews = submissionRepository.countRated(userId);
        long totalSolveTimeSeconds = submissionRepository.sumSolveTimeSecondsForRated(userId);
        List<LocalDate> reviewDates = submissionRepository.findDistinctReviewDates(userId);
        int currentStreak = computeCurrentStreak(reviewDates, LocalDate.now(ZoneOffset.UTC));
        int longestStreak = computeLongestStreak(reviewDates);
        return new ReviewStatsResponse(
                totalReviews, totalSolveTimeSeconds, currentStreak, longestStreak);
    }

    /**
     * Current streak = consecutive days ending today (or yesterday) that contain a review.
     * Yesterday counts so the streak doesn't "die" mid-day before the user reviews again.
     * `dates` is expected sorted DESC.
     */
    public static int computeCurrentStreak(List<LocalDate> dates, LocalDate today) {
        if (dates.isEmpty()) return 0;
        LocalDate mostRecent = dates.get(0);
        if (mostRecent.isBefore(today.minusDays(1))) return 0;
        int streak = 1;
        LocalDate prev = mostRecent;
        for (int i = 1; i < dates.size(); i++) {
            LocalDate d = dates.get(i);
            if (d.equals(prev.minusDays(1))) {
                streak++;
                prev = d;
            } else {
                break;
            }
        }
        return streak;
    }

    /**
     * Longest run of consecutive days anywhere in the history. `dates` may be in any order.
     */
    public static int computeLongestStreak(List<LocalDate> dates) {
        if (dates.isEmpty()) return 0;
        List<LocalDate> sorted = dates.stream().sorted().toList();
        int longest = 1;
        int current = 1;
        for (int i = 1; i < sorted.size(); i++) {
            if (sorted.get(i).equals(sorted.get(i - 1).plusDays(1))) {
                current++;
                if (current > longest) longest = current;
            } else if (!sorted.get(i).equals(sorted.get(i - 1))) {
                current = 1;
            }
        }
        return longest;
    }

    /**
     * Rebuild problem_review_state for (userId, problemId) by replaying every rated
     * submission in chronological reviewed_at order through SM-2 lite. Source of truth
     * lives on the submissions, so this is always derivable.
     */
    private ProblemReviewState replayState(Long userId, Long problemId) {
        List<Submission> rated = submissionRepository
                .findByUserIdAndProblemIdAndConfidenceIsNotNullOrderByReviewedAtAsc(
                        userId, problemId);

        if (rated.isEmpty()) {
            stateRepository.deleteByUserIdAndProblemId(userId, problemId);
            return null;
        }

        ProblemReviewState state = stateRepository
                .findByUserIdAndProblemId(userId, problemId)
                .orElseGet(() -> ProblemReviewState.newFor(userId, problemId));
        // Reset before replay so re-rating an old submission doesn't compound.
        ProblemReviewState fresh = ProblemReviewState.newFor(userId, problemId);
        for (Submission s : rated) {
            fresh.applyReview(s.getConfidence(), s.getReviewedAt());
        }
        // Copy replayed values onto the persisted (or newly-created) entity instance.
        state.setReviewCount(fresh.getReviewCount());
        state.setEaseFactor(fresh.getEaseFactor());
        state.setIntervalDays(fresh.getIntervalDays());
        state.setLastReviewedAt(fresh.getLastReviewedAt());
        state.setLastConfidence(fresh.getLastConfidence());
        state.setNextDueAt(fresh.getNextDueAt());
        state.setMastered(isMastered(rated, fresh));

        return stateRepository.save(state);
    }

    /**
     * Mastered = at least 3 reviews, last 2 are GOOD or EASY, current interval ≥ 30 days.
     * "Last" is by chronological reviewed_at, matching the replay order.
     */
    static boolean isMastered(List<Submission> rated, ProblemReviewState state) {
        if (rated.size() < 3) return false;
        if (state.getIntervalDays() < 30) return false;
        Confidence last = rated.get(rated.size() - 1).getConfidence();
        Confidence prev = rated.get(rated.size() - 2).getConfidence();
        return isGoodOrEasy(last) && isGoodOrEasy(prev);
    }

    private static boolean isGoodOrEasy(Confidence c) {
        return c == Confidence.GOOD || c == Confidence.EASY;
    }

    private ReviewStateResponse toStateResponse(ProblemReviewState s) {
        return new ReviewStateResponse(
                s.getProblemId(),
                s.getReviewCount(),
                s.getEaseFactor(),
                s.getIntervalDays(),
                s.getLastReviewedAt(),
                s.getLastConfidence(),
                s.getNextDueAt(),
                s.isMastered()
        );
    }

    private DueReviewItem toDueItem(ProblemReviewState s, Instant now) {
        Problem problem = problemRepository.findById(s.getProblemId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "error.problem.notFound", s.getProblemId()));
        List<String> tagSlugs = problem.getTags().stream().map(Tag::getSlug).sorted().toList();
        long overdueDays = Math.max(0,
                ChronoUnit.DAYS.between(s.getNextDueAt(), now));
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
                overdueDays
        );
    }
}
