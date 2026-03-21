package com.codebite.worker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(
        scanBasePackages = {
                "com.codebite.worker",
                "com.codebite.judge",
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
