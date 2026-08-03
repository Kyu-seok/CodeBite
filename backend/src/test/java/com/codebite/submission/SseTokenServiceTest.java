package com.codebite.submission;

import com.codebite.submission.sse.SseTokenService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class SseTokenServiceTest {

    @Mock private StringRedisTemplate redisTemplate;
    @Mock private ValueOperations<String, String> valueOps;

    private final Map<String, String> store = new HashMap<>();
    private SseTokenService service;

    @BeforeEach
    void setUp() {
        when(redisTemplate.opsForValue()).thenReturn(valueOps);
        doAnswer(inv -> {
            store.put(inv.getArgument(0), inv.getArgument(1));
            return null;
        }).when(valueOps).set(anyString(), anyString(), anyLong(), any(TimeUnit.class));
        when(valueOps.get(anyString())).thenAnswer(inv -> store.get(inv.getArgument(0)));

        service = new SseTokenService(redisTemplate, 180);
    }

    @Test
    void resolvesTheIssuingUserForItsOwnSubmission() {
        String token = service.issue(7L, 42L);

        assertEquals(Optional.of(7L), service.resolve(token, 42L));
    }

    @Test
    void refusesATokenIssuedForADifferentSubmission() {
        String token = service.issue(7L, 42L);

        // The whole point of binding the token: it must not open someone else's stream.
        assertEquals(Optional.empty(), service.resolve(token, 43L));
    }

    @Test
    void refusesAnUnknownToken() {
        assertEquals(Optional.empty(), service.resolve("not-a-real-token", 42L));
    }

    @Test
    void refusesNullAndBlankTokens() {
        assertEquals(Optional.empty(), service.resolve(null, 42L));
        assertEquals(Optional.empty(), service.resolve("   ", 42L));
    }

    @Test
    void failsClosedWhenRedisIsUnreachable() {
        when(valueOps.get(anyString())).thenThrow(new RuntimeException("connection refused"));

        // Unlike the cache and rate limiter, this is an authorisation check — it must not fail open.
        assertEquals(Optional.empty(), service.resolve("any-token", 42L));
    }

    @Test
    void storesTheTokenUnderTheConfiguredTtl() {
        service.issue(7L, 42L);

        verify(valueOps).set(anyString(), eq("7:42"), eq(180L), eq(TimeUnit.SECONDS));
    }

    @Test
    void issuesUnguessableDistinctTokens() {
        String first = service.issue(7L, 42L);
        String second = service.issue(7L, 42L);

        assertNotEquals(first, second);
        // 32 random bytes, url-safe base64, unpadded.
        assertTrue(first.length() >= 43, "token too short to be unguessable: " + first.length());
        assertTrue(first.matches("[A-Za-z0-9_-]+"), "token must be URL-safe: " + first);
    }
}
