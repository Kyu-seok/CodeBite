package com.codebite.auth.jwt;

import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class JwtTokenProviderTest {

    private JwtTokenProvider tokenProvider;

    @BeforeEach
    void setUp() {
        tokenProvider = new JwtTokenProvider(
                "test-secret-key-that-is-at-least-256-bits-long-for-hmac-sha256-testing",
                60000
        );
    }

    private User createTestUser() {
        User user = new User();
        user.setId(1L);
        user.setUsername("testuser");
        user.setEmail("test@test.com");
        user.setRole(Role.USER);
        return user;
    }

    @Test
    void generateToken_returnsNonNullToken() {
        String token = tokenProvider.generateToken(createTestUser());
        assertNotNull(token);
        assertFalse(token.isBlank());
    }

    @Test
    void validateToken_validToken_returnsTrue() {
        String token = tokenProvider.generateToken(createTestUser());
        assertTrue(tokenProvider.validateToken(token));
    }

    @Test
    void validateToken_garbageToken_returnsFalse() {
        assertFalse(tokenProvider.validateToken("not.a.valid.token"));
    }

    @Test
    void validateToken_nullToken_returnsFalse() {
        assertFalse(tokenProvider.validateToken(null));
    }

    @Test
    void parseToken_extractsCorrectClaims() {
        User user = createTestUser();
        String token = tokenProvider.generateToken(user);

        JwtUserPrincipal principal = tokenProvider.parseToken(token);

        assertEquals(1L, principal.id());
        assertEquals("testuser", principal.username());
        assertEquals(Role.USER, principal.role());
        assertNotNull(principal.tokenId());
    }

    @Test
    void generateToken_includesUniqueJti() {
        User user = createTestUser();
        String token1 = tokenProvider.generateToken(user);
        String token2 = tokenProvider.generateToken(user);

        String jti1 = tokenProvider.getTokenId(token1);
        String jti2 = tokenProvider.getTokenId(token2);

        assertNotNull(jti1);
        assertNotNull(jti2);
        assertNotEquals(jti1, jti2);
    }

    @Test
    void getExpiration_isTheConfiguredLifetimeAfterIssue() {
        long before = System.currentTimeMillis();
        String token = tokenProvider.generateToken(createTestUser());
        long after = System.currentTimeMillis();

        long expiry = tokenProvider.getExpiration(token).getTime();

        // A JWT carries whole seconds, so the expiry can fall up to a second before issue + 60 s.
        assertTrue(expiry > before - 1000 + 60000 && expiry <= after + 60000,
                "expiry " + expiry + " is not 60 s after issue (" + before + ".." + after + ")");
    }

    @Test
    void validateToken_expiredToken_returnsFalse() {
        JwtTokenProvider shortLived = new JwtTokenProvider(
                "test-secret-key-that-is-at-least-256-bits-long-for-hmac-sha256-testing",
                0  // expires immediately
        );
        String token = shortLived.generateToken(createTestUser());
        assertFalse(shortLived.validateToken(token));
    }
}
