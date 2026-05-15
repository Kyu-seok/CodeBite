package com.codebite.review.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.profile.dto.ActivityDay;
import com.codebite.review.dto.DueReviewItem;
import com.codebite.problem.entity.Difficulty;
import com.codebite.review.dto.RatingHistoryItem;
import com.codebite.review.dto.ReviewHistoryItem;
import com.codebite.review.dto.ReviewStateResponse;
import com.codebite.review.dto.ReviewStatsResponse;
import com.codebite.review.dto.SetReviewRequest;
import com.codebite.review.dto.TagConfidenceItem;
import com.codebite.review.entity.Confidence;
import com.codebite.review.service.ReviewService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class ReviewController {

    private final ReviewService reviewService;

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @PutMapping("/submissions/{id}/review")
    public ResponseEntity<ReviewStateResponse> setReview(
            @PathVariable Long id,
            @Valid @RequestBody SetReviewRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        ReviewStateResponse state = reviewService.setReview(
                id, principal.id(), request.confidence(), request.notes());
        return ResponseEntity.ok(state);
    }

    @DeleteMapping("/submissions/{id}/review")
    public ResponseEntity<Void> clearReview(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        reviewService.clearReview(id, principal.id());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/problems/{slug}/review-state")
    public ResponseEntity<ReviewStateResponse> getReviewState(
            @PathVariable String slug,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        Optional<ReviewStateResponse> state = reviewService.getReviewState(slug, principal.id());
        return state.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.noContent().build());
    }

    @GetMapping("/problems/{slug}/review-history")
    public ResponseEntity<List<RatingHistoryItem>> getReviewHistory(
            @PathVariable String slug,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(reviewService.getReviewHistory(slug, principal.id()));
    }

    @GetMapping("/reviews/due")
    public ResponseEntity<Page<DueReviewItem>> getDueReviews(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(reviewService.getDueReviews(principal.id(), page, size));
    }

    @GetMapping("/reviews/due/count")
    public ResponseEntity<Map<String, Long>> getDueCount(
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(Map.of("count", reviewService.getDueCount(principal.id())));
    }

    @GetMapping("/reviews/stats")
    public ResponseEntity<ReviewStatsResponse> getStats(
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(reviewService.getStats(principal.id()));
    }

    @GetMapping("/reviews/activity")
    public ResponseEntity<List<ActivityDay>> getActivity(
            @RequestParam(defaultValue = "12") int months,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(reviewService.getReviewActivity(principal.id(), months));
    }

    @GetMapping("/reviews/tag-confidence")
    public ResponseEntity<List<TagConfidenceItem>> getTagConfidence(
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(reviewService.getTagConfidenceDistribution(principal.id()));
    }

    @GetMapping("/reviews/history")
    public ResponseEntity<Page<ReviewHistoryItem>> getHistory(
            @RequestParam(required = false) Confidence confidence,
            @RequestParam(required = false) Difficulty difficulty,
            @RequestParam(required = false) String tag,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(reviewService.getFilteredHistory(
                principal.id(), confidence, difficulty, tag, page, size));
    }
}
