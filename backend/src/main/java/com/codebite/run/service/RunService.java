package com.codebite.run.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.common.exception.UnsupportedValueException;
import com.codebite.judge.Language;
import com.codebite.judge.dto.CodeError;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Grader;
import com.codebite.judge.grader.TestInput;
import com.codebite.judge.grader.Verdict;
import com.codebite.judge.parser.JudgeErrorParsers;
import com.codebite.judge.parser.UserCodeLineMapper;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.judge.program.Program;
import com.codebite.judge.service.DriverCodeLoader;
import com.codebite.judge.service.JudgeService;
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
    private final JudgeService judgeService;
    private final Grader grader;
    private final DriverCodeLoader driverCodeLoader;
    private final ProblemAssets assets;
    private final JudgeErrorParsers errorParsers;
    private final UserCodeLineMapper lineMapper;

    public RunService(ProblemRepository problemRepository,
                      TestCaseRepository testCaseRepository,
                      JudgeService judgeService,
                      Grader grader,
                      DriverCodeLoader driverCodeLoader,
                      ProblemAssets assets,
                      JudgeErrorParsers errorParsers,
                      UserCodeLineMapper lineMapper) {
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.judgeService = judgeService;
        this.grader = grader;
        this.driverCodeLoader = driverCodeLoader;
        this.assets = assets;
        this.errorParsers = errorParsers;
        this.lineMapper = lineMapper;
    }

    public RunResponse run(String slug, RunRequest request) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));

        String language = request.language().toLowerCase();
        if (!judgeService.isLanguageSupported(language)) {
            throw new UnsupportedValueException("error.language.unsupported", language);
        }

        Program program = assets.assemble(problem.getSlug(), Language.fromCode(language).orElseThrow(),
                request.sourceCode());
        int userCodeStartLine = driverCodeLoader.getUserCodeStartLine(problem.getSlug(), language);
        int userCodeLineCount = countLines(request.sourceCode());

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
                    samples.cases().get(i), false, language, userCodeStartLine, userCodeLineCount));
        }
        for (int i = 0; i < customs.cases().size(); i++) {
            TestInput input = customInputs.get(i);
            results.add(toResult(input, input.expectedOutput(),
                    customs.cases().get(i), true, language, userCodeStartLine, userCodeLineCount));
        }

        SubmissionStatus overallStatus = samples.overall() == SubmissionStatus.ACCEPTED
                ? customs.overall()
                : samples.overall();
        return new RunResponse(overallStatus, results);
    }

    private RunTestCaseResult toResult(TestInput input, String expectedOutput, CaseVerdict verdict,
                                       boolean isCustom, String language,
                                       int userCodeStartLine, int userCodeLineCount) {
        return new RunTestCaseResult(
                input.stdin(),
                expectedOutput,
                verdict.stdout(),
                verdict.status(),
                verdict.stderr(),
                verdict.compileOutput(),
                mapErrors(verdict, language, userCodeStartLine, userCodeLineCount),
                isCustom,
                verdict.judged()
        );
    }

    private List<CodeError> mapErrors(CaseVerdict verdict, String language,
                                      int userCodeStartLine, int userCodeLineCount) {
        List<CodeError> combined = errorParsers.parse(language, verdict.compileOutput(), verdict.stderr());
        return lineMapper.mapToUserSpace(combined, userCodeStartLine, userCodeLineCount);
    }

    private static int countLines(String source) {
        if (source == null || source.isEmpty()) return 0;
        int count = 1;
        for (int i = 0; i < source.length(); i++) {
            if (source.charAt(i) == '\n') count++;
        }
        return count;
    }
}
