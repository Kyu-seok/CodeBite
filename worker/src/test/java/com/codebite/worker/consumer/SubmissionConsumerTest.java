package com.codebite.worker.consumer;

import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionConsumerTest {

    @Mock private JudgeService judgeService;
    @Mock private TestCaseRepository testCaseRepository;
    @Mock private SubmissionResultRepository submissionResultRepository;
    @Mock private SubmissionRepository submissionRepository;

    private SubmissionConsumer consumer;

    @BeforeEach
    void setUp() {
        consumer = new SubmissionConsumer(
                judgeService, testCaseRepository,
                submissionResultRepository, submissionRepository);
    }

    @Test
    void consume_acceptedSubmission() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);

        TestCase testCase = new TestCase();
        testCase.setId(1L);
        testCase.setInput("1 2");
        testCase.setExpectedOutput("3");

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L)).thenReturn(List.of(testCase));
        when(judgeService.execute(anyString(), anyInt(), anyString()))
                .thenReturn(new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), "3\n", null, null, "0.01", 9000));
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.ACCEPTED);

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L));

        assertEquals(SubmissionStatus.ACCEPTED, submission.getStatus());
        verify(submissionResultRepository).saveAll(any());
        verify(submissionRepository).save(submission);
    }

    @Test
    void consume_skipsAlreadyProcessed() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L));

        verify(judgeService, never()).execute(anyString(), anyInt(), anyString());
        verify(submissionResultRepository, never()).saveAll(any());
    }

    @Test
    void consume_wrongAnswer_stopsEarly() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);

        TestCase tc1 = new TestCase();
        tc1.setId(1L);
        tc1.setInput("1 2");
        tc1.setExpectedOutput("3");

        TestCase tc2 = new TestCase();
        tc2.setId(2L);
        tc2.setInput("3 4");
        tc2.setExpectedOutput("7");

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L)).thenReturn(List.of(tc1, tc2));
        when(judgeService.execute(anyString(), anyInt(), anyString()))
                .thenReturn(new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), "wrong\n", null, null, "0.01", 9000));
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.WRONG_ANSWER);

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L));

        assertEquals(SubmissionStatus.WRONG_ANSWER, submission.getStatus());
        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SubmissionResult>> captor = ArgumentCaptor.forClass(List.class);
        verify(submissionResultRepository).saveAll(captor.capture());
        assertEquals(1, captor.getValue().size());
    }

    @Test
    void consume_exceptionSetsInternalError() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setStatus(SubmissionStatus.PENDING);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(10L))
                .thenThrow(new RuntimeException("DB error"));

        consumer.consume(new SubmissionEvent(1L, "source", 62, 10L));

        assertEquals(SubmissionStatus.INTERNAL_ERROR, submission.getStatus());
        verify(submissionRepository).save(submission);
    }
}
