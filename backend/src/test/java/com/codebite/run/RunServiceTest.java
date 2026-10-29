package com.codebite.run;

import com.codebite.common.exception.NoDriverException;
import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.common.exception.UnsupportedValueException;
import com.codebite.judge.Language;
import com.codebite.judge.dto.CodeError;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Grader;
import com.codebite.judge.grader.TestInput;
import com.codebite.judge.grader.Verdict;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.judge.program.Program;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.run.dto.CustomTestCaseInput;
import com.codebite.run.dto.RunRequest;
import com.codebite.run.dto.RunResponse;
import com.codebite.run.dto.RunTestCaseResult;
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
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RunServiceTest {

    /** A one-problem fixture whose Java driver puts the user's code on line 3. */
    private static final ProblemAssets ASSETS = new ProblemAssets("classpath:problem-assets/");
    private static final Program PROGRAM = ASSETS.assemble("pair-sum", Language.JAVA, "code");

    @Mock private ProblemRepository problemRepository;
    @Mock private TestCaseRepository testCaseRepository;
    @Mock private Grader grader;

    private RunService runService;
    private Problem problem;

    @BeforeEach
    void setUp() {
        runService = new RunService(problemRepository, testCaseRepository, grader, ASSETS);

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

    private static CaseVerdict accepted(String stdout) {
        return new CaseVerdict(SubmissionStatus.ACCEPTED, true, stdout, null, null, 10, 1024);
    }

    private static CaseVerdict wrongAnswer(String stdout) {
        return new CaseVerdict(SubmissionStatus.WRONG_ANSWER, true, stdout, null, null, 10, 1024);
    }

    private static CaseVerdict unjudged(String stdout) {
        return new CaseVerdict(SubmissionStatus.ACCEPTED, false, stdout, null, null, 10, 1024);
    }

    private static CaseVerdict compilationError(String compileOutput) {
        return new CaseVerdict(SubmissionStatus.COMPILATION_ERROR, true, null, null, compileOutput, null, null);
    }

    private void setupCommonMocks() {
        when(problemRepository.findBySlugOrFormerSlug("pair-sum")).thenReturn(Optional.of(problem));
    }

    @Test
    void run_allSampleTestsPass_returnsAccepted() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("[2,7,11,15]\n9", "0 1", 0);
        TestCase tc2 = sampleTestCase("[3,2,4]\n6", "1 2", 1);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1, tc2));
        when(grader.gradeUntilFailure(PROGRAM, List.of(
                new TestInput("[2,7,11,15]\n9", "0 1"), new TestInput("[3,2,4]\n6", "1 2"))))
                .thenReturn(Verdict.of(List.of(accepted("0 1"), accepted("1 2"))));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", null));

        assertEquals(SubmissionStatus.ACCEPTED, response.overallStatus());
        assertEquals(2, response.results().size());
        assertEquals("[2,7,11,15]\n9", response.results().get(0).input());
        assertEquals("0 1", response.results().get(0).expectedOutput());
        assertEquals("0 1", response.results().get(0).actualOutput());
        assertEquals("1 2", response.results().get(1).actualOutput());
        assertTrue(response.results().get(0).errors().isEmpty());
        verify(grader, never()).grade(any(), anyList());
    }

    @Test
    void run_compilationError_returnsCompilationError() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("[2,7,11,15]\n9", "0 1", 0);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1));
        when(grader.gradeUntilFailure(eq(PROGRAM), anyList()))
                .thenReturn(Verdict.of(List.of(compilationError("error: ';' expected"))));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", null));

        assertEquals(SubmissionStatus.COMPILATION_ERROR, response.overallStatus());
        assertEquals(1, response.results().size());
        assertEquals("error: ';' expected", response.results().get(0).compileOutput());
    }

    @Test
    void run_mapsJudgeErrorsOntoUserCodeLines() {
        setupCommonMocks();
        // The fixture driver puts the user's code at line 3 of the combined file, so combined
        // line 5 is user line 3 of this five-line program.
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(sampleTestCase("in", "out", 0)));
        when(grader.gradeUntilFailure(any(Program.class), anyList()))
                .thenReturn(Verdict.of(List.of(compilationError(
                        "Main.java:5: error: ';' expected\n        int x = 1\n                 ^\n1 error"))));

        RunResponse response = runService.run("pair-sum",
                new RunRequest("java", "a\nb\nint x = 1\nd\ne", null));

        List<CodeError> errors = response.results().get(0).errors();
        assertEquals(1, errors.size());
        assertEquals(3, errors.get(0).line());
        assertEquals(CodeError.Severity.ERROR, errors.get(0).severity());
        assertTrue(errors.get(0).inUserCode());
        assertTrue(errors.get(0).message().contains("';' expected"));
    }

    @Test
    void run_problemNotFound_throwsResourceNotFoundException() {
        when(problemRepository.findBySlugOrFormerSlug("missing")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> runService.run("missing", new RunRequest("java", "code", null)));
    }

    @Test
    void run_unsupportedLanguage_throwsUnsupportedValueException() {
        when(problemRepository.findBySlugOrFormerSlug("pair-sum")).thenReturn(Optional.of(problem));

        assertThrows(UnsupportedValueException.class,
                () -> runService.run("pair-sum", new RunRequest("rust", "code", null)));
    }

    @Test
    void run_noDriverForTheLanguage_throwsNoDriverException() {
        when(problemRepository.findBySlugOrFormerSlug("pair-sum")).thenReturn(Optional.of(problem));

        // The fixture has only a Java driver.
        assertThrows(NoDriverException.class,
                () -> runService.run("pair-sum", new RunRequest("python", "code", null)));
        verify(grader, never()).gradeUntilFailure(any(), anyList());
    }

    // ── Custom test case tests ────────────────────────────────────────────

    @Test
    void run_customTests_runAllAfterSamples_judgedTrue() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("[2,7,11,15]\n9", "0 1", 0);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1));
        when(grader.gradeUntilFailure(eq(PROGRAM), anyList()))
                .thenReturn(Verdict.of(List.of(accepted("0 1"))));
        when(grader.grade(PROGRAM, List.of(
                new TestInput("custom-input-1", "custom-out-1"), new TestInput("custom-input-2", "custom-out-2"))))
                .thenReturn(Verdict.of(List.of(accepted("custom-out-1"), accepted("custom-out-2"))));

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
        assertEquals("custom-input-1", response.results().get(1).input());
        assertEquals("custom-out-1", response.results().get(1).expectedOutput());
        assertTrue(response.results().get(2).isCustom());
        assertTrue(response.results().get(2).judged());
    }

    @Test
    void run_customTestNoExpected_judgedFalse_expectedNull() {
        setupCommonMocks();
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of());
        when(grader.gradeUntilFailure(PROGRAM, List.of())).thenReturn(Verdict.empty());
        when(grader.grade(PROGRAM, List.of(new TestInput("hello", null))))
                .thenReturn(Verdict.of(List.of(unjudged("hi"))));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("hello", "  ")
        )));

        assertEquals(1, response.results().size());
        RunTestCaseResult r = response.results().get(0);
        assertTrue(r.isCustom());
        assertFalse(r.judged());
        assertNull(r.expectedOutput());
        assertEquals(SubmissionStatus.ACCEPTED, r.status());
        assertEquals("hi", r.actualOutput());
        assertEquals(SubmissionStatus.ACCEPTED, response.overallStatus());
    }

    @Test
    void run_customTestsAreGradedInFull_notUntilFailure() {
        setupCommonMocks();
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of());
        when(grader.gradeUntilFailure(PROGRAM, List.of())).thenReturn(Verdict.empty());
        when(grader.grade(PROGRAM, List.of(new TestInput("a", "X"), new TestInput("b", "Y"))))
                .thenReturn(Verdict.of(List.of(wrongAnswer("nope"), accepted("Y"))));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("a", "X"),
                new CustomTestCaseInput("b", "Y")
        )));

        assertEquals(SubmissionStatus.WRONG_ANSWER, response.overallStatus());
        assertEquals(2, response.results().size());
        assertEquals(SubmissionStatus.WRONG_ANSWER, response.results().get(0).status());
        assertEquals(SubmissionStatus.ACCEPTED, response.results().get(1).status());
        verify(grader, never()).gradeUntilFailure(eq(PROGRAM), eq(List.of(new TestInput("a", "X"), new TestInput("b", "Y"))));
    }

    @Test
    void run_samplesShortCircuit_customsNotRun() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("sample-in", "sample-out", 0);
        TestCase tc2 = sampleTestCase("sample-in-2", "sample-out-2", 1);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1, tc2));
        // The Grader stopped after the first sample, so its verdict is a one-case prefix.
        when(grader.gradeUntilFailure(eq(PROGRAM), anyList()))
                .thenReturn(Verdict.of(List.of(wrongAnswer("nope"))));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("custom-in", "custom-out")
        )));

        assertEquals(SubmissionStatus.WRONG_ANSWER, response.overallStatus());
        assertEquals(1, response.results().size());
        assertFalse(response.results().get(0).isCustom());
        assertEquals("sample-in", response.results().get(0).input());
        verify(grader, never()).grade(any(), anyList());
    }

    @Test
    void run_samplesPassCustomFails_overallReflectsCustomFailure() {
        setupCommonMocks();
        TestCase tc1 = sampleTestCase("sample-in", "sample-out", 0);
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L))
                .thenReturn(List.of(tc1));
        when(grader.gradeUntilFailure(eq(PROGRAM), anyList()))
                .thenReturn(Verdict.of(List.of(accepted("sample-out"))));
        when(grader.grade(eq(PROGRAM), anyList()))
                .thenReturn(Verdict.of(List.of(wrongAnswer("wrong"))));

        RunResponse response = runService.run("pair-sum", new RunRequest("java", "code", List.of(
                new CustomTestCaseInput("custom-in", "custom-out")
        )));

        assertEquals(SubmissionStatus.WRONG_ANSWER, response.overallStatus());
        assertEquals(2, response.results().size());
        assertEquals(SubmissionStatus.ACCEPTED, response.results().get(0).status());
        assertEquals(SubmissionStatus.WRONG_ANSWER, response.results().get(1).status());
    }
}
