package com.codebite.auth.controller;

import com.codebite.auth.dto.AuthResponse;
import com.codebite.auth.dto.OAuthCallbackRequest;
import com.codebite.auth.dto.OAuthUrlResponse;
import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.auth.service.AuthService;
import com.codebite.auth.service.TokenBlacklistService;
import com.codebite.user.dto.UserProfile;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final JwtTokenProvider tokenProvider;

    @Autowired(required = false)
    private TokenBlacklistService tokenBlacklistService;

    public AuthController(AuthService authService, JwtTokenProvider tokenProvider) {
        this.authService = authService;
        this.tokenProvider = tokenProvider;
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

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (StringUtils.hasText(header) && header.startsWith("Bearer ") && tokenBlacklistService != null) {
            String token = header.substring(7);
            String tokenId = tokenProvider.getTokenId(token);
            Date expiration = tokenProvider.getExpiration(token);
            long remainingTtl = expiration.getTime() - System.currentTimeMillis();
            if (remainingTtl > 0) {
                tokenBlacklistService.blacklist(tokenId, remainingTtl);
            }
        }
        return ResponseEntity.noContent().build();
    }
}
