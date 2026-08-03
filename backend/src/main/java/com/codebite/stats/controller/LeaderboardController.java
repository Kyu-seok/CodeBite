package com.codebite.stats.controller;

import com.codebite.stats.dto.LeaderboardEntry;
import com.codebite.stats.service.StatsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class LeaderboardController {

    private static final int MAX_LIMIT = 100;

    private final StatsService statsService;

    public LeaderboardController(StatsService statsService) {
        this.statsService = statsService;
    }

    /**
     * Reads the precomputed leaderboard. Public, like the problem list — it exposes usernames and
     * solve counts, nothing private.
     */
    @GetMapping("/leaderboard")
    public ResponseEntity<List<LeaderboardEntry>> leaderboard(
            @RequestParam(defaultValue = "20") int limit) {
        int bounded = Math.max(1, Math.min(limit, MAX_LIMIT));
        return ResponseEntity.ok(statsService.leaderboard(bounded));
    }
}
