package com.codebite.config;

import com.codebite.github.gateway.FakeGitHubGateway;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

/** Swaps the real GitHub App adapter for the in-memory fake in every Spring test context. */
@Configuration
public class TestGitHubConfig {

    @Bean
    @Primary
    public FakeGitHubGateway fakeGitHubGateway() {
        return new FakeGitHubGateway();
    }
}
