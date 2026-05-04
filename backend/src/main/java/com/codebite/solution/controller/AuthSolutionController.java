package com.codebite.solution.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.common.exception.RateLimitExceededException;
import com.codebite.common.service.RateLimiterService;
import com.codebite.solution.dto.CommentResponse;
import com.codebite.solution.dto.CreateCommentRequest;
import com.codebite.solution.dto.CreateSolutionRequest;
import com.codebite.solution.dto.ReportRequest;
import com.codebite.solution.dto.SolutionDetail;
import com.codebite.solution.dto.UpdateCommentRequest;
import com.codebite.solution.dto.UpdateSolutionRequest;
import com.codebite.solution.dto.VoteRequest;
import com.codebite.solution.dto.VoteResponse;
import com.codebite.solution.entity.ReportTargetType;
import com.codebite.solution.service.CommentService;
import com.codebite.solution.service.ReportService;
import com.codebite.solution.service.SolutionService;
import com.codebite.solution.service.VoteService;
import com.codebite.user.entity.Role;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@PreAuthorize("isAuthenticated()")
public class AuthSolutionController {

    private final SolutionService solutionService;
    private final VoteService voteService;
    private final CommentService commentService;
    private final ReportService reportService;

    @Autowired(required = false)
    private RateLimiterService rateLimiterService;

    public AuthSolutionController(SolutionService solutionService,
                                  VoteService voteService,
                                  CommentService commentService,
                                  ReportService reportService) {
        this.solutionService = solutionService;
        this.voteService = voteService;
        this.commentService = commentService;
        this.reportService = reportService;
    }

    @PostMapping("/problems/{slug}/solutions")
    public ResponseEntity<SolutionDetail> create(
            @PathVariable String slug,
            @Valid @RequestBody CreateSolutionRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        rateLimit("solution-post", principal.id().toString(), 60, "error.ratelimit.solution-post");
        SolutionDetail created = solutionService.create(slug, request, principal.id());
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/solutions/{id}")
    public ResponseEntity<SolutionDetail> update(
            @PathVariable Long id,
            @Valid @RequestBody UpdateSolutionRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(
                solutionService.update(id, request, principal.id(), isAdmin(principal)));
    }

    @DeleteMapping("/solutions/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        solutionService.delete(id, principal.id(), isAdmin(principal));
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/solutions/{id}/vote")
    public ResponseEntity<VoteResponse> vote(
            @PathVariable Long id,
            @Valid @RequestBody VoteRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(voteService.vote(id, principal.id(), request.direction()));
    }

    @DeleteMapping("/solutions/{id}/vote")
    public ResponseEntity<VoteResponse> clearVote(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(voteService.clear(id, principal.id()));
    }

    @PostMapping("/solutions/{id}/comments")
    public ResponseEntity<CommentResponse> addComment(
            @PathVariable Long id,
            @Valid @RequestBody CreateCommentRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        rateLimit("solution-comment", principal.id().toString(), 5, "error.ratelimit.solution-comment");
        CommentResponse created = commentService.create(id, request, principal.id());
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/comments/{id}")
    public ResponseEntity<CommentResponse> updateComment(
            @PathVariable Long id,
            @Valid @RequestBody UpdateCommentRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(
                commentService.update(id, request, principal.id(), isAdmin(principal)));
    }

    @DeleteMapping("/comments/{id}")
    public ResponseEntity<Void> deleteComment(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        commentService.delete(id, principal.id(), isAdmin(principal));
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/solutions/{id}/report")
    public ResponseEntity<Void> reportSolution(
            @PathVariable Long id,
            @Valid @RequestBody ReportRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        rateLimit("solution-report", principal.id().toString(), 3600, "error.ratelimit.report");
        reportService.fileReport(ReportTargetType.SOLUTION, id, request, principal.id());
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PostMapping("/comments/{id}/report")
    public ResponseEntity<Void> reportComment(
            @PathVariable Long id,
            @Valid @RequestBody ReportRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        rateLimit("comment-report", principal.id().toString(), 3600, "error.ratelimit.report");
        reportService.fileReport(ReportTargetType.COMMENT, id, request, principal.id());
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    private boolean isAdmin(JwtUserPrincipal principal) {
        return principal.role() == Role.ADMIN;
    }

    private void rateLimit(String action, String identifier, long ttlSeconds, String errorKey) {
        if (rateLimiterService != null
                && rateLimiterService.isRateLimited(action, identifier, ttlSeconds)) {
            throw new RateLimitExceededException(errorKey);
        }
    }
}
