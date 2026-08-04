package com.codebite.worker.config;

import com.codebite.worker.consumer.SubmissionFailureRecoverer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.listener.DefaultErrorHandler;
import org.springframework.util.backoff.FixedBackOff;

@Configuration
public class KafkaConsumerConfig {

    @Bean
    public DefaultErrorHandler errorHandler(SubmissionFailureRecoverer recoverer) {
        return new DefaultErrorHandler(recoverer, new FixedBackOff(1000L, 3));
    }
}
