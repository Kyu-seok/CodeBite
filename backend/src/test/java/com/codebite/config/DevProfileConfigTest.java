package com.codebite.config;

import org.junit.jupiter.api.Test;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Configuration;

import static org.assertj.core.api.Assertions.assertThat;

/** What a local {@code SPRING_PROFILES_ACTIVE=dev} run resolves, without starting the app. */
class DevProfileConfigTest {

    @Configuration
    static class Empty {
    }

    @Test
    void devProfileKeepsLocalCorsOriginsEvenWithTheProductionValueExported() {
        try (ConfigurableApplicationContext context = new SpringApplicationBuilder(Empty.class)
                .profiles("dev")
                .web(WebApplicationType.NONE)
                .run("--CORS_ALLOWED_ORIGINS=https://code-bite.com")) {
            assertThat(context.getEnvironment().getProperty("app.cors.allowed-origins"))
                    .isEqualTo("http://localhost:5173,http://localhost:5174,http://localhost:3000");
        }
    }
}
