package com.codebite.auth.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * The token blacklist without Redis, for test contexts (which run with {@code app.cache.enabled}
 * false): an entry lasts its TTL, as a Redis key with an expiry does.
 */
public class InMemoryTokenBlacklistService extends TokenBlacklistService {

    private final Map<String, Long> expiresAtMillis = new ConcurrentHashMap<>();

    public InMemoryTokenBlacklistService() {
        super(null);
    }

    @Override
    public void blacklist(String tokenId, long ttlMillis) {
        expiresAtMillis.put(tokenId, System.currentTimeMillis() + ttlMillis);
    }

    @Override
    public boolean isBlacklisted(String tokenId) {
        Long expiresAt = expiresAtMillis.get(tokenId);
        return expiresAt != null && expiresAt > System.currentTimeMillis();
    }
}
