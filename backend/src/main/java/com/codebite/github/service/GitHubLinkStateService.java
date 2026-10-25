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
 * It also carries the name of the Solution Repository the user chose, for the callback to link.
 */
@Service
public class GitHubLinkStateService {

    private static final String PURPOSE = "github-link";
    private static final String STATE_INVALID = "error.github.link.stateInvalid";

    private final SecretKey key;
    private final long expirationMs;

    public GitHubLinkStateService(@Value("${app.jwt.secret}") String secret, GitHubAppProperties properties) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.expirationMs = properties.getStateExpirationMs();
    }

    public String issue(Long userId, String repositoryName) {
        Date now = new Date();
        return Jwts.builder()
                .subject(userId.toString())
                .claim("purpose", PURPOSE)
                .claim("repositoryName", repositoryName)
                .claim("nonce", UUID.randomUUID().toString())
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expirationMs))
                .signWith(key)
                .compact();
    }

    /**
     * @return the name of the Solution Repository the user chose
     * @throws InvalidOAuthStateException if the state is forged, expired or another user's
     */
    public String verify(String state, Long userId) {
        Claims claims;
        try {
            claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(state).getPayload();
        } catch (JwtException | IllegalArgumentException e) {
            throw new InvalidOAuthStateException(STATE_INVALID);
        }
        if (!PURPOSE.equals(claims.get("purpose", String.class)) || !userId.toString().equals(claims.getSubject())) {
            throw new InvalidOAuthStateException(STATE_INVALID);
        }
        return claims.get("repositoryName", String.class);
    }
}
