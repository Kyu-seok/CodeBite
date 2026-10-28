package com.codebite.worker.consumer;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Grader;
import com.codebite.judge.grader.Program;
import com.codebite.judge.grader.TestInput;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionConsumerTest {

    @Mock private Grader grader;
    @Mock private TestCaseRepository testCaseRepository;
    @Mock private SubmissionRepository submissionRepository;
    @Mock private ApplicationEventPublisher eventPublisher;

    private SubmissionConsumer consumer;

    @BeforeEach
    void setUp() {
        SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();
        consumer = new SubmissionConsumer(
                grader, testCaseRepository, submissionRepository,
                new SubmissionMetrics(meterRegistry), meterRegistry, eventPublisher);
    }

    /** The result event carries the owner's and problem's ids, so submissions under test need them. */
    private static Submission pendingSubmission() {
        User user = new User();
        user.setId(77L);
        user.setRole(Role.USER);
        Problem problem = new Problem();
        problem.setId(10L);

        Submission submission = Submission.pending(user, problem, "java", "code");
        submission.setId(1L);
        return submission;
    }

    private static TestCase testCase(long id, String input, String expectedOutput) {
        TestCase testCase = new TestCase();
        testCase.setId(id);
        testCase.setInput(input);
        testCase.setExpectedOutput(expectedOutput);
        return testCase;
    }

    private static CaseVerdict accepted(String stdout) {
        return new CaseVerdict(SubmissionStatus.ACCEPTED, true, stdout, null, null, 10, 9000);
    }

    @Test
    void consume_acceptedSubmission() {
        Submission submission = pendingSubmission();

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenReturn(List.of(testCase(1L, "1 2", "3")));
        when(grader.grade(any(Program.class), anyList())).thenReturn(Verdict.of(List.of(accepted("3"))));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        assertEquals(SubmissionStatus.ACCEPTED, submission.getStatus());
        assertEquals(1, submission.getResults().size());
        verify(submissionRepository).save(submission);
    }

    @Test
    void consume_gradesTheEventsProgramAgainstEveryTestCaseInOrder() {
        Submission submission = pendingSubmission();

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenReturn(List.of(testCase(1L, "1 2", "3"), testCase(2L, "3 4", "7")));
        when(grader.grade(any(Program.class), anyList()))
                .thenReturn(Verdict.of(List.of(accepted("3"), accepted("7"))));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<TestInput>> inputs = ArgumentCaptor.forClass(List.class);
        verify(grader).grade(eq(new Program("source", 62)), inputs.capture());
        assertEquals(List.of(new TestInput("1 2", "3"), new TestInput("3 4", "7")), inputs.getValue());
    }

    @Test
    void consumeAdmin_gradesThroughTheSamePathAsUserSubmissions() {
        Submission submission = pendingSubmission();

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenReturn(List.of(testCase(1L, "1 2", "3")));
        when(grader.grade(any(Program.class), anyList())).thenReturn(Verdict.of(List.of(accepted("3"))));

        // The admin listener exists to isolate the queue, not to grade differently.
        consumer.consumeAdmin(new SubmissionEvent(1L, "source", 62, 10L, true, "java"));

        assertEquals(SubmissionStatus.ACCEPTED, submission.getStatus());
        verify(submissionRepository).save(submission);
    }

    @Test
    void consume_publishesResultEventForFanOut() {
        Submission submission = pendingSubmission();

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenReturn(List.of(testCase(1L, "1 2", "3")));
        when(grader.grade(any(Program.class), anyList())).thenReturn(Verdict.of(List.of(accepted("3"))));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        ArgumentCaptor<SubmissionResultEvent> published =
                ArgumentCaptor.forClass(SubmissionResultEvent.class);
        verify(eventPublisher).publishEvent(published.capture());

        // Every field comes from the row, not the Kafka message.
        assertEquals(new SubmissionResultEvent(
                1L, 77L, 10L, SubmissionStatus.ACCEPTED, 10, 9000, "java", false), published.getValue());
    }

    @Test
    void consume_skipsAlreadyProcessed() {
        Submission submission = pendingSubmission();
        submission.grade(Verdict.empty(), List.of());

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        verify(grader, never()).grade(any(), anyList());
        verify(submissionRepository, never()).save(any());
        verify(eventPublisher, never()).publishEvent(any(Object.class));
    }

    @Test
    void consume_storesTheVerdictOnTheRowWithOneResultPerCase() {
        Submission submission = pendingSubmission();

        TestCase tc1 = testCase(1L, "1 2", "3");
        TestCase tc2 = testCase(2L, "3 4", "7");

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L)).thenReturn(List.of(tc1, tc2));
        // The Grader owns the "first failing case wins" rule; the consumer just stores what it says.
        CaseVerdict failing = new CaseVerdict(
                SubmissionStatus.WRONG_ANSWER, true, "wrong", "warn", null, 12, 4000);
        CaseVerdict passing = new CaseVerdict(
                SubmissionStatus.ACCEPTED, true, "7", null, null, 30, 2000);
        when(grader.grade(any(Program.class), anyList())).thenReturn(Verdict.of(List.of(failing, passing)));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        assertEquals(SubmissionStatus.WRONG_ANSWER, submission.getStatus());
        assertEquals(30, submission.getRuntimeMs());
        assertEquals(4000, submission.getMemoryKb());

        List<SubmissionResult> rows = submission.getResults();
        assertEquals(2, rows.size());
        assertSame(tc1, rows.get(0).getTestCase());
        assertEquals(SubmissionStatus.WRONG_ANSWER, rows.get(0).getStatus());
        assertSame(tc2, rows.get(1).getTestCase());
        assertEquals(SubmissionStatus.ACCEPTED, rows.get(1).getStatus());
    }

    @Test
    void consume_propagatesExceptionSoRetryAndRollbackCanHappen() {
        Submission submission = pendingSubmission();

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenThrow(new RuntimeException("DB error"));

        SubmissionEvent event = new SubmissionEvent(1L, "source", 62, 10L, false, "java");
        assertThrows(RuntimeException.class, () -> consumer.consume(event));

        // The consumer must not settle the status itself — the transaction rolls back and the
        // submission stays PENDING so DefaultErrorHandler can retry it.
        assertTrue(submission.isPending());
        verify(submissionRepository, never()).save(any());
    }
}
