package com.codebite.run.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.common.exception.UnsupportedValueException;
import com.codebite.judge.dto.CodeError;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.parser.JudgeErrorParsers;
import com.codebite.judge.parser.UserCodeLineMapper;
import com.codebite.judge.service.DriverCodeLoader;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.run.dto.RunResponse;
import com.codebite.run.dto.RunTestCaseResult;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.entity.SubmissionStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RunService {

    private final ProblemRepository problemRepository;
    private final TestCaseRepository testCaseRepository;
    private final JudgeService judgeService;
    private final DriverCodeLoader driverCodeLoader;
    private final JudgeErrorParsers errorParsers;
    private final UserCodeLineMapper lineMapper;

    public RunService(ProblemRepository problemRepository,
                      TestCaseRepository testCaseRepository,
                      JudgeService judgeService,
                      DriverCodeLoader driverCodeLoader,
                      JudgeErrorParsers errorParsers,
                      UserCodeLineMapper lineMapper) {
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.judgeService = judgeService;
        this.driverCodeLoader = driverCodeLoader;
        this.errorParsers = errorParsers;
        this.lineMapper = lineMapper;
    }

    public RunResponse run(String slug, SubmitRequest request) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));

        String language = request.language().toLowerCase();
        if (!judgeService.isLanguageSupported(language)) {
            throw new UnsupportedValueException("error.language.unsupported", language);
        }

        String driverTemplate = driverCodeLoader.getDriverCode(problem.getSlug(), language);
        String sourceCode = judgeService.buildSourceCode(driverTemplate, request.sourceCode());
        int languageId = judgeService.mapLanguageToId(language);
        int userCodeStartLine = driverCodeLoader.getUserCodeStartLine(problem.getSlug(), language);
        int userCodeLineCount = countLines(request.sourceCode());

        List<TestCase> sampleTestCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());

        List<RunTestCaseResult> results = new ArrayList<>();
        SubmissionStatus overallStatus = SubmissionStatus.ACCEPTED;

        for (TestCase testCase : sampleTestCases) {
            JudgeResponse response = judgeService.execute(sourceCode, languageId, testCase.getInput());
            SubmissionStatus caseStatus = judgeService.mapStatus(response, testCase.getExpectedOutput());

            List<CodeError> combined = errorParsers.parse(
                    language, response.compileOutput(), response.stderr());
            List<CodeError> errors = lineMapper.mapToUserSpace(
                    combined, userCodeStartLine, userCodeLineCount);

            results.add(new RunTestCaseResult(
                    testCase.getInput(),
                    testCase.getExpectedOutput(),
                    response.stdout() != null ? response.stdout().trim() : null,
                    caseStatus,
                    response.stderr(),
                    response.compileOutput(),
                    errors
            ));

            if (caseStatus != SubmissionStatus.ACCEPTED) {
                overallStatus = caseStatus;
                break;
            }
        }

        return new RunResponse(overallStatus, results);
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
