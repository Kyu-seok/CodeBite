package com.codebite.auth.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
@ConditionalOnBean(StringRedisTemplate.class)
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
