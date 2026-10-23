package com.codebite.config;

import com.codebite.submission.event.SubmissionResultEvent;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.listener.DefaultErrorHandler;
import org.springframework.kafka.support.ExponentialBackOffWithMaxRetries;
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

    private static final Logger log = LoggerFactory.getLogger(KafkaConsumerConfig.class);

    /**
     * Shared deserializer setup. {@link ErrorHandlingDeserializer} matters: without it a malformed
     * record fails inside the poll loop and the same offset is retried forever, wedging the
     * partition.
     */
    private static ErrorHandlingDeserializer<SubmissionResultEvent> resultDeserializer() {
        JsonDeserializer<SubmissionResultEvent> valueDeserializer =
                new JsonDeserializer<>(SubmissionResultEvent.class);
        valueDeserializer.addTrustedPackages("com.codebite.submission.event");
        // The worker sends this exact type; ignoring the type header keeps the two sides from
        // being coupled through a fully-qualified class name in the payload.
        valueDeserializer.setUseTypeHeaders(false);
        return new ErrorHandlingDeserializer<>(valueDeserializer);
    }

    private static Map<String, Object> baseProps(String bootstrapServers, String autoOffsetReset) {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, autoOffsetReset);
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, true);
        return props;
    }

    /**
     * SSE push. {@code latest} is deliberate: a replica can only push results for connections it
     * currently holds, so replaying history on startup would deliver events nobody is waiting for.
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent>
            submissionResultListenerContainerFactory(
                    @Value("${spring.kafka.bootstrap-servers}") String bootstrapServers) {

        ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(new DefaultKafkaConsumerFactory<>(
                baseProps(bootstrapServers, "latest"),
                new StringDeserializer(), resultDeserializer()));
        return factory;
    }

    /**
     * Stats aggregation. {@code earliest} is the opposite choice and for the opposite reason: this
     * consumer owns durable derived state, so on first deployment it must read the topic from the
     * beginning to backfill rather than silently starting from empty.
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent>
            statsListenerContainerFactory(
                    @Value("${spring.kafka.bootstrap-servers}") String bootstrapServers) {

        ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(new DefaultKafkaConsumerFactory<>(
                baseProps(bootstrapServers, "earliest"),
                new StringDeserializer(), resultDeserializer()));
        return factory;
    }

    /**
     * Streak Days. Same {@code earliest} reset as stats, for the same backfill-by-replay reason, but
     * a different failure policy: a Streak Day is stored state, so a dropped event is a day the
     * user loses for good. Retry with exponential back-off (about a minute in total) to ride out a
     * database blip, and only then skip, logging the full event so it can be replayed by hand.
     * The partition is blocked while retrying, which is acceptable at ~0.65 results/sec.
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent>
            streakListenerContainerFactory(
                    @Value("${spring.kafka.bootstrap-servers}") String bootstrapServers) {

        ConcurrentKafkaListenerContainerFactory<String, SubmissionResultEvent> factory =
                new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(new DefaultKafkaConsumerFactory<>(
                baseProps(bootstrapServers, "earliest"),
                new StringDeserializer(), resultDeserializer()));

        ExponentialBackOffWithMaxRetries backOff = new ExponentialBackOffWithMaxRetries(6);
        backOff.setInitialInterval(1_000L);
        backOff.setMultiplier(2.0);
        backOff.setMaxInterval(30_000L);
        factory.setCommonErrorHandler(new DefaultErrorHandler(
                (record, ex) -> log.error("Streak Day lost after retries; replay manually: {}",
                        record.value(), ex),
                backOff));
        return factory;
    }
}
