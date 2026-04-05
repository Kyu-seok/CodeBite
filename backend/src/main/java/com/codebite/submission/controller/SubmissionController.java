package com.codebite.submission.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.submission.dto.SubmissionListItem;
import com.codebite.submission.dto.SubmissionResponse;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.dto.UpdateNoteRequest;
import com.codebite.common.exception.RateLimitExceededException;
import com.codebite.common.service.RateLimiterService;
import com.codebite.submission.service.SubmissionService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class SubmissionController {

    private final SubmissionService submissionService;

    @Autowired(required = false)
    private RateLimiterService rateLimiterService;

    public SubmissionController(SubmissionService submissionService) {
        this.submissionService = submissionService;
    }

    @PostMapping("/problems/{slug}/submit")
    public ResponseEntity<SubmissionResponse> submit(
            @PathVariable String slug,
            @Valid @RequestBody SubmitRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        if (rateLimiterService != null
                && rateLimiterService.isRateLimited("submit", String.valueOf(principal.id()), 10)) {
            throw new RateLimitExceededException("error.ratelimit.submit");
        }
        SubmissionResponse response = submissionService.submit(slug, request, principal.id());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/submissions/{id}")
    public ResponseEntity<SubmissionResponse> getSubmission(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        SubmissionResponse response = submissionService.getSubmission(id, principal.id());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/problems/{slug}/submissions")
    public ResponseEntity<List<SubmissionListItem>> getUserSubmissions(
            @PathVariable String slug,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        List<SubmissionListItem> submissions = submissionService.getUserSubmissions(slug, principal.id());
        return ResponseEntity.ok(submissions);
    }

    @PatchMapping("/submissions/{id}/note")
    public ResponseEntity<Void> updateNote(
            @PathVariable Long id,
            @Valid @RequestBody UpdateNoteRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        submissionService.updateNote(id, request.notes(), principal.id());
        return ResponseEntity.ok().build();
    }
}
