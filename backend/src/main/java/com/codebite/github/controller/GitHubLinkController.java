package com.codebite.github.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.github.dto.GitHubLinkPagesResponse;
import com.codebite.github.dto.GitHubLinkCallbackRequest;
import com.codebite.github.dto.GitHubLinkResponse;
import com.codebite.github.service.GitHubImportService;
import com.codebite.github.service.GitHubLinkService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** The signed-in user's own GitHub Link. Separate from signing in with GitHub (ADR 0003). */
@RestController
@RequestMapping("/api/github/link")
public class GitHubLinkController {

    private final GitHubLinkService linkService;
    private final GitHubImportService importService;

    public GitHubLinkController(GitHubLinkService linkService, GitHubImportService importService) {
        this.linkService = linkService;
        this.importService = importService;
    }

    /**
     * The current link, or 204 when the user has none. An ACTIVE link is read from the row, never
     * from GitHub; a BROKEN one is re-checked through {@code GitHubGateway.isRepositoryReachable}
     * and recovered to ACTIVE when its repository is reachable again.
     */
    @GetMapping
    public ResponseEntity<GitHubLinkResponse> getLink(@AuthenticationPrincipal JwtUserPrincipal principal) {
        return linkService.getLink(principal.id())
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.noContent().build());
    }

    /**
     * Marks the current link UNLINKED, keeping the row; no GitHub call, the Solution Repository is
     * left untouched. 204 whether or not a link existed.
     */
    @DeleteMapping
    public ResponseEntity<Void> unlink(@AuthenticationPrincipal JwtUserPrincipal principal) {
        linkService.unlink(principal.id());
        return ResponseEntity.noContent().build();
    }

    /**
     * The GitHub pages that create the named Solution Repository (from the
     * {@code app.github.solution-repository-template} template) and install the App on it: 400 for
     * a name or visibility GitHub wouldn't accept, 503 when the App is not configured.
     */
    @GetMapping("/install")
    public ResponseEntity<GitHubLinkPagesResponse> linkPages(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @RequestParam String repositoryName,
            @RequestParam(defaultValue = "public") String visibility) {
        return ResponseEntity.ok(linkService.linkPages(principal.id(), repositoryName, visibility));
    }

    /**
     * Completes the install GitHub redirected back from: links the granted repository named in the
     * state (case-insensitively), or the only granted one when none has that name. 400 when several
     * were granted and none has it, 401 for a state not issued to this user, 403 when the
     * installation is not the signed-in GitHub account's.
     */
    @PostMapping("/callback")
    public ResponseEntity<GitHubLinkResponse> callback(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @Valid @RequestBody GitHubLinkCallbackRequest request) {
        return ResponseEntity.ok(linkService.completeInstall(principal.id(), request));
    }

    /**
     * Starts the Import: 202 with the link (import state RUNNING) while it is AVAILABLE or FAILED,
     * 409 when it is RUNNING or DONE or the link is BROKEN, 404 without a link. It runs in the
     * background through the {@code github-imports} topic; poll {@code GET /api/github/link}.
     */
    @PostMapping("/import")
    public ResponseEntity<GitHubLinkResponse> startImport(@AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.accepted().body(importService.start(principal.id()));
    }
}
