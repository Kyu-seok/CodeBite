package com.codebite.common.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

// Gated on the property rather than @ConditionalOnBean(StringRedisTemplate.class): condition
// evaluation for component-scanned beans runs before RedisAutoConfiguration registers that
// template, so the bean-based condition never matched and no cooldown was ever applied.
// Mirrors RedisConfig and UserCacheService.
@Service
@ConditionalOnProperty(name = "app.cache.enabled", havingValue = "true", matchIfMissing = false)
public class RateLimiterService {

    private static final Logger log = LoggerFactory.getLogger(RateLimiterService.class);
    private static final String KEY_PREFIX = "ratelimit:";

    private final StringRedisTemplate redisTemplate;

    public RateLimiterService(StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    /**
     * Returns true if the request is rate limited (should be rejected).
     * Returns false if the request is allowed (cooldown key was set).
     */
    public boolean isRateLimited(String action, String identifier, long ttlSeconds) {
        try {
            String key = KEY_PREFIX + action + ":" + identifier;
            Boolean wasSet = redisTemplate.opsForValue()
                    .setIfAbsent(key, "1", ttlSeconds, TimeUnit.SECONDS);
            return !Boolean.TRUE.equals(wasSet);
        } catch (Exception e) {
            log.warn("Rate limit check failed for {}:{} — {}", action, identifier, e.getMessage());
            return false;
        }
    }
}
