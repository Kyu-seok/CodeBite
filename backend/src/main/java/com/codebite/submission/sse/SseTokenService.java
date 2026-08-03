package com.codebite.submission.sse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

/**
 * Issues short-lived tokens that authorise a single SSE stream.
 *
 * <p>{@code EventSource} cannot set an Authorization header, so the stream endpoint cannot use the
 * normal JWT filter. Rather than put the JWT itself in the query string — where it would land in
 * nginx access logs with a 24h lifetime — the client exchanges its JWT for a token that is opaque,
 * scoped to one submission belonging to one user, and expires in minutes.
 *
 * <p>Deliberately <em>not</em> single-use: {@code EventSource} reconnects automatically and reuses
 * the original URL, so consuming the token on first read would break every reconnect. The narrow
 * scope and short TTL are what bound the exposure instead.
 *
 * <p>Requires Redis. Without it no token can be issued, the stream endpoint is unavailable, and the
 * frontend stays on its polling path.
 */
// Gated on the property rather than @ConditionalOnBean(StringRedisTemplate.class): condition
// evaluation for component-scanned beans runs before RedisAutoConfiguration registers that
// template, so the bean-based condition is always false and the service silently never exists.
// This mirrors RedisConfig, which supplies the Redis beans under the same flag.
@Service
@ConditionalOnProperty(name = "app.cache.enabled", havingValue = "true", matchIfMissing = false)
public class SseTokenService {

    private static final Logger log = LoggerFactory.getLogger(SseTokenService.class);
    private static final String KEY_PREFIX = "sse:token:";

    private final StringRedisTemplate redisTemplate;
    private final SecureRandom random = new SecureRandom();
    private final long ttlSeconds;

    public SseTokenService(StringRedisTemplate redisTemplate,
                           @Value("${app.submission.sse.token-ttl-seconds:180}") long ttlSeconds) {
        this.redisTemplate = redisTemplate;
        this.ttlSeconds = ttlSeconds;
    }

    /** Issues a token bound to exactly this user and submission. */
    public String issue(Long userId, Long submissionId) {
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        redisTemplate.opsForValue().set(
                KEY_PREFIX + token, userId + ":" + submissionId, ttlSeconds, TimeUnit.SECONDS);
        return token;
    }

    /**
     * Returns the user this token authorises for {@code submissionId}, or empty if the token is
     * unknown, expired, or bound to a different submission.
     */
    public Optional<Long> resolve(String token, Long submissionId) {
        if (token == null || token.isBlank()) {
            return Optional.empty();
        }
        try {
            String value = redisTemplate.opsForValue().get(KEY_PREFIX + token);
            if (value == null) {
                return Optional.empty();
            }
            int separator = value.indexOf(':');
            Long userId = Long.valueOf(value.substring(0, separator));
            Long boundSubmissionId = Long.valueOf(value.substring(separator + 1));

            // A token for submission A must never open a stream for submission B.
            if (!boundSubmissionId.equals(submissionId)) {
                log.warn("SSE token bound to submission {} was used for {}",
                        boundSubmissionId, submissionId);
                return Optional.empty();
            }
            return Optional.of(userId);
        } catch (Exception e) {
            // Fail closed: unlike the cache and rate limiter, this is an authorisation check.
            log.warn("Could not resolve SSE token: {}", e.getMessage());
            return Optional.empty();
        }
    }

    public long ttlSeconds() {
        return ttlSeconds;
    }
}
