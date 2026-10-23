package com.codebite.github.service;

import com.codebite.common.exception.InvalidOAuthStateException;
import com.codebite.config.GitHubAppProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.UUID;

/**
 * Signs the {@code state} carried through the GitHub App install, bound to the CodeBite user who
 * started it. GitHub hands the state back on the callback, which is rejected unless the same user
 * completes it, so a crafted install link cannot attach someone else's installation to a victim.
 */
@Service
public class GitHubLinkStateService {

    private static final String PURPOSE = "github-link";

    private final SecretKey key;
    private final long expirationMs;

    public GitHubLinkStateService(@Value("${app.jwt.secret}") String secret, GitHubAppProperties properties) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.expirationMs = properties.getStateExpirationMs();
    }

    public String issue(Long userId) {
        Date now = new Date();
        return Jwts.builder()
                .subject(userId.toString())
                .claim("purpose", PURPOSE)
                .claim("nonce", UUID.randomUUID().toString())
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expirationMs))
                .signWith(key)
                .compact();
    }

    /** @throws InvalidOAuthStateException if the state is forged, expired or another user's */
    public void verify(String state, Long userId) {
        Claims claims;
        try {
            claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(state).getPayload();
        } catch (JwtException | IllegalArgumentException e) {
            throw new InvalidOAuthStateException("error.github.link.stateInvalid");
        }
        if (!PURPOSE.equals(claims.get("purpose", String.class)) || !userId.toString().equals(claims.getSubject())) {
            throw new InvalidOAuthStateException("error.github.link.stateInvalid");
        }
    }
}
