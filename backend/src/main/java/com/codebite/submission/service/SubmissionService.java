package com.codebite.submission.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.dto.SubmissionListItem;
import com.codebite.submission.dto.SubmissionResponse;
import com.codebite.submission.dto.SubmissionResultDto;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class SubmissionService {

    private final SubmissionRepository submissionRepository;
    private final SubmissionResultRepository submissionResultRepository;
    private final ProblemRepository problemRepository;
    private final TestCaseRepository testCaseRepository;
    private final UserRepository userRepository;
    private final JudgeService judgeService;

    public SubmissionService(SubmissionRepository submissionRepository,
                             SubmissionResultRepository submissionResultRepository,
                             ProblemRepository problemRepository,
                             TestCaseRepository testCaseRepository,
                             UserRepository userRepository,
                             JudgeService judgeService) {
        this.submissionRepository = submissionRepository;
        this.submissionResultRepository = submissionResultRepository;
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.userRepository = userRepository;
        this.judgeService = judgeService;
    }

    public SubmissionResponse submit(String slug, SubmitRequest request, Long userId) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("Problem not found: " + slug));

        String language = request.language().toLowerCase();
        if (!judgeService.isLanguageSupported(language)) {
            throw new IllegalArgumentException("Unsupported language: " + language);
        }

        Map<String, String> driverCode = problem.getDriverCode();
        if (driverCode == null || !driverCode.containsKey(language)) {
            throw new IllegalArgumentException("No driver code available for language: " + language);
        }

        // Save submission (transaction 1)
        Submission submission = saveSubmission(userId, problem, request);

        // Execute against Judge0 (not transactional — external I/O)
        List<TestCase> testCases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(problem.getId());
        String sourceCode = judgeService.buildSourceCode(driverCode.get(language), request.sourceCode());
        int languageId = judgeService.mapLanguageToId(language);

        List<SubmissionResult> results = new ArrayList<>();
        SubmissionStatus overallStatus = SubmissionStatus.ACCEPTED;
        Integer maxRuntimeMs = null;
        Integer maxMemoryKb = null;

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

            // Early exit on failure
            if (caseStatus != SubmissionStatus.ACCEPTED) {
                overallStatus = caseStatus;
                break;
            }
        }

        // Save results and update status (transaction 2)
        saveResultsAndUpdateStatus(submission, results, overallStatus, maxRuntimeMs, maxMemoryKb);

        return toResponse(submission, results, problem.getSlug(), testCases);
    }

    @Transactional(readOnly = true)
    public SubmissionResponse getSubmission(Long id, Long userId) {
        Submission submission = submissionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Submission not found: " + id));

        if (!submission.getUser().getId().equals(userId)) {
            throw new ResourceNotFoundException("Submission not found: " + id);
        }

        List<SubmissionResult> results = submissionResultRepository.findBySubmissionIdOrderById(id);
        List<TestCase> testCases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(
                submission.getProblem().getId());

        return toResponse(submission, results, submission.getProblem().getSlug(), testCases);
    }

    @Transactional(readOnly = true)
    public List<SubmissionListItem> getUserSubmissions(String slug, Long userId) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("Problem not found: " + slug));

        List<Submission> submissions = submissionRepository
                .findByUserIdAndProblemIdOrderByCreatedAtDesc(userId, problem.getId());

        return submissions.stream().map(this::toListItem).toList();
    }

    @Transactional
    protected Submission saveSubmission(Long userId, Problem problem, SubmitRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userId));

        Submission submission = new Submission();
        submission.setUser(user);
        submission.setProblem(problem);
        submission.setLanguage(request.language().toLowerCase());
        submission.setSourceCode(request.sourceCode());
        submission.setStatus(SubmissionStatus.PENDING);
        return submissionRepository.save(submission);
    }

    @Transactional
    protected void saveResultsAndUpdateStatus(Submission submission, List<SubmissionResult> results,
                                              SubmissionStatus status, Integer runtimeMs, Integer memoryKb) {
        submissionResultRepository.saveAll(results);
        submission.setStatus(status);
        submission.setRuntimeMs(runtimeMs);
        submission.setMemoryKb(memoryKb);
        submissionRepository.save(submission);
    }

    private Integer parseTimeToMs(String time) {
        if (time == null) return null;
        try {
            return (int) (Double.parseDouble(time) * 1000);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private SubmissionResponse toResponse(Submission submission, List<SubmissionResult> results,
                                          String problemSlug, List<TestCase> allTestCases) {
        List<SubmissionResultDto> resultDtos = results.stream().map(r -> {
            TestCase tc = r.getTestCase();
            boolean isSample = tc.isSample();
            return new SubmissionResultDto(
                    tc.getId(),
                    r.getStatus(),
                    isSample ? tc.getInput() : null,
                    isSample ? tc.getExpectedOutput() : null,
                    r.getActualOutput(),
                    r.getRuntimeMs(),
                    r.getMemoryKb()
            );
        }).toList();

        return new SubmissionResponse(
                submission.getId(),
                problemSlug,
                submission.getLanguage(),
                submission.getStatus(),
                submission.getRuntimeMs(),
                submission.getMemoryKb(),
                resultDtos,
                submission.getCreatedAt()
        );
    }

    private SubmissionListItem toListItem(Submission submission) {
        return new SubmissionListItem(
                submission.getId(),
                submission.getStatus(),
                submission.getLanguage(),
                submission.getRuntimeMs(),
                submission.getMemoryKb(),
                submission.getCreatedAt()
        );
    }
}
