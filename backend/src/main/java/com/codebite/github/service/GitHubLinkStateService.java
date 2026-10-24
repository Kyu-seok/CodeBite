package com.codebite.github.service;

import com.codebite.common.exception.InvalidOAuthStateException;
import com.codebite.config.GitHubAppProperties;
import com.codebite.github.gateway.GitHubAccount;
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
 *
 * <p>Also signs the selection token handed out when an install grants several repositories. It
 * carries what the callback verified (the user, the authorising GitHub account and the
 * installation), so choosing the Solution Repository never trusts client-sent values for them.
 */
@Service
public class GitHubLinkStateService {

    private static final String PURPOSE = "github-link";
    private static final String SELECTION_PURPOSE = "github-repository-selection";

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
        parse(state, PURPOSE, userId, "error.github.link.stateInvalid");
    }

    /** Signs what a verified install callback established, for {@code PUT /repository} to trust. */
    public String issueSelection(Long userId, GitHubAccount account, long installationId) {
        Date now = new Date();
        return Jwts.builder()
                .subject(userId.toString())
                .claim("purpose", SELECTION_PURPOSE)
                .claim("githubAccountId", account.id())
                .claim("githubLogin", account.login())
                .claim("installationId", installationId)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expirationMs))
                .signWith(key)
                .compact();
    }

    /** @throws InvalidOAuthStateException if the token is forged, expired or another user's */
    public Selection verifySelection(String token, Long userId) {
        Claims claims = parse(token, SELECTION_PURPOSE, userId, "error.github.link.selectionInvalid");
        return new Selection(
                new GitHubAccount(claims.get("githubAccountId", Long.class), claims.get("githubLogin", String.class)),
                claims.get("installationId", Long.class));
    }

    private Claims parse(String token, String purpose, Long userId, String messageCode) {
        Claims claims;
        try {
            claims = Jwts.parser().verifyWith(key).build().parseSignedClaims(token).getPayload();
        } catch (JwtException | IllegalArgumentException e) {
            throw new InvalidOAuthStateException(messageCode);
        }
        if (!purpose.equals(claims.get("purpose", String.class)) || !userId.toString().equals(claims.getSubject())) {
            throw new InvalidOAuthStateException(messageCode);
        }
        return claims;
    }

    /** The GitHub account and installation a verified install callback resolved. */
    public record Selection(GitHubAccount account, long installationId) {
    }
}
