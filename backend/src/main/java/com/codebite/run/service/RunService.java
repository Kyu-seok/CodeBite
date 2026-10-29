package com.codebite.run.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.Language;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Grader;
import com.codebite.judge.grader.TestInput;
import com.codebite.judge.grader.Verdict;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.judge.program.Program;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.run.dto.CustomTestCaseInput;
import com.codebite.run.dto.RunRequest;
import com.codebite.run.dto.RunResponse;
import com.codebite.run.dto.RunTestCaseResult;
import com.codebite.submission.entity.SubmissionStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RunService {

    private final ProblemRepository problemRepository;
    private final TestCaseRepository testCaseRepository;
    private final Grader grader;
    private final ProblemAssets assets;

    public RunService(ProblemRepository problemRepository,
                      TestCaseRepository testCaseRepository,
                      Grader grader,
                      ProblemAssets assets) {
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.grader = grader;
        this.assets = assets;
    }

    public RunResponse run(String slug, RunRequest request) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));

        Language language = Language.ofRequest(request.language());
        Program program = assets.assemble(problem.getSlug(), language, request.sourceCode());

        List<TestCase> sampleTestCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        List<TestInput> sampleInputs = sampleTestCases.stream()
                .map(tc -> new TestInput(tc.getInput(), tc.getExpectedOutput()))
                .toList();
        // A custom case the user left the expected output blank for is an Unjudged Case; a stored
        // sample's expected output goes through as is, empty included.
        List<TestInput> customInputs = request.customTestCases() == null
                ? List.of()
                : request.customTestCases().stream()
                        .map(tc -> new TestInput(tc.input(),
                                tc.expectedOutput() == null || tc.expectedOutput().isBlank() ? null : tc.expectedOutput()))
                        .toList();

        // Samples stop at the first failure, and the custom cases run only once every sample has
        // passed; a failing custom case never stops the others (docs/adr/0005).
        Verdict samples = grader.gradeUntilFailure(program, sampleInputs);
        Verdict customs = samples.overall() == SubmissionStatus.ACCEPTED && !customInputs.isEmpty()
                ? grader.grade(program, customInputs)
                : Verdict.empty();

        List<RunTestCaseResult> results = new ArrayList<>();
        for (int i = 0; i < samples.cases().size(); i++) {
            results.add(toResult(sampleInputs.get(i), sampleTestCases.get(i).getExpectedOutput(),
                    samples.cases().get(i), false, program));
        }
        for (int i = 0; i < customs.cases().size(); i++) {
            TestInput input = customInputs.get(i);
            results.add(toResult(input, input.expectedOutput(),
                    customs.cases().get(i), true, program));
        }

        SubmissionStatus overallStatus = samples.overall() == SubmissionStatus.ACCEPTED
                ? customs.overall()
                : samples.overall();
        return new RunResponse(overallStatus, results);
    }

    private RunTestCaseResult toResult(TestInput input, String expectedOutput, CaseVerdict verdict,
                                       boolean isCustom, Program program) {
        return new RunTestCaseResult(
                input.stdin(),
                expectedOutput,
                verdict.stdout(),
                verdict.status(),
                verdict.stderr(),
                verdict.compileOutput(),
                program.diagnostics(verdict.compileOutput(), verdict.stderr()),
                isCustom,
                verdict.judged()
        );
    }
}
