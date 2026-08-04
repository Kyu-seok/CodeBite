package com.codebite.submission.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.submission.dto.SubmissionListItem;
import com.codebite.submission.dto.SubmissionResponse;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.dto.UpdateNoteRequest;
import com.codebite.submission.dto.UpdateSolveTimeRequest;
import com.codebite.common.exception.RateLimitExceededException;
import com.codebite.common.service.RateLimiterService;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.service.SubmissionService;
import com.codebite.submission.sse.SseTokenService;
import com.codebite.submission.sse.SubmissionEmitterRegistry;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class SubmissionController {

    private final SubmissionService submissionService;
    private final SubmissionEmitterRegistry emitterRegistry;
    private final long streamTimeoutMs;

    @Autowired(required = false)
    private RateLimiterService rateLimiterService;

    /** Absent when Redis is disabled; the stream endpoints then 404 and clients keep polling. */
    @Autowired(required = false)
    private SseTokenService sseTokenService;

    public SubmissionController(SubmissionService submissionService,
                                SubmissionEmitterRegistry emitterRegistry,
                                @Value("${app.submission.sse.timeout-ms:120000}") long streamTimeoutMs) {
        this.submissionService = submissionService;
        this.emitterRegistry = emitterRegistry;
        this.streamTimeoutMs = streamTimeoutMs;
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

    @PatchMapping("/submissions/{id}/solve-time")
    public ResponseEntity<Void> setSolveTime(
            @PathVariable Long id,
            @Valid @RequestBody UpdateSolveTimeRequest request,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        submissionService.setSolveTime(id, request.solveTimeSeconds(), principal.id());
        return ResponseEntity.noContent().build();
    }

    /**
     * Exchanges the caller's JWT for a short-lived token that opens the result stream.
     * Returns 404 when SSE is unavailable (no Redis) so the client falls back to polling.
     */
    @PostMapping("/submissions/{id}/stream-token")
    public ResponseEntity<StreamTokenResponse> issueStreamToken(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        if (sseTokenService == null) {
            return ResponseEntity.notFound().build();
        }
        // Ownership check: throws if the submission is not this user's.
        submissionService.getSubmission(id, principal.id());

        String token = sseTokenService.issue(principal.id(), id);
        return ResponseEntity.ok(new StreamTokenResponse(token, sseTokenService.ttlSeconds()));
    }

    /**
     * Streams the terminal result for one submission.
     *
     * <p>Authenticated by the query-string token rather than the JWT filter, because
     * {@code EventSource} cannot set request headers. Permitted in SecurityConfig for that reason —
     * the token itself carries the authorisation.
     */
    @GetMapping(value = "/submissions/{id}/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public ResponseEntity<SseEmitter> stream(
            @PathVariable Long id,
            @RequestParam("token") String token) {
        if (sseTokenService == null) {
            return ResponseEntity.notFound().build();
        }
        Long userId = sseTokenService.resolve(token, id).orElse(null);
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        SseEmitter emitter = new SseEmitter(streamTimeoutMs);
        emitterRegistry.register(id, emitter);

        // The result may have landed between the submit response and this connection opening, in
        // which case no further event is coming — resolve from the database instead of hanging.
        SubmissionResponse current = submissionService.getSubmission(id, userId);
        if (current.status() != SubmissionStatus.PENDING) {
            emitterRegistry.completeWith(id, Map.of(
                    "submissionId", id,
                    "status", current.status().name()));
        }
        return ResponseEntity.ok(emitter);
    }

    public record StreamTokenResponse(String token, long expiresInSeconds) {
    }
}
