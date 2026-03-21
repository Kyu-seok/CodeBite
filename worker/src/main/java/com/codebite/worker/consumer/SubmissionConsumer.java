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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Component
public class SubmissionConsumer {

    private static final Logger log = LoggerFactory.getLogger(SubmissionConsumer.class);

    private final JudgeService judgeService;
    private final TestCaseRepository testCaseRepository;
    private final SubmissionResultRepository submissionResultRepository;
    private final SubmissionRepository submissionRepository;

    public SubmissionConsumer(JudgeService judgeService,
                              TestCaseRepository testCaseRepository,
                              SubmissionResultRepository submissionResultRepository,
                              SubmissionRepository submissionRepository) {
        this.judgeService = judgeService;
        this.testCaseRepository = testCaseRepository;
        this.submissionResultRepository = submissionResultRepository;
        this.submissionRepository = submissionRepository;
    }

    @KafkaListener(topics = "${app.kafka.topic.submission}", groupId = "codebite-worker")
    @Transactional
    public void consume(SubmissionEvent event) {
        Long submissionId = event.submissionId();
        log.info("Processing submission: {}", submissionId);

        try {
            Submission submission = submissionRepository.findById(submissionId).orElse(null);
            if (submission == null || submission.getStatus() != SubmissionStatus.PENDING) {
                log.warn("Skipping already-processed or missing submission: {}", submissionId);
                return;
            }

            List<TestCase> testCases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(event.problemId());

            List<SubmissionResult> results = new ArrayList<>();
            SubmissionStatus overallStatus = SubmissionStatus.ACCEPTED;
            Integer maxRuntimeMs = null;
            Integer maxMemoryKb = null;

            for (TestCase testCase : testCases) {
                JudgeResponse response = judgeService.execute(
                        event.sourceCode(), event.languageId(), testCase.getInput());
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

            log.info("Submission {} completed with status: {}", submissionId, overallStatus);
        } catch (Exception e) {
            log.error("Submission processing failed for submissionId={}: {}", submissionId, e.getMessage(), e);
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
