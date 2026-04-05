package com.codebite.run.controller;

import com.codebite.common.exception.RateLimitExceededException;
import com.codebite.common.service.RateLimiterService;
import com.codebite.run.dto.RunResponse;
import com.codebite.run.service.RunService;
import com.codebite.submission.dto.SubmitRequest;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class RunController {

    private final RunService runService;

    @Autowired(required = false)
    private RateLimiterService rateLimiterService;

    public RunController(RunService runService) {
        this.runService = runService;
    }

    @PostMapping("/problems/{slug}/run")
    public ResponseEntity<RunResponse> run(
            @PathVariable String slug,
            @Valid @RequestBody SubmitRequest request,
            HttpServletRequest httpRequest) {
        if (rateLimiterService != null
                && rateLimiterService.isRateLimited("run", getClientIp(httpRequest), 5)) {
            throw new RateLimitExceededException("error.ratelimit.run");
        }
        RunResponse response = runService.run(slug, request);
        return ResponseEntity.ok(response);
    }

    private String getClientIp(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isBlank()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
