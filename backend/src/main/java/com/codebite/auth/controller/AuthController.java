package com.codebite.auth.controller;

import com.codebite.auth.dto.AuthResponse;
import com.codebite.auth.dto.OAuthCallbackRequest;
import com.codebite.auth.dto.OAuthUrlResponse;
import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.auth.service.AuthService;
import com.codebite.user.dto.UserProfile;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/oauth/{provider}")
    public ResponseEntity<OAuthUrlResponse> getAuthorizationUrl(@PathVariable String provider) {
        String url = authService.getAuthorizationUrl(provider);
        return ResponseEntity.ok(new OAuthUrlResponse(url));
    }

    @PostMapping("/oauth/{provider}/callback")
    public ResponseEntity<AuthResponse> handleOAuthCallback(
            @PathVariable String provider,
            @Valid @RequestBody OAuthCallbackRequest request) {
        AuthResponse response = authService.handleOAuthCallback(provider, request.code(), request.state());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/me")
    public ResponseEntity<UserProfile> me(@AuthenticationPrincipal JwtUserPrincipal principal) {
        UserProfile profile = authService.getCurrentUser(principal.id());
        return ResponseEntity.ok(profile);
    }
}
