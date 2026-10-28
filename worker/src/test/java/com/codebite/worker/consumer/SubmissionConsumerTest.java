package com.codebite.worker.consumer;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Grader;
import com.codebite.judge.grader.Program;
import com.codebite.judge.grader.TestInput;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.submission.event.SubmissionResultEvent;
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
    @Mock private SubmissionResultRepository submissionResultRepository;
    @Mock private SubmissionRepository submissionRepository;
    @Mock private ApplicationEventPublisher eventPublisher;

    private SubmissionConsumer consumer;

    @BeforeEach
    void setUp() {
        SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();
        consumer = new SubmissionConsumer(
                grader, testCaseRepository,
                submissionResultRepository, submissionRepository,
                new SubmissionMetrics(meterRegistry), meterRegistry, eventPublisher);
    }

    /** The result event carries the owner's id, so submissions under test need one. */
    private static User owner() {
        User user = new User();
        user.setId(77L);
        return user;
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

    private static CaseVerdict wrongAnswer(String stdout) {
        return new CaseVerdict(SubmissionStatus.WRONG_ANSWER, true, stdout, null, null, 10, 9000);
    }

    @Test
    void consume_acceptedSubmission() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);
        submission.setUser(owner());

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenReturn(List.of(testCase(1L, "1 2", "3")));
        when(grader.grade(any(Program.class), anyList())).thenReturn(Verdict.of(List.of(accepted("3"))));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        assertEquals(SubmissionStatus.ACCEPTED, submission.getStatus());
        verify(submissionResultRepository).saveAll(any());
        verify(submissionRepository).save(submission);
    }

    @Test
    void consume_gradesTheEventsProgramAgainstEveryTestCaseInOrder() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);
        submission.setUser(owner());

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
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);
        submission.setUser(owner());

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenReturn(List.of(testCase(1L, "1 2", "3")));
        when(grader.grade(any(Program.class), anyList())).thenReturn(Verdict.of(List.of(accepted("3"))));

        // The admin listener exists to isolate the queue, not to grade differently.
        consumer.consumeAdmin(new SubmissionEvent(1L, "source", 62, 10L, true, "java"));

        assertEquals(SubmissionStatus.ACCEPTED, submission.getStatus());
        verify(submissionResultRepository).saveAll(any());
        verify(submissionRepository).save(submission);
    }

    @Test
    void consume_publishesResultEventForFanOut() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);
        submission.setUser(owner());
        submission.setLanguage("java");

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenReturn(List.of(testCase(1L, "1 2", "3")));
        when(grader.grade(any(Program.class), anyList())).thenReturn(Verdict.of(List.of(accepted("3"))));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        ArgumentCaptor<SubmissionResultEvent> published =
                ArgumentCaptor.forClass(SubmissionResultEvent.class);
        verify(eventPublisher).publishEvent(published.capture());

        SubmissionResultEvent event = published.getValue();
        assertEquals(1L, event.submissionId());
        assertEquals(77L, event.userId());
        assertEquals(SubmissionStatus.ACCEPTED, event.status());
        assertEquals(10, event.runtimeMs());
        assertEquals(9000, event.memoryKb());
    }

    @Test
    void consume_skipsAlreadyProcessed() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L, false, "java"));

        verify(grader, never()).grade(any(), anyList());
        verify(submissionResultRepository, never()).saveAll(any());
    }

    @Test
    void consume_persistsOneRowPerCaseVerdictAndTakesTheVerdictsOverall() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);
        submission.setUser(owner());

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

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SubmissionResult>> captor = ArgumentCaptor.forClass(List.class);
        verify(submissionResultRepository).saveAll(captor.capture());
        List<SubmissionResult> rows = captor.getValue();
        assertEquals(2, rows.size());

        SubmissionResult first = rows.get(0);
        assertSame(submission, first.getSubmission());
        assertSame(tc1, first.getTestCase());
        assertEquals(SubmissionStatus.WRONG_ANSWER, first.getStatus());
        assertEquals("wrong", first.getActualOutput());
        assertEquals("warn", first.getStderr());
        assertEquals(12, first.getRuntimeMs());
        assertEquals(4000, first.getMemoryKb());

        SubmissionResult second = rows.get(1);
        assertSame(tc2, second.getTestCase());
        assertEquals(SubmissionStatus.ACCEPTED, second.getStatus());
        assertEquals("7", second.getActualOutput());
    }

    @Test
    void consume_propagatesExceptionSoRetryAndRollbackCanHappen() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);
        submission.setUser(owner());

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenThrow(new RuntimeException("DB error"));

        SubmissionEvent event = new SubmissionEvent(1L, "source", 62, 10L, false, "java");
        assertThrows(RuntimeException.class, () -> consumer.consume(event));

        // The consumer must not settle the status itself — the transaction rolls back and the
        // submission stays PENDING so DefaultErrorHandler can retry it.
        assertEquals(SubmissionStatus.PENDING, submission.getStatus());
        verify(submissionRepository, never()).save(any());
        verify(submissionResultRepository, never()).saveAll(any());
    }
}
