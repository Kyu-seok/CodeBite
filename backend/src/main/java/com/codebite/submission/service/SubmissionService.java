package com.codebite.submission.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.github.dto.SolutionCommitSummary;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.judge.Language;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.judge.program.Program;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.review.entity.Confidence;
import com.codebite.review.service.ReviewService;
import com.codebite.submission.dto.SubmissionListItem;
import com.codebite.submission.dto.SubmissionResponse;
import com.codebite.submission.dto.SubmissionResultDto;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.kafka.SubmissionEventProducer;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class SubmissionService {

    private final SubmissionRepository submissionRepository;
    private final SubmissionResultRepository submissionResultRepository;
    private final ProblemRepository problemRepository;
    private final TestCaseRepository testCaseRepository;
    private final UserRepository userRepository;
    private final ProblemAssets assets;
    private final SubmissionEventProducer submissionEventProducer;
    private final SolutionCommitRepository solutionCommitRepository;
    private final ReviewService reviewService;
    private final Counter submissionsCreatedCounter;

    public SubmissionService(SubmissionRepository submissionRepository,
                             SubmissionResultRepository submissionResultRepository,
                             ProblemRepository problemRepository,
                             TestCaseRepository testCaseRepository,
                             UserRepository userRepository,
                             ProblemAssets assets,
                             SubmissionEventProducer submissionEventProducer,
                             SolutionCommitRepository solutionCommitRepository,
                             ReviewService reviewService,
                             MeterRegistry meterRegistry) {
        this.submissionRepository = submissionRepository;
        this.submissionResultRepository = submissionResultRepository;
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.userRepository = userRepository;
        this.assets = assets;
        this.submissionEventProducer = submissionEventProducer;
        this.solutionCommitRepository = solutionCommitRepository;
        this.reviewService = reviewService;
        this.submissionsCreatedCounter = Counter.builder("codebite.submissions.created")
                .description("Total submissions created")
                .register(meterRegistry);
    }

    public SubmissionResponse submit(String slug, SubmitRequest request, Long userId) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));

        Language language = Language.ofRequest(request.language());

        // Assembled before persisting anything, so a problem with no driver for the language
        // fails fast.
        Program program = assets.assemble(problem.getSlug(), language, request.sourceCode());

        // Save submission as PENDING
        Submission submission = saveSubmission(userId, problem, language, request.sourceCode());

        // Publish to Kafka for worker processing
        submissionEventProducer.send(program.toEvent(submission));
        if (!submission.isAdminSubmission()) {
            submissionsCreatedCounter.increment();
        }

        // Return immediately with PENDING status
        return toResponse(submission, List.of(), problem.getSlug(), List.of(), program, null, null);
    }

    @Transactional(readOnly = true)
    public SubmissionResponse getSubmission(Long id, Long userId) {
        Submission submission = submissionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.submission.notFound", id));

        if (!submission.getUser().getId().equals(userId)) {
            throw new ResourceNotFoundException("error.submission.notFound", id);
        }

        List<SubmissionResult> results = submissionResultRepository.findBySubmissionIdOrderById(id);
        List<TestCase> testCases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(
                submission.getProblem().getId());

        SolutionCommitSummary solutionCommit = solutionCommitRepository
                .findFirstBySubmissionIdOrderByIdDesc(id)
                .map(SolutionCommitSummary::from)
                .orElse(null);

        Map<Confidence, Integer> reviewIntervalDays = submission.getStatus() == SubmissionStatus.PENDING
                ? null
                : reviewService.previewIntervals(submission);

        return toResponse(submission, results, submission.getProblem().getSlug(),
                testCases, assets.recall(submission), solutionCommit, reviewIntervalDays);
    }

    @Transactional(readOnly = true)
    public List<SubmissionListItem> getUserSubmissions(String slug, Long userId) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", slug));

        List<Submission> submissions = submissionRepository
                .findByUserIdAndProblemIdOrderByCreatedAtDesc(userId, problem.getId());

        return submissions.stream().map(this::toListItem).toList();
    }

    // Intentionally not @Transactional: this is called via this.submit(), so a Spring proxy would
    // never apply and the annotation would only be documentation that lies. save() supplies its own
    // transaction, which is all a single-row insert needs.
    private Submission saveSubmission(Long userId, Problem problem, Language language, String sourceCode) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));

        return submissionRepository.save(Submission.pending(user, problem, language.code(), sourceCode));
    }

    private SubmissionResponse toResponse(Submission submission, List<SubmissionResult> results,
                                          String problemSlug, List<TestCase> allTestCases,
                                          Program program, SolutionCommitSummary solutionCommit,
                                          Map<Confidence, Integer> reviewIntervalDays) {
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
                    r.getMemoryKb(),
                    program.diagnostics(r.getCompileOutput(), r.getStderr())
            );
        }).toList();

        return new SubmissionResponse(
                submission.getId(),
                problemSlug,
                submission.getLanguage(),
                submission.getStatus(),
                submission.getRuntimeMs(),
                submission.getMemoryKb(),
                submission.getSourceCode(),
                resultDtos,
                submission.getCreatedAt(),
                submission.getNotes(),
                submission.getConfidence(),
                submission.getSolveTimeSeconds(),
                solutionCommit,
                reviewIntervalDays
        );
    }

    private SubmissionListItem toListItem(Submission submission) {
        return new SubmissionListItem(
                submission.getId(),
                submission.getStatus(),
                submission.getLanguage(),
                submission.getRuntimeMs(),
                submission.getMemoryKb(),
                submission.getCreatedAt(),
                submission.getNotes(),
                submission.getConfidence(),
                submission.getSolveTimeSeconds()
        );
    }

    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<SubmissionListItem> getUserSubmissionsForAdmin(
            Long userId, org.springframework.data.domain.Pageable pageable) {
        return submissionRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable)
                .map(this::toListItem);
    }

    @Transactional
    public void deleteSubmission(Long id) {
        if (!submissionRepository.existsById(id)) {
            throw new ResourceNotFoundException("error.submission.notFound", id);
        }
        submissionRepository.deleteById(id);
    }

    @Transactional
    public void updateNote(Long id, String notes, Long userId) {
        Submission submission = submissionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.submission.notFound", id));

        if (!submission.getUser().getId().equals(userId)) {
            throw new ResourceNotFoundException("error.submission.notFound", id);
        }

        submission.setNotes(notes);
        submissionRepository.save(submission);
    }

    /** Stores the solve time; null or 0 stores no time, since 0:00 is never a real solve. */
    @Transactional
    public void setSolveTime(Long id, Integer solveTimeSeconds, Long userId) {
        Submission submission = submissionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.submission.notFound", id));

        if (!submission.getUser().getId().equals(userId)) {
            throw new ResourceNotFoundException("error.submission.notFound", id);
        }

        submission.setSolveTimeSeconds(
                solveTimeSeconds == null || solveTimeSeconds == 0 ? null : solveTimeSeconds);
        submissionRepository.save(submission);
    }
}
