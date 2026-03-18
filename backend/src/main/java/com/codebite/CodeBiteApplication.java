package com.codebite;

import com.codebite.config.OAuthProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(OAuthProperties.class)
public class CodeBiteApplication {

    public static void main(String[] args) {
        SpringApplication.run(CodeBiteApplication.class, args);
    }
}
