package com.codebite.submission.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.service.DriverCodeLoader;
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
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.kafka.SubmissionEventProducer;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SubmissionService {

    private final SubmissionRepository submissionRepository;
    private final SubmissionResultRepository submissionResultRepository;
    private final ProblemRepository problemRepository;
    private final TestCaseRepository testCaseRepository;
    private final UserRepository userRepository;
    private final JudgeService judgeService;
    private final DriverCodeLoader driverCodeLoader;
    private final SubmissionEventProducer submissionEventProducer;

    public SubmissionService(SubmissionRepository submissionRepository,
                             SubmissionResultRepository submissionResultRepository,
                             ProblemRepository problemRepository,
                             TestCaseRepository testCaseRepository,
                             UserRepository userRepository,
                             JudgeService judgeService,
                             DriverCodeLoader driverCodeLoader,
                             SubmissionEventProducer submissionEventProducer) {
        this.submissionRepository = submissionRepository;
        this.submissionResultRepository = submissionResultRepository;
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.userRepository = userRepository;
        this.judgeService = judgeService;
        this.driverCodeLoader = driverCodeLoader;
        this.submissionEventProducer = submissionEventProducer;
    }

    public SubmissionResponse submit(String slug, SubmitRequest request, Long userId) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("Problem not found: " + slug));

        String language = request.language().toLowerCase();
        if (!judgeService.isLanguageSupported(language)) {
            throw new IllegalArgumentException("Unsupported language: " + language);
        }

        String driverTemplate = driverCodeLoader.getDriverCode(problem.getSlug(), language);

        // Save submission as PENDING
        Submission submission = saveSubmission(userId, problem, request);

        // Build source code and publish to Kafka for worker processing
        String sourceCode = judgeService.buildSourceCode(driverTemplate, request.sourceCode());
        int languageId = judgeService.mapLanguageToId(language);
        submissionEventProducer.send(new SubmissionEvent(
                submission.getId(), sourceCode, languageId, problem.getId()));

        // Return immediately with PENDING status
        return toResponse(submission, List.of(), problem.getSlug(), List.of());
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
