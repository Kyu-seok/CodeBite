package com.codebite.run.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.dto.JudgeResponse;
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

    public RunService(ProblemRepository problemRepository,
                      TestCaseRepository testCaseRepository,
                      JudgeService judgeService,
                      DriverCodeLoader driverCodeLoader) {
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.judgeService = judgeService;
        this.driverCodeLoader = driverCodeLoader;
    }

    public RunResponse run(String slug, SubmitRequest request) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("Problem not found: " + slug));

        String language = request.language().toLowerCase();
        if (!judgeService.isLanguageSupported(language)) {
            throw new IllegalArgumentException("Unsupported language: " + language);
        }

        String driverTemplate = driverCodeLoader.getDriverCode(problem.getSlug(), language);
        String sourceCode = judgeService.buildSourceCode(driverTemplate, request.sourceCode());
        int languageId = judgeService.mapLanguageToId(language);

        List<TestCase> sampleTestCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());

        List<RunTestCaseResult> results = new ArrayList<>();
        SubmissionStatus overallStatus = SubmissionStatus.ACCEPTED;

        for (TestCase testCase : sampleTestCases) {
            JudgeResponse response = judgeService.execute(sourceCode, languageId, testCase.getInput());
            SubmissionStatus caseStatus = judgeService.mapStatus(response, testCase.getExpectedOutput());

            results.add(new RunTestCaseResult(
                    testCase.getInput(),
                    testCase.getExpectedOutput(),
                    response.stdout() != null ? response.stdout().trim() : null,
                    caseStatus,
                    response.stderr(),
                    response.compileOutput()
            ));

            if (caseStatus != SubmissionStatus.ACCEPTED) {
                overallStatus = caseStatus;
                break;
            }
        }

        return new RunResponse(overallStatus, results);
    }
}
