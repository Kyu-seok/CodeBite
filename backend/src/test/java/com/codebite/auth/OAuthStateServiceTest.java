package com.codebite.auth;

import com.codebite.auth.oauth.OAuthStateService;
import com.codebite.common.exception.InvalidOAuthStateException;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

class OAuthStateServiceTest {

    private static final String SECRET = "test-secret-key-that-is-at-least-256-bits-long-for-hmac-sha256-testing";

    @Test
    void generateAndValidate_roundTrip() {
        OAuthStateService service = new OAuthStateService(SECRET, 300000);

        String state = service.generateState("google");
        assertNotNull(state);

        String provider = service.validateState(state);
        assertEquals("google", provider);
    }

    @Test
    void validate_expiredState_throws() {
        // Create service with 0ms expiration — state expires immediately
        OAuthStateService service = new OAuthStateService(SECRET, 0);

        String state = service.generateState("github");
        assertThrows(InvalidOAuthStateException.class, () -> service.validateState(state));
    }

    @Test
    void validate_tamperedState_throws() {
        OAuthStateService service = new OAuthStateService(SECRET, 300000);

        String state = service.generateState("google");
        String tampered = state + "x";
        assertThrows(InvalidOAuthStateException.class, () -> service.validateState(tampered));
    }

    @Test
    void validate_differentSecret_throws() {
        OAuthStateService service1 = new OAuthStateService(SECRET, 300000);
        String differentSecret = "another-secret-key-that-is-at-least-256-bits-long-for-hmac-sha256-test";
        OAuthStateService service2 = new OAuthStateService(differentSecret, 300000);

        String state = service1.generateState("google");
        assertThrows(InvalidOAuthStateException.class, () -> service2.validateState(state));
    }
}
