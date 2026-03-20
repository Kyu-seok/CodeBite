package com.codebite.auth.service;

import com.codebite.user.dto.UserProfile;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service
@ConditionalOnBean(StringRedisTemplate.class)
public class UserCacheService {

    private static final Logger log = LoggerFactory.getLogger(UserCacheService.class);
    private static final String KEY_PREFIX = "user:";
    private static final String KEY_SUFFIX = ":profile";

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;
    private final long ttlSeconds;

    public UserCacheService(StringRedisTemplate redisTemplate,
                            ObjectMapper objectMapper,
                            @Value("${app.cache.user-profile-ttl-seconds:300}") long ttlSeconds) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = objectMapper;
        this.ttlSeconds = ttlSeconds;
    }

    public Optional<UserProfile> getCachedProfile(Long userId) {
        try {
            String json = redisTemplate.opsForValue().get(KEY_PREFIX + userId + KEY_SUFFIX);
            if (json == null) {
                return Optional.empty();
            }
            return Optional.of(objectMapper.readValue(json, UserProfile.class));
        } catch (Exception e) {
            log.warn("Failed to read cached profile for user {}: {}", userId, e.getMessage());
            return Optional.empty();
        }
    }

    public void cacheProfile(Long userId, UserProfile profile) {
        try {
            String json = objectMapper.writeValueAsString(profile);
            redisTemplate.opsForValue().set(KEY_PREFIX + userId + KEY_SUFFIX, json, ttlSeconds, TimeUnit.SECONDS);
        } catch (JsonProcessingException e) {
            log.warn("Failed to cache profile for user {}: {}", userId, e.getMessage());
        }
    }

    public void evictProfile(Long userId) {
        try {
            redisTemplate.delete(KEY_PREFIX + userId + KEY_SUFFIX);
        } catch (Exception e) {
            log.warn("Failed to evict cached profile for user {}: {}", userId, e.getMessage());
        }
    }
}
