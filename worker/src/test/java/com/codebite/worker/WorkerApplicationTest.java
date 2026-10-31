package com.codebite.worker;

import com.codebite.judge.grader.Grader;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.worker.consumer.SubmissionConsumer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;
import org.springframework.kafka.config.KafkaListenerEndpointRegistry;
import org.springframework.kafka.listener.MessageListenerContainer;
import org.springframework.kafka.test.context.EmbeddedKafka;
import org.springframework.test.annotation.DirtiesContext;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * The worker's context as it starts in production, on H2 and an in-JVM broker: it grades with the
 * Grader, and never builds ProblemAssets, which only the backend needs.
 */
@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.NONE,
        properties = {
                "spring.datasource.url=jdbc:h2:mem:worker;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DEFAULT_NULL_ORDERING=HIGH",
                "spring.datasource.username=sa",
                "spring.datasource.password=",
                "spring.datasource.driver-class-name=org.h2.Driver",
                "spring.flyway.enabled=true",
                "app.judge0.url=http://localhost:2358"
        })
@EmbeddedKafka(kraft = true, partitions = 1,
        topics = {"submission-events", "submission-events-admin", "submission-results"},
        bootstrapServersProperty = "spring.kafka.bootstrap-servers")
@DirtiesContext
class WorkerApplicationTest {

    @Autowired private ApplicationContext context;
    @Autowired private KafkaListenerEndpointRegistry registry;

    @Test
    void startsWithTheGradingBeansAndWithoutProblemAssets() {
        assertThat(context.getBeanNamesForType(SubmissionConsumer.class)).hasSize(1);
        assertThat(context.getBeanNamesForType(Grader.class)).hasSize(1);
        assertThat(context.getBeanNamesForType(ProblemAssets.class)).isEmpty();
    }

    @Test
    void consumesInTheSharedGroupsWhenNoGroupPrefixIsSet() {
        // app.kafka.group-prefix is only for scripts/dev-branch-backend.sh; production's groups stay put.
        assertThat(registry.getListenerContainers()).extracting(MessageListenerContainer::getGroupId)
                .containsExactlyInAnyOrder("codebite-worker", "codebite-worker-admin");
    }
}
