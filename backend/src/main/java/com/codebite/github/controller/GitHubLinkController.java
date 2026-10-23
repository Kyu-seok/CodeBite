package com.codebite.github.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.github.dto.GitHubInstallUrlResponse;
import com.codebite.github.dto.GitHubLinkCallbackRequest;
import com.codebite.github.dto.GitHubLinkCallbackResponse;
import com.codebite.github.dto.GitHubLinkResponse;
import com.codebite.github.dto.GitHubRepositoryChoiceRequest;
import com.codebite.github.service.GitHubLinkService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** The signed-in user's own GitHub Link. Separate from signing in with GitHub (ADR 0003). */
@RestController
@RequestMapping("/api/github/link")
public class GitHubLinkController {

    private final GitHubLinkService linkService;

    public GitHubLinkController(GitHubLinkService linkService) {
        this.linkService = linkService;
    }

    /** The current link, or 204 when the user has none. */
    @GetMapping
    public ResponseEntity<GitHubLinkResponse> getLink(@AuthenticationPrincipal JwtUserPrincipal principal) {
        return linkService.getLink(principal.id())
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.noContent().build());
    }

    /** Unlinks; the Solution Repository is left untouched. 204 whether or not a link existed. */
    @DeleteMapping
    public ResponseEntity<Void> unlink(@AuthenticationPrincipal JwtUserPrincipal principal) {
        linkService.unlink(principal.id());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/install")
    public ResponseEntity<GitHubInstallUrlResponse> installUrl(@AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(linkService.installUrl(principal.id()));
    }

    /** Completes the install GitHub redirected back from; links when one repository was granted. */
    @PostMapping("/callback")
    public ResponseEntity<GitHubLinkCallbackResponse> callback(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @Valid @RequestBody GitHubLinkCallbackRequest request) {
        return ResponseEntity.ok(linkService.completeInstall(principal.id(), request));
    }

    /** Chooses the Solution Repository when the install granted several. */
    @PutMapping("/repository")
    public ResponseEntity<GitHubLinkResponse> chooseRepository(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @Valid @RequestBody GitHubRepositoryChoiceRequest request) {
        return ResponseEntity.ok(linkService.chooseRepository(principal.id(), request));
    }
}
