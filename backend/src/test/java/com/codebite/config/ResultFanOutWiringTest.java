package com.codebite.config;

import com.codebite.github.service.SolutionCommitService;
import com.codebite.stats.service.StatsService;
import com.codebite.streak.service.StreakService;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.sse.SubmissionEmitterRegistry;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.kafka.config.KafkaListenerEndpointRegistry;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.listener.MessageListenerContainer;
import org.springframework.kafka.test.EmbeddedKafkaBroker;
import org.springframework.kafka.test.context.EmbeddedKafka;
import org.springframework.kafka.test.utils.ContainerTestUtils;
import org.springframework.kafka.test.utils.KafkaTestUtils;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.function.Function;
import java.util.stream.Collectors;

import static java.util.concurrent.TimeUnit.SECONDS;
import static org.assertj.core.api.Assertions.assertThat;
import static org.awaitility.Awaitility.await;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.timeout;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

/**
 * The {@code submission-results} fan-out as wired, against an in-JVM broker: which consumer groups
 * exist, where each starts reading, how the Streak listener retries, and that a Verdict carrying a
 * field this backend does not know still reaches every listener.
 *
 * <p>Every other backend test runs with Kafka switched off ({@code app.kafka.enabled=false} in
 * {@code application-test.yml}, {@code KafkaAutoConfiguration} excluded). This one turns it back on
 * for itself only: the inlined properties override the profile, so the real producers, the five
 * container factories and the listeners all start, pointed at the embedded broker. The four
 * downstream services are mocks, so nothing here touches the database.
 *
 * <p>The group ids asserted below are also the proof that {@code app.kafka.group-prefix} (set only by
 * {@code scripts/dev-branch-servers.sh}) leaves production's four shared groups unprefixed by default.
 */
@SpringBootTest(properties = {
        "app.kafka.enabled=true",
        // Keep only Redis excluded: KafkaAutoConfiguration carries @EnableKafka and the
        // KafkaTemplate the producers need.
        "spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration"
})
@ActiveProfiles("test")
@EmbeddedKafka(kraft = true, partitions = 3, topics = ResultFanOutWiringTest.TOPIC,
        bootstrapServersProperty = "spring.kafka.bootstrap-servers")
@DirtiesContext
class ResultFanOutWiringTest {

    static final String TOPIC = "submission-results";

    private static final ObjectMapper JSON = new ObjectMapper();
    private static final Duration GENEROUS = Duration.ofSeconds(30);

    @Autowired private KafkaListenerEndpointRegistry registry;
    @Autowired private EmbeddedKafkaBroker broker;

    @MockBean private StreakService streakService;
    @MockBean private StatsService statsService;
    @MockBean private SolutionCommitService solutionCommitService;
    @MockBean private SubmissionEmitterRegistry emitterRegistry;

    private static KafkaProducer<String, String> producer;

    @BeforeEach
    void waitUntilEveryResultListenerHoldsItsPartitions() {
        // The latest-reset groups (SSE, Solution Commits) only see records sent after they joined.
        for (MessageListenerContainer container : resultContainers().values()) {
            ContainerTestUtils.waitForAssignment(container, 3);
        }
        if (producer == null) {
            producer = new KafkaProducer<>(KafkaTestUtils.producerProps(broker),
                    new StringSerializer(), new StringSerializer());
        }
    }

    @AfterAll
    static void closeProducer() {
        if (producer != null) {
            producer.close();
            producer = null;
        }
    }

    @Test
    void eachListenerHasItsOwnGroupAndStartingPoint() {
        Map<String, MessageListenerContainer> byGroup = resultContainers();

        // Shared groups: each Verdict applied once by the group, replayed from the start on first
        // deployment (stats, Streak Days) or never (Solution Commits, whose history is the Import's).
        assertThat(byGroup).containsKeys("codebite-streaks", "codebite-stats", "codebite-solution-commits");
        assertThat(autoOffsetReset(byGroup.get("codebite-streaks"))).isEqualTo("earliest");
        assertThat(autoOffsetReset(byGroup.get("codebite-stats"))).isEqualTo("earliest");
        assertThat(autoOffsetReset(byGroup.get("codebite-solution-commits"))).isEqualTo("latest");

        // Broadcast: SSE is a single-member group per replica, named at random, reading live only.
        List<String> sseGroups = byGroup.keySet().stream().filter(g -> g.startsWith("codebite-sse-")).toList();
        assertThat(sseGroups).hasSize(1);
        assertThat(sseGroups.get(0)).hasSizeGreaterThan(40);
        assertThat(autoOffsetReset(byGroup.get(sseGroups.get(0)))).isEqualTo("latest");

        assertThat(byGroup).hasSize(4);
    }

    @Test
    void importRequestsHaveTheirOwnGroupReadFromTheStart() {
        MessageListenerContainer imports = containersByGroup("github-imports").get("codebite-github-imports");

        assertThat(imports).isNotNull();
        assertThat(autoOffsetReset(imports)).isEqualTo("earliest");
    }

    @Test
    void oneAcceptedVerdictReachesAllFourListeners() {
        send(event(11L, 7L, 42L, SubmissionStatus.ACCEPTED, false));

        verify(streakService, timeout(GENEROUS.toMillis())).recordSolve(7L, 11L);
        verify(statsService, timeout(GENEROUS.toMillis())).recompute(7L, 42L);
        verify(solutionCommitService, timeout(GENEROUS.toMillis())).commitAccepted(7L, 11L);
        verify(emitterRegistry, timeout(GENEROUS.toMillis())).completeWith(eq(11L), any());
    }

    @Test
    void streakListenerRetriesWithBackOffUntilTheDatabaseIsBack() {
        List<Long> attemptTimes = new CopyOnWriteArrayList<>();
        doAnswer(inv -> {
            attemptTimes.add(System.nanoTime());
            if (attemptTimes.size() < 3) {
                throw new DataAccessResourceFailureException("blip");
            }
            return null;
        }).when(streakService).recordSolve(7L, 21L);

        send(event(21L, 7L, 42L, SubmissionStatus.ACCEPTED, false));

        // Initial interval 1 s, doubling: attempts at t, t+1 s, t+3 s. Lower bounds only, so a
        // loaded machine cannot fail this; a disappearing back-off would.
        await().atMost(GENEROUS).untilAsserted(() ->
                verify(streakService, times(3)).recordSolve(7L, 21L));
        assertThat(Duration.ofNanos(attemptTimes.get(1) - attemptTimes.get(0)))
                .isGreaterThanOrEqualTo(Duration.ofMillis(900));
        assertThat(Duration.ofNanos(attemptTimes.get(2) - attemptTimes.get(1)))
                .isGreaterThanOrEqualTo(Duration.ofMillis(1800));

        // The group is not wedged: the next Verdict on the same partition key is processed.
        doNothing().when(streakService).recordSolve(7L, 22L);
        send(event(22L, 7L, 42L, SubmissionStatus.ACCEPTED, false));
        verify(streakService, timeout(GENEROUS.toMillis())).recordSolve(7L, 22L);
    }

    @Test
    void verdictWithAFieldThisBackendDoesNotKnowIsStillDelivered() {
        // A newer worker (or an older backend after a rollback) may disagree on the record's shape;
        // an extra field must never wedge a partition or drop a Verdict.
        String json = """
                {"submissionId":31,"userId":7,"problemId":42,"status":"ACCEPTED","runtimeMs":10,
                 "memoryKb":100,"language":"python","adminSubmission":false,"future":1}
                """;
        send("31", json);

        verify(streakService, timeout(GENEROUS.toMillis())).recordSolve(7L, 31L);
        verify(statsService, timeout(GENEROUS.toMillis())).recompute(7L, 42L);
    }

    @Test
    void adminVerdictsStillReachTheListenersThatDecideForThemselves() {
        // The scope filters live in the listeners, not the wiring; this pins where the admin rule
        // sits so a wiring change cannot quietly move it.
        send(event(41L, 9L, 99L, SubmissionStatus.ACCEPTED, true));

        verify(solutionCommitService, timeout(GENEROUS.toMillis())).commitAccepted(9L, 41L);
        verify(emitterRegistry, timeout(GENEROUS.toMillis())).completeWith(eq(41L), any());
        verify(streakService, never()).recordSolve(9L, 41L);
        verify(statsService, never()).recompute(9L, 99L);
    }

    // --- helpers ---

    private Map<String, MessageListenerContainer> resultContainers() {
        return containersByGroup(TOPIC);
    }

    /** The listener containers subscribed to {@code topic}, keyed by consumer group. */
    private Map<String, MessageListenerContainer> containersByGroup(String topic) {
        return registry.getListenerContainers().stream()
                .filter(c -> List.of(c.getContainerProperties().getTopics()).contains(topic))
                .collect(Collectors.toMap(MessageListenerContainer::getGroupId, Function.identity()));
    }

    /** The {@code auto.offset.reset} the container's consumers were built with. */
    private static String autoOffsetReset(MessageListenerContainer container) {
        ConsumerFactory<?, ?> factory =
                (ConsumerFactory<?, ?>) ReflectionTestUtils.getField(container, "consumerFactory");
        return String.valueOf(factory.getConfigurationProperties().get(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG));
    }

    private static SubmissionResultEvent event(long submissionId, long userId, long problemId,
                                               SubmissionStatus status, boolean admin) {
        return new SubmissionResultEvent(submissionId, userId, problemId, status, 10, 100, "python", admin);
    }

    /** Sends the event as the worker's JsonSerializer would: plain JSON, keyed by submission id. */
    private static void send(SubmissionResultEvent event) {
        try {
            send(String.valueOf(event.submissionId()), JSON.writeValueAsString(event));
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    private static void send(String key, String json) {
        try {
            producer.send(new ProducerRecord<>(TOPIC, key, json)).get(30, SECONDS);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
