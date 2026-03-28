package com.codebite.roadmap.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.roadmap.dto.RoadmapResponse;
import com.codebite.roadmap.service.RoadmapService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/roadmap")
public class RoadmapController {

    private final RoadmapService roadmapService;

    public RoadmapController(RoadmapService roadmapService) {
        this.roadmapService = roadmapService;
    }

    @GetMapping
    public ResponseEntity<RoadmapResponse> getRoadmap(
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        Long userId = principal != null ? principal.id() : null;
        return ResponseEntity.ok(roadmapService.getRoadmap(userId));
    }
}
