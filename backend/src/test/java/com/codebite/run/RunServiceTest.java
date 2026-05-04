package com.codebite.run;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.parser.JudgeErrorParsers;
import com.codebite.judge.parser.UserCodeLineMapper;
import com.codebite.judge.service.DriverCodeLoader;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.run.dto.CustomTestCaseInput;
import com.codebite.run.dto.RunRequest;
import com.codebite.run.dto.RunResponse;
import com.codebite.run.service.RunService;
import com.codebite.submission.entity.SubmissionStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RunServiceTest {

    @Mock private ProblemRepository problemRepository;
    @Mock private TestCaseRepository testCaseRepository;
    @Mock private JudgeService judgeService;
    @Mock private DriverCodeLoader driverCodeLoader;

    private RunService runService;
    private Problem problem;

    @BeforeEach
    void setUp() {
        runService = new RunService(
                problemRepository, testCaseRepository, judgeService, driverCodeLoader,
                new JudgeErrorParsers(), new UserCodeLineMapper());

        problem = new Problem();
        problem.setId(1L);
        problem.setTitle("Two Sum");
        problem.setSlug("pair-sum");
        problem.setDescription("Description");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
    }

    private TestCase sampleTestCase(String input, String expectedOutput, int orderIndex) {
        TestCase tc = new TestCase();
        tc.setId((long) orderIndex);
        tc.setProblem(problem);
        tc.setInput(input);
        tc.setExpectedOutput(expectedOutput);
        tc.setSample(true);
        tc.setOrderIndex(orderIndex);
        return tc;
    }

    private JudgeResponse acceptedResponse(String stdout) {
        return new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), stdout, null, null, "0.01", 1024);
    }

    private JudgeResponse wrongAnswerResponse(String stdout) {
        return new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), stdout, null, null, "0.01", 1024);
    }

    private JudgeResponse compilationErrorResponse(String compileOutput) {
        return new JudgeResponse(null, new JudgeResponse.Status(6, "Compilation Error"), null, null, compileOutput, null, null);
    }

    private void setupCommonMocks() {
        when(problemRepository.findBySlug("pair-sum")).thenReturn(Optional.of(problem));
        when(judgeService.isLanguageSupported("java")).thenReturn(true);
        when(driverCodeLoader.getDriverCode("pair-sum", "java")).thenReturn("template {USER_CODE}");
        when(judgeService.buildSourceCode(anyString(), anyString())).thenReturn("full source");
        when(judgeService.mapLanguageToId("java")).thenReturn(62);
    }

    @Test
    void run_allSampleTestsPass_returnsAccepted() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("[2,7,11,15]\n9", "0 1", 0);
        TestCase tc2 = sampleTestCase("[3,2,4]\n6", "1 2", 1);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1, tc2));
        when(judgeService.execute(anyString(), eq(62), eq("[2,7,11,15]\n9")))
                .thenReturn(acceptedResponse("0 1\n"));
        when(judgeService.execute(anyString(), eq(62), eq("[3,2,4]\n6")))
                .thenReturn(acceptedResponse("1 2\n"));
        when(judgeService.mapStatus(any(JudgeResponse.class), anyString()))
                .thenReturn(SubmissionStatus.ACCEPTED);

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", null));

        assertEquals(SubmissionStatus.ACCEPTED, response.overallStatus());
        assertEquals(2, response.results().size());
        assertEquals("0 1", response.results().get(0).actualOutput());
        assertEquals("1 2", response.results().get(1).actualOutput());
    }

    @Test
    void run_firstTestFails_shortCircuits() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("[2,7,11,15]\n9", "0 1", 0);
        TestCase tc2 = sampleTestCase("[3,2,4]\n6", "1 2", 1);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1, tc2));
        when(judgeService.execute(anyString(), eq(62), eq("[2,7,11,15]\n9")))
                .thenReturn(wrongAnswerResponse("wrong\n"));
        when(judgeService.mapStatus(any(JudgeResponse.class), anyString()))
                .thenReturn(SubmissionStatus.WRONG_ANSWER);

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", null));

        assertEquals(SubmissionStatus.WRONG_ANSWER, response.overallStatus());
        assertEquals(1, response.results().size());
        verify(judgeService, never()).execute(anyString(), eq(62), eq("[3,2,4]\n6"));
    }

    @Test
    void run_compilationError_returnsCompilationError() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("[2,7,11,15]\n9", "0 1", 0);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1));
        when(judgeService.execute(anyString(), eq(62), eq("[2,7,11,15]\n9")))
                .thenReturn(compilationErrorResponse("error: ';' expected"));
        when(judgeService.mapStatus(any(JudgeResponse.class), anyString()))
                .thenReturn(SubmissionStatus.COMPILATION_ERROR);

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", null));

        assertEquals(SubmissionStatus.COMPILATION_ERROR, response.overallStatus());
        assertEquals(1, response.results().size());
        assertEquals("error: ';' expected", response.results().get(0).compileOutput());
    }

    @Test
    void run_problemNotFound_throwsResourceNotFoundException() {
        when(problemRepository.findBySlug("missing")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> runService.run("missing", new RunRequest("java", "code", null)));
    }

    @Test
    void run_unsupportedLanguage_throwsIllegalArgumentException() {
        when(problemRepository.findBySlug("pair-sum")).thenReturn(Optional.of(problem));
        when(judgeService.isLanguageSupported("rust")).thenReturn(false);

        assertThrows(com.codebite.common.exception.UnsupportedValueException.class,
                () -> runService.run("pair-sum", new RunRequest("rust", "code", null)));
    }

    // ── Custom test case tests ────────────────────────────────────────────

    private JudgeResponse runtimeErrorResponse(String stderr) {
        return new JudgeResponse(null, new JudgeResponse.Status(11, "Runtime Error (NZEC)"),
                null, stderr, null, null, null);
    }

    @Test
    void run_customTests_runAllAfterSamples_judgedTrue() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("[2,7,11,15]\n9", "0 1", 0);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1));
        when(judgeService.execute(anyString(), eq(62), eq("[2,7,11,15]\n9")))
                .thenReturn(acceptedResponse("0 1\n"));
        when(judgeService.execute(anyString(), eq(62), eq("custom-input-1")))
                .thenReturn(acceptedResponse("custom-out-1\n"));
        when(judgeService.execute(anyString(), eq(62), eq("custom-input-2")))
                .thenReturn(acceptedResponse("custom-out-2\n"));
        when(judgeService.mapStatus(any(JudgeResponse.class), anyString()))
                .thenReturn(SubmissionStatus.ACCEPTED);

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("custom-input-1", "custom-out-1"),
                new CustomTestCaseInput("custom-input-2", "custom-out-2")
        )));

        assertEquals(SubmissionStatus.ACCEPTED, response.overallStatus());
        assertEquals(3, response.results().size());
        assertFalse(response.results().get(0).isCustom());
        assertTrue(response.results().get(0).judged());
        assertTrue(response.results().get(1).isCustom());
        assertTrue(response.results().get(1).judged());
        assertTrue(response.results().get(2).isCustom());
        assertTrue(response.results().get(2).judged());
    }

    @Test
    void run_customTestNoExpected_judgedFalse_expectedNull() {
        setupCommonMocks();
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of());
        when(judgeService.execute(anyString(), eq(62), eq("hello")))
                .thenReturn(acceptedResponse("hi\n"));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("hello", null)
        )));

        assertEquals(1, response.results().size());
        com.codebite.run.dto.RunTestCaseResult r = response.results().get(0);
        assertTrue(r.isCustom());
        assertFalse(r.judged());
        assertNull(r.expectedOutput());
        assertEquals(SubmissionStatus.ACCEPTED, r.status());
        assertEquals("hi", r.actualOutput());
        assertEquals(SubmissionStatus.ACCEPTED, response.overallStatus());
    }

    @Test
    void run_customTestNoExpected_blankExpectedTreatedAsNull() {
        setupCommonMocks();
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of());
        when(judgeService.execute(anyString(), eq(62), eq("x")))
                .thenReturn(acceptedResponse("y\n"));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("x", "  ")
        )));

        com.codebite.run.dto.RunTestCaseResult r = response.results().get(0);
        assertFalse(r.judged());
        assertNull(r.expectedOutput());
    }

    @Test
    void run_customTestRuntimeError_judgedTrue_evenWithoutExpected() {
        setupCommonMocks();
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of());
        when(judgeService.execute(anyString(), eq(62), eq("crash")))
                .thenReturn(runtimeErrorResponse("NZEC"));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("crash", null)
        )));

        com.codebite.run.dto.RunTestCaseResult r = response.results().get(0);
        assertTrue(r.judged());
        assertEquals(SubmissionStatus.RUNTIME_ERROR, r.status());
        assertEquals(SubmissionStatus.RUNTIME_ERROR, response.overallStatus());
    }

    @Test
    void run_customTestsDoNotShortCircuit_onWrongAnswer() {
        setupCommonMocks();
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of());
        when(judgeService.execute(anyString(), eq(62), eq("a")))
                .thenReturn(acceptedResponse("X\n"));
        when(judgeService.execute(anyString(), eq(62), eq("b")))
                .thenReturn(acceptedResponse("Y\n"));
        when(judgeService.mapStatus(any(JudgeResponse.class), eq("X")))
                .thenReturn(SubmissionStatus.WRONG_ANSWER);
        when(judgeService.mapStatus(any(JudgeResponse.class), eq("Y")))
                .thenReturn(SubmissionStatus.ACCEPTED);

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("a", "X"),
                new CustomTestCaseInput("b", "Y")
        )));

        assertEquals(2, response.results().size());
        assertEquals(SubmissionStatus.WRONG_ANSWER, response.results().get(0).status());
        assertEquals(SubmissionStatus.ACCEPTED, response.results().get(1).status());
        verify(judgeService).execute(anyString(), eq(62), eq("a"));
        verify(judgeService).execute(anyString(), eq(62), eq("b"));
    }

    @Test
    void run_samplesShortCircuit_customsNotRun() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("sample-in", "sample-out", 0);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1));
        when(judgeService.execute(anyString(), eq(62), eq("sample-in")))
                .thenReturn(wrongAnswerResponse("nope\n"));
        when(judgeService.mapStatus(any(JudgeResponse.class), eq("sample-out")))
                .thenReturn(SubmissionStatus.WRONG_ANSWER);

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("custom-in", "custom-out")
        )));

        assertEquals(SubmissionStatus.WRONG_ANSWER, response.overallStatus());
        assertEquals(1, response.results().size());
        assertFalse(response.results().get(0).isCustom());
        verify(judgeService, never()).execute(anyString(), eq(62), eq("custom-in"));
    }

    @Test
    void run_samplesPassCustomFails_overallReflectsCustomFailure() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("sample-in", "sample-out", 0);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1));
        when(judgeService.execute(anyString(), eq(62), eq("sample-in")))
                .thenReturn(acceptedResponse("sample-out\n"));
        when(judgeService.execute(anyString(), eq(62), eq("custom-in")))
                .thenReturn(acceptedResponse("wrong\n"));
        when(judgeService.mapStatus(any(JudgeResponse.class), eq("sample-out")))
                .thenReturn(SubmissionStatus.ACCEPTED);
        when(judgeService.mapStatus(any(JudgeResponse.class), eq("custom-out")))
                .thenReturn(SubmissionStatus.WRONG_ANSWER);

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("custom-in", "custom-out")
        )));

        assertEquals(SubmissionStatus.WRONG_ANSWER, response.overallStatus());
        assertEquals(2, response.results().size());
    }

    @Test
    void run_unjudgedCustomDoesNotPoisonOverall() {
        setupCommonMocks();
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of());
        when(judgeService.execute(anyString(), eq(62), eq("ping")))
                .thenReturn(acceptedResponse("pong\n"));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("ping", null)
        )));

        assertEquals(SubmissionStatus.ACCEPTED, response.overallStatus());
        assertFalse(response.results().get(0).judged());
    }
}
