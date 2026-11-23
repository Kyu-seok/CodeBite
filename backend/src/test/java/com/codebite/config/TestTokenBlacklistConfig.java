package com.codebite.config;

import com.codebite.auth.service.InMemoryTokenBlacklistService;
import com.codebite.auth.service.TokenBlacklistService;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/** Logout's token blacklist in every Spring test context, which runs without Redis. */
@Configuration
@ConditionalOnProperty(name = "app.cache.enabled", havingValue = "false")
public class TestTokenBlacklistConfig {

    @Bean
    public TokenBlacklistService tokenBlacklistService() {
        return new InMemoryTokenBlacklistService();
    }
}
