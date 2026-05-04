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

    public RunResponse run(String slug, RunRequest request) {
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

            List<CodeError> errors = mapErrors(response, language, userCodeStartLine, userCodeLineCount);

            results.add(new RunTestCaseResult(
                    testCase.getInput(),
                    testCase.getExpectedOutput(),
                    response.stdout() != null ? response.stdout().trim() : null,
                    caseStatus,
                    response.stderr(),
                    response.compileOutput(),
                    errors,
                    false,
                    true
            ));

            if (caseStatus != SubmissionStatus.ACCEPTED) {
                overallStatus = caseStatus;
                return new RunResponse(overallStatus, results);
            }
        }

        List<CustomTestCaseInput> customs = request.customTestCases() == null
                ? List.of()
                : request.customTestCases();

        for (CustomTestCaseInput tc : customs) {
            JudgeResponse response = judgeService.execute(sourceCode, languageId, tc.input());

            boolean hasExpected = tc.expectedOutput() != null && !tc.expectedOutput().isBlank();
            SubmissionStatus caseStatus;
            boolean judged;

            if (hasExpected) {
                caseStatus = judgeService.mapStatus(response, tc.expectedOutput());
                judged = true;
            } else {
                int statusId = response.status() != null ? response.status().id() : -1;
                if (statusId == 3) {
                    caseStatus = SubmissionStatus.ACCEPTED;
                    judged = false;
                } else if (statusId == 5) {
                    caseStatus = SubmissionStatus.TIME_LIMIT_EXCEEDED;
                    judged = true;
                } else if (statusId == 6) {
                    caseStatus = SubmissionStatus.COMPILATION_ERROR;
                    judged = true;
                } else if (statusId >= 7 && statusId <= 12) {
                    caseStatus = SubmissionStatus.RUNTIME_ERROR;
                    judged = true;
                } else {
                    caseStatus = SubmissionStatus.INTERNAL_ERROR;
                    judged = true;
                }
            }

            List<CodeError> errors = mapErrors(response, language, userCodeStartLine, userCodeLineCount);

            results.add(new RunTestCaseResult(
                    tc.input(),
                    hasExpected ? tc.expectedOutput() : null,
                    response.stdout() != null ? response.stdout().trim() : null,
                    caseStatus,
                    response.stderr(),
                    response.compileOutput(),
                    errors,
                    true,
                    judged
            ));

            if (judged && caseStatus != SubmissionStatus.ACCEPTED && overallStatus == SubmissionStatus.ACCEPTED) {
                overallStatus = caseStatus;
            }
        }

        return new RunResponse(overallStatus, results);
    }

    private List<CodeError> mapErrors(JudgeResponse response, String language,
                                      int userCodeStartLine, int userCodeLineCount) {
        List<CodeError> combined = errorParsers.parse(language, response.compileOutput(), response.stderr());
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
