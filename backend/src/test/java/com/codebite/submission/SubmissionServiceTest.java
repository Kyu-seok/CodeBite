package com.codebite.submission;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.dto.SubmissionResponse;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.submission.service.SubmissionService;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionServiceTest {

    @Mock private SubmissionRepository submissionRepository;
    @Mock private SubmissionResultRepository submissionResultRepository;
    @Mock private ProblemRepository problemRepository;
    @Mock private TestCaseRepository testCaseRepository;
    @Mock private UserRepository userRepository;
    @Mock private JudgeService judgeService;

    private SubmissionService submissionService;

    private Problem problem;
    private User user;

    @BeforeEach
    void setUp() {
        submissionService = new SubmissionService(
                submissionRepository, submissionResultRepository,
                problemRepository, testCaseRepository, userRepository, judgeService);

        problem = new Problem();
        problem.setId(1L);
        problem.setTitle("Two Sum");
        problem.setSlug("two-sum");
        problem.setDescription("Description");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem.setDriverCode(Map.of("java", "template {USER_CODE}", "python", "template {USER_CODE}"));

        user = new User();
        user.setId(1L);
        user.setUsername("testuser");
        user.setEmail("test@test.com");
        user.setPasswordHash("hash");
    }

    private TestCase buildTestCase(Long id, boolean sample, int orderIndex) {
        TestCase tc = new TestCase();
        tc.setId(id);
        tc.setProblem(problem);
        tc.setInput("[2,7,11,15]\n9");
        tc.setExpectedOutput("[0,1]");
        tc.setSample(sample);
        tc.setOrderIndex(orderIndex);
        return tc;
    }

    private JudgeResponse acceptedResponse() {
        return new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), "[0,1]\n", null, null, "0.012", 9400);
    }

    private JudgeResponse wrongAnswerResponse() {
        return new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), "[1,2]\n", null, null, "0.010", 9200);
    }

    private JudgeResponse compilationErrorResponse() {
        return new JudgeResponse(
                null, new JudgeResponse.Status(6, "Compilation Error"), null, null, "syntax error", null, null);
    }

    private JudgeResponse runtimeErrorResponse() {
        return new JudgeResponse(
                null, new JudgeResponse.Status(11, "Runtime Error (NZEC)"), null, "Exception", null, "0.005", 8000);
    }

    private void setupCommonMocks() {
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(judgeService.isLanguageSupported("java")).thenReturn(true);
        when(judgeService.mapLanguageToId("java")).thenReturn(62);
        when(judgeService.buildSourceCode(anyString(), anyString())).thenReturn("full source");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(submissionRepository.save(any())).thenAnswer(inv -> {
            Submission s = inv.getArgument(0);
            if (s.getId() == null) s.setId(1L);
            return s;
        });
    }

    // --- submit: all accepted ---

    @Test
    void submit_allAccepted() {
        setupCommonMocks();
        TestCase tc1 = buildTestCase(1L, true, 1);
        TestCase tc2 = buildTestCase(2L, false, 2);
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(tc1, tc2));
        when(judgeService.execute(anyString(), anyInt(), anyString())).thenReturn(acceptedResponse());
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.ACCEPTED);

        SubmissionResponse response = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertEquals(SubmissionStatus.ACCEPTED, response.status());
        assertEquals(2, response.results().size());
        assertEquals("two-sum", response.problemSlug());
    }

    // --- submit: wrong answer with early exit ---

    @Test
    void submit_wrongAnswer_earlyExit() {
        setupCommonMocks();
        TestCase tc1 = buildTestCase(1L, true, 1);
        TestCase tc2 = buildTestCase(2L, false, 2);
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(tc1, tc2));
        when(judgeService.execute(anyString(), anyInt(), anyString())).thenReturn(wrongAnswerResponse());
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.WRONG_ANSWER);

        SubmissionResponse response = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertEquals(SubmissionStatus.WRONG_ANSWER, response.status());
        assertEquals(1, response.results().size()); // early exit after first failure
    }

    // --- submit: compilation error ---

    @Test
    void submit_compilationError() {
        setupCommonMocks();
        TestCase tc1 = buildTestCase(1L, true, 1);
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(tc1));
        when(judgeService.execute(anyString(), anyInt(), anyString())).thenReturn(compilationErrorResponse());
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.COMPILATION_ERROR);

        SubmissionResponse response = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertEquals(SubmissionStatus.COMPILATION_ERROR, response.status());
    }

    // --- submit: runtime error ---

    @Test
    void submit_runtimeError() {
        setupCommonMocks();
        TestCase tc1 = buildTestCase(1L, true, 1);
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(tc1));
        when(judgeService.execute(anyString(), anyInt(), anyString())).thenReturn(runtimeErrorResponse());
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.RUNTIME_ERROR);

        SubmissionResponse response = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertEquals(SubmissionStatus.RUNTIME_ERROR, response.status());
    }

    // --- submit: problem not found ---

    @Test
    void submit_problemNotFound() {
        when(problemRepository.findBySlug("missing")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> submissionService.submit("missing", new SubmitRequest("java", "code"), 1L));
    }

    // --- submit: unsupported language ---

    @Test
    void submit_unsupportedLanguage() {
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(judgeService.isLanguageSupported("rust")).thenReturn(false);

        assertThrows(IllegalArgumentException.class,
                () -> submissionService.submit("two-sum", new SubmitRequest("rust", "code"), 1L));
    }

    // --- getSubmission: ownership ---

    @Test
    void getSubmission_ownerCanView() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setUser(user);
        submission.setProblem(problem);
        submission.setLanguage("java");
        submission.setSourceCode("code");
        submission.setStatus(SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(submissionResultRepository.findBySubmissionIdOrderById(1L)).thenReturn(List.of());
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of());

        SubmissionResponse response = submissionService.getSubmission(1L, 1L);
        assertNotNull(response);
        assertEquals(1L, response.id());
    }

    @Test
    void getSubmission_nonOwnerGetsDenied() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setUser(user);
        submission.setProblem(problem);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        assertThrows(ResourceNotFoundException.class,
                () -> submissionService.getSubmission(1L, 999L));
    }

    @Test
    void getSubmission_notFound() {
        when(submissionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> submissionService.getSubmission(99L, 1L));
    }

    // --- sample vs hidden test case visibility ---

    @Test
    void submit_sampleTestCase_showsInputAndExpected() {
        setupCommonMocks();
        TestCase sampleTc = buildTestCase(1L, true, 1);
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(sampleTc));
        when(judgeService.execute(anyString(), anyInt(), anyString())).thenReturn(acceptedResponse());
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.ACCEPTED);

        SubmissionResponse response = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertNotNull(response.results().get(0).input());
        assertNotNull(response.results().get(0).expectedOutput());
    }

    @Test
    void submit_hiddenTestCase_hidesInputAndExpected() {
        setupCommonMocks();
        TestCase hiddenTc = buildTestCase(2L, false, 1);
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(hiddenTc));
        when(judgeService.execute(anyString(), anyInt(), anyString())).thenReturn(acceptedResponse());
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.ACCEPTED);

        SubmissionResponse response = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertNull(response.results().get(0).input());
        assertNull(response.results().get(0).expectedOutput());
    }

    // --- output trimming ---

    @Test
    void submit_outputIsTrimmed() {
        setupCommonMocks();
        TestCase tc = buildTestCase(1L, true, 1);
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(tc));
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), "  [0,1]  \n", null, null, "0.01", 9400);
        when(judgeService.execute(anyString(), anyInt(), anyString())).thenReturn(response);
        when(judgeService.mapStatus(any(), anyString())).thenReturn(SubmissionStatus.ACCEPTED);

        SubmissionResponse result = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertEquals("[0,1]", result.results().get(0).actualOutput());
    }
}
