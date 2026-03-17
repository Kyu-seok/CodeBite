package com.codebite.submission.service;

import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SubmissionJudgeProcessor {

    private static final Logger log = LoggerFactory.getLogger(SubmissionJudgeProcessor.class);

    private final JudgeService judgeService;
    private final TestCaseRepository testCaseRepository;
    private final SubmissionResultRepository submissionResultRepository;
    private final SubmissionRepository submissionRepository;

    public SubmissionJudgeProcessor(JudgeService judgeService,
                                    TestCaseRepository testCaseRepository,
                                    SubmissionResultRepository submissionResultRepository,
                                    SubmissionRepository submissionRepository) {
        this.judgeService = judgeService;
        this.testCaseRepository = testCaseRepository;
        this.submissionResultRepository = submissionResultRepository;
        this.submissionRepository = submissionRepository;
    }

    @Async("submissionExecutor")
    @Transactional
    public void processAsync(Long submissionId, String sourceCode, int languageId, Long problemId) {
        try {
            List<TestCase> testCases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(problemId);

            List<SubmissionResult> results = new ArrayList<>();
            SubmissionStatus overallStatus = SubmissionStatus.ACCEPTED;
            Integer maxRuntimeMs = null;
            Integer maxMemoryKb = null;

            Submission submission = submissionRepository.findById(submissionId).orElseThrow();

            for (TestCase testCase : testCases) {
                JudgeResponse response = judgeService.execute(sourceCode, languageId, testCase.getInput());
                SubmissionStatus caseStatus = judgeService.mapStatus(response, testCase.getExpectedOutput());

                SubmissionResult result = new SubmissionResult();
                result.setSubmission(submission);
                result.setTestCase(testCase);
                result.setStatus(caseStatus);
                result.setActualOutput(response.stdout() != null ? response.stdout().trim() : null);
                result.setStderr(response.stderr());

                Integer runtimeMs = parseTimeToMs(response.time());
                result.setRuntimeMs(runtimeMs);
                result.setMemoryKb(response.memory());

                if (runtimeMs != null) {
                    maxRuntimeMs = maxRuntimeMs == null ? runtimeMs : Math.max(maxRuntimeMs, runtimeMs);
                }
                if (response.memory() != null) {
                    maxMemoryKb = maxMemoryKb == null ? response.memory() : Math.max(maxMemoryKb, response.memory());
                }

                results.add(result);

                if (caseStatus != SubmissionStatus.ACCEPTED) {
                    overallStatus = caseStatus;
                    break;
                }
            }

            submissionResultRepository.saveAll(results);
            submission.setStatus(overallStatus);
            submission.setRuntimeMs(maxRuntimeMs);
            submission.setMemoryKb(maxMemoryKb);
            submissionRepository.save(submission);
        } catch (Exception e) {
            log.error("Async submission processing failed for submissionId={}: {}", submissionId, e.getMessage(), e);
            submissionRepository.findById(submissionId).ifPresent(submission -> {
                submission.setStatus(SubmissionStatus.INTERNAL_ERROR);
                submissionRepository.save(submission);
            });
        }
    }

    private Integer parseTimeToMs(String time) {
        if (time == null) return null;
        try {
            return (int) (Double.parseDouble(time) * 1000);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
