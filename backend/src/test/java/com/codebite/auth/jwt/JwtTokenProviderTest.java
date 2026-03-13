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
