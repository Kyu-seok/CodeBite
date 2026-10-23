package com.codebite.streak.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.streak.dto.RepairRequest;
import com.codebite.streak.dto.StreakCalendar;
import com.codebite.streak.dto.StreakSummary;
import com.codebite.streak.service.StreakService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.YearMonth;

/** The signed-in user's own Streak. Repairs and Repair Progress are never exposed for others. */
@RestController
@RequestMapping("/api/streak")
public class StreakController {

    private final StreakService streakService;

    public StreakController(StreakService streakService) {
        this.streakService = streakService;
    }

    @GetMapping
    public ResponseEntity<StreakSummary> getSummary(@AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(streakService.getSummary(principal.id()));
    }

    /** {@code month} is {@code yyyy-MM}, e.g. {@code 2026-10}. */
    @GetMapping("/days")
    public ResponseEntity<StreakCalendar> getCalendar(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @RequestParam YearMonth month) {
        return ResponseEntity.ok(streakService.getCalendar(principal.id(), month));
    }

    /** Spends one Repair to turn the given Missed Day into a Repaired Day. */
    @PostMapping("/repairs")
    public ResponseEntity<StreakSummary> repair(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @Valid @RequestBody RepairRequest request) {
        return ResponseEntity.ok(streakService.repair(principal.id(), request.date()));
    }
}
