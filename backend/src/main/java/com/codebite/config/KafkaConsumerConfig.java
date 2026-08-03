package com.codebite.config;

import com.codebite.submission.event.SubmissionResultEvent;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.support.serializer.ErrorHandlingDeserializer;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.util.HashMap;
import java.util.Map;

/**
 * Consumer setup for the backend's result listener.
 *
 * <p>The backend was producer-only until the {@code submission-results} fan-out; this is the only
 * thing it consumes. Kept as an explicit factory rather than Spring Boot's auto-configured one so
 * the broadcast semantics (see {@code SubmissionResultListener}) stay visible next to the config
 * that enables them.
 */
@Configuration
@ConditionalOnProperty(name = "app.kafka.enabled", havingValue = "true", matchIfMissing = true)
public class KafkaConsumerConfig {

    @Bean
    public ConsumerFactory<String, SubmissionResultEvent> submissionResultConsumerFactory(
            @Value("${spring.kafka.bootstrap-servers}") String bootstrapServers) {

        JsonDeserializer<SubmissionResultEvent> valueDeserializer =
                new JsonDeserializer<>(SubmissionResultEvent.class);
        valueDeserializer.addTrustedPackages("com.codebite.submission.event");
        // The worker sends this exact type; ignoring the type header keeps the two sides from
        // being coupled through a fully-qualified class name in the payload.
        valueDeserializer.setUseTypeHeaders(false);

        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        // A replica only pushes results for connections it currently holds, so history is noise.
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, true);

        return new DefaultKafkaConsumerFactory<>(
                props,
                new StringDeserializer(),
                // A malformed record must not wedge the listener: without this, deserialization
                // fails inside the poll loop and the same offset is retried forever.
                new ErrorHandlingDeserializer<>(valueDeserializer));
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent>
            submissionResultListenerContainerFactory(
                    ConsumerFactory<String, SubmissionResultEvent> submissionResultConsumerFactory) {

        ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(submissionResultConsumerFactory);
        return factory;
    }
}
