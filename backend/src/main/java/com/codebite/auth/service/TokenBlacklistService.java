package com.codebite.auth.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

// Gated on the property rather than @ConditionalOnBean(StringRedisTemplate.class): condition
// evaluation for component-scanned beans runs before RedisAutoConfiguration registers that
// template, so the bean-based condition never matched and logout silently did not invalidate
// anything. Mirrors RedisConfig and UserCacheService.
@Service
@ConditionalOnProperty(name = "app.cache.enabled", havingValue = "true", matchIfMissing = false)
public class TokenBlacklistService {

    private static final Logger log = LoggerFactory.getLogger(TokenBlacklistService.class);
    private static final String KEY_PREFIX = "blacklist:";

    private final StringRedisTemplate redisTemplate;

    public TokenBlacklistService(StringRedisTemplate redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    public void blacklist(String tokenId, long ttlMillis) {
        try {
            redisTemplate.opsForValue().set(KEY_PREFIX + tokenId, "1", ttlMillis, TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            log.warn("Failed to blacklist token {}: {}", tokenId, e.getMessage());
        }
    }

    public boolean isBlacklisted(String tokenId) {
        try {
            return Boolean.TRUE.equals(redisTemplate.hasKey(KEY_PREFIX + tokenId));
        } catch (Exception e) {
            log.warn("Failed to check token blacklist for {}: {}", tokenId, e.getMessage());
            return false;
        }
    }
}
