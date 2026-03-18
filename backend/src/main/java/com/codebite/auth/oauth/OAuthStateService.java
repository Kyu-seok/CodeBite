package com.codebite.auth.oauth;

import com.codebite.common.exception.InvalidOAuthStateException;
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

@Service
public class OAuthStateService {

    private final SecretKey key;
    private final long stateExpirationMs;

    public OAuthStateService(
            @Value("${app.jwt.secret}") String secret,
            @Value("${app.oauth.state-expiration-ms}") long stateExpirationMs) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.stateExpirationMs = stateExpirationMs;
    }

    public String generateState(String provider) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + stateExpirationMs);

        return Jwts.builder()
                .claim("provider", provider)
                .claim("nonce", UUID.randomUUID().toString())
                .issuedAt(now)
                .expiration(expiry)
                .signWith(key)
                .compact();
    }

    public String validateState(String state) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(state)
                    .getPayload();

            return claims.get("provider", String.class);
        } catch (JwtException | IllegalArgumentException e) {
            throw new InvalidOAuthStateException("Invalid or expired OAuth state");
        }
    }
}
