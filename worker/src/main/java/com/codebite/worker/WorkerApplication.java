package com.codebite.worker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * Scans only the parts of {@code com.codebite.judge} the worker grades with. The backend assembles
 * every Program and the event carries it, so {@code judge.program}'s ProblemAssets (every Driver
 * and Starter Code, read at startup) stays out of this context.
 */
@SpringBootApplication(
        scanBasePackages = {
                "com.codebite.worker",
                "com.codebite.judge.client",
                "com.codebite.judge.service",
                "com.codebite.judge.grader",
                "com.codebite.config"
        },
        exclude = {
                SecurityAutoConfiguration.class,
                RedisAutoConfiguration.class
        }
)
@EntityScan("com.codebite")
@EnableJpaRepositories("com.codebite")
public class WorkerApplication {

    public static void main(String[] args) {
        SpringApplication.run(WorkerApplication.class, args);
    }
}
