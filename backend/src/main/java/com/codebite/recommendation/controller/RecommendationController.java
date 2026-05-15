package com.codebite.recommendation.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.recommendation.dto.RoadmapNextItem;
import com.codebite.recommendation.dto.WeakCategoryItem;
import com.codebite.recommendation.service.RecommendationService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/recommendations")
public class RecommendationController {

    private final RecommendationService recommendationService;

    public RecommendationController(RecommendationService recommendationService) {
        this.recommendationService = recommendationService;
    }

    @GetMapping("/weak-tags")
    public ResponseEntity<List<WeakCategoryItem>> getWeakTags(
            @RequestParam(defaultValue = "3") int limit,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(recommendationService.getWeakTags(principal.id(), limit));
    }

    @GetMapping("/roadmap-next")
    public ResponseEntity<List<RoadmapNextItem>> getRoadmapNext(
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(recommendationService.getRoadmapNext(principal.id()));
    }
}
