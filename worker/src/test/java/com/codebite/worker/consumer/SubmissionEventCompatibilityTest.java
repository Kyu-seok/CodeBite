package com.codebite.worker.consumer;

import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.test.EmbeddedKafkaBroker;
import org.springframework.kafka.test.context.EmbeddedKafka;
import org.springframework.kafka.test.utils.KafkaTestUtils;
import org.springframework.test.annotation.DirtiesContext;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.UUID;
import java.util.stream.IntStream;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.fail;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

/**
 * A Kafka backlog can outlive a deploy, so the worker meets events from either side of a field
 * change. These go through the worker as it runs (the broker, its JsonDeserializer, the listener,
 * the retries and SubmissionFailureRecoverer) with only Judge0 stood in: an event from before the
 * {@code language} field cannot be graded, so the user's submission ends INTERNAL_ERROR and is
 * announced, while an event with a field newer than the worker grades as usual.
 */
@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.NONE,
        properties = {
                "spring.datasource.url=jdbc:h2:mem:worker-events;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DEFAULT_NULL_ORDERING=HIGH",
                "spring.datasource.username=sa",
                "spring.datasource.password=",
                "spring.datasource.driver-class-name=org.h2.Driver",
                "spring.flyway.enabled=true",
                "app.judge0.poll-interval-ms=10"
        })
@EmbeddedKafka(kraft = true, partitions = 1,
        topics = {"submission-events", "submission-events-admin", "submission-results"},
        bootstrapServersProperty = "spring.kafka.bootstrap-servers")
@DirtiesContext
class SubmissionEventCompatibilityTest {

    private static final String SUBMISSION_EVENT_TYPE = SubmissionEvent.class.getName();

    @Autowired private EmbeddedKafkaBroker broker;
    @Autowired private UserRepository userRepository;
    @Autowired private ProblemRepository problemRepository;
    @Autowired private TestCaseRepository testCaseRepository;
    @Autowired private SubmissionRepository submissionRepository;
    @MockBean private JudgeClient judge0;

    private final ObjectMapper json = new ObjectMapper();

    @Test
    void anEventWithoutTheLanguageFieldEndsInternalErrorWithoutRunningTheCode() throws Exception {
        Problem problem = aProblemWithTestCases();
        answerEveryCaseCorrectly(problem);
        Submission submission = pendingSubmission(problem);

        send("{\"submissionId\":" + submission.getId() + ",\"sourceCode\":\"print(1)\",\"languageId\":71,"
                + "\"problemId\":" + problem.getId() + ",\"adminSubmission\":false}");

        assertThat(announcedStatus(submission)).isEqualTo("INTERNAL_ERROR");
        assertThat(submissionRepository.findById(submission.getId()).orElseThrow().getStatus())
                .isEqualTo(SubmissionStatus.INTERNAL_ERROR);
        verifyNoInteractions(judge0);
    }

    @Test
    void anEventWithAFieldNewerThanTheWorkerIsGraded() throws Exception {
        Problem problem = aProblemWithTestCases();
        answerEveryCaseCorrectly(problem);
        Submission submission = pendingSubmission(problem);

        send("{\"submissionId\":" + submission.getId() + ",\"sourceCode\":\"print(1)\",\"languageId\":71,"
                + "\"problemId\":" + problem.getId() + ",\"adminSubmission\":false,"
                + "\"language\":\"python\",\"somethingNewer\":true}");

        assertThat(announcedStatus(submission)).isEqualTo("ACCEPTED");
        assertThat(submissionRepository.findById(submission.getId()).orElseThrow().getStatus())
                .isEqualTo(SubmissionStatus.ACCEPTED);
    }

    private Problem aProblemWithTestCases() {
        return problemRepository.findAll().stream()
                .filter(p -> !testCaseRepository.findByProblemIdOrderByOrderIndexAsc(p.getId()).isEmpty())
                .findFirst()
                .orElseThrow();
    }

    /** Judge0 stood in: every case's output is the expected one, so a graded submission is ACCEPTED. */
    private void answerEveryCaseCorrectly(Problem problem) {
        List<String> expected = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(problem.getId()).stream()
                .map(TestCase::getExpectedOutput)
                .toList();
        when(judge0.submitBatch(anyList())).thenAnswer(call -> IntStream.range(0, call.<List<?>>getArgument(0).size())
                .mapToObj(i -> new JudgeResponse(String.valueOf(i), null, null, null, null, null, null))
                .toList());
        when(judge0.getBatch(anyList())).thenAnswer(call -> call.<List<String>>getArgument(0).stream()
                .map(token -> new JudgeResponse(token, new JudgeResponse.Status(3, "Accepted"),
                        expected.get(Integer.parseInt(token)), null, null, "0.01", 1024))
                .toList());
    }

    private Submission pendingSubmission(Problem problem) {
        String name = "u" + UUID.randomUUID().toString().substring(0, 8);
        User user = new User();
        user.setUsername(name);
        user.setEmail(name + "@test.com");
        user.setRole(Role.USER);
        return submissionRepository.save(
                Submission.pending(userRepository.save(user), problem, "python", "print(1)"));
    }

    /** As a backend's JsonSerializer writes it: the JSON and the type header the worker reads it by. */
    private void send(String event) throws Exception {
        try (Producer<String, String> producer = new DefaultKafkaProducerFactory<>(
                KafkaTestUtils.producerProps(broker), new StringSerializer(), new StringSerializer())
                .createProducer()) {
            ProducerRecord<String, String> record = new ProducerRecord<>("submission-events", event);
            record.headers().add("__TypeId__", SUBMISSION_EVENT_TYPE.getBytes(StandardCharsets.UTF_8));
            producer.send(record).get();
        }
    }

    /** The status the worker announces on submission-results, which the backend pushes over SSE. */
    private String announcedStatus(Submission submission) throws Exception {
        String key = String.valueOf(submission.getId());
        try (Consumer<String, String> consumer = new DefaultKafkaConsumerFactory<>(
                KafkaTestUtils.consumerProps("results-" + key, "false", broker),
                new StringDeserializer(), new StringDeserializer()).createConsumer()) {
            broker.consumeFromAnEmbeddedTopic(consumer, "submission-results");
            long deadline = System.currentTimeMillis() + 30_000;
            while (System.currentTimeMillis() < deadline) {
                for (ConsumerRecord<String, String> record : consumer.poll(Duration.ofSeconds(1))) {
                    if (key.equals(record.key())) {
                        JsonNode result = json.readTree(record.value());
                        return result.get("status").asText();
                    }
                }
            }
        }
        return fail("no result announced for submission " + key);
    }
}
