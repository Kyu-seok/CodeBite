package com.codebite.submission;

import com.codebite.common.exception.NoDriverException;
import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.Language;
import com.codebite.judge.dto.CodeError;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.review.entity.Confidence;
import com.codebite.review.service.ReviewService;
import com.codebite.submission.dto.SubmissionResponse;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionEvent;
import com.codebite.submission.kafka.SubmissionEventProducer;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.submission.service.SubmissionService;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SubmissionServiceTest {

    @Mock private SubmissionRepository submissionRepository;
    @Mock private SubmissionResultRepository submissionResultRepository;
    @Mock private ProblemRepository problemRepository;
    @Mock private TestCaseRepository testCaseRepository;
    @Mock private UserRepository userRepository;
    @Mock private SubmissionEventProducer submissionEventProducer;
    @Mock private SolutionCommitRepository solutionCommitRepository;
    @Mock private ReviewService reviewService;

    /** A one-problem fixture whose Java driver puts the user's code on line 3. */
    private static final ProblemAssets ASSETS = new ProblemAssets("classpath:problem-assets/");

    private SubmissionService submissionService;

    private Problem problem;
    private User user;

    @BeforeEach
    void setUp() {
        submissionService = new SubmissionService(
                submissionRepository, submissionResultRepository,
                problemRepository, testCaseRepository, userRepository,
                ASSETS, submissionEventProducer,
                solutionCommitRepository, reviewService, new SimpleMeterRegistry());

        problem = new Problem();
        problem.setId(1L);
        problem.setTitle("Two Sum");
        problem.setSlug("pair-sum");
        problem.setDescription("Description");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);

        user = new User();
        user.setId(1L);
        user.setUsername("testuser");
        user.setEmail("test@test.com");
        user.setPasswordHash("hash");
    }

    private void setupCommonMocks() {
        when(problemRepository.findBySlug("pair-sum")).thenReturn(Optional.of(problem));
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(submissionRepository.save(any())).thenAnswer(inv -> {
            Submission s = inv.getArgument(0);
            if (s.getId() == null) s.setId(1L);
            return s;
        });
    }

    // --- submit: returns PENDING immediately and kicks off async ---

    @Test
    void submit_returnsPendingAndStartsAsync() {
        setupCommonMocks();

        SubmissionResponse response = submissionService.submit("pair-sum", new SubmitRequest("java", "code"), 1L);

        assertEquals(SubmissionStatus.PENDING, response.status());
        assertTrue(response.results().isEmpty());
        assertEquals("pair-sum", response.problemSlug());
        verify(submissionEventProducer).send(any(SubmissionEvent.class));
    }

    @Test
    void submit_publishesTheAssembledProgram() {
        setupCommonMocks();

        submissionService.submit("pair-sum", new SubmitRequest("Java", "class Solution {}"), 1L);

        ArgumentCaptor<SubmissionEvent> sent = ArgumentCaptor.forClass(SubmissionEvent.class);
        verify(submissionEventProducer).send(sent.capture());
        SubmissionEvent event = sent.getValue();
        assertEquals(1L, event.submissionId());
        assertEquals(ASSETS.assemble("pair-sum", Language.JAVA, "class Solution {}").source(), event.sourceCode());
        assertTrue(event.sourceCode().contains("class Solution {}"));
        assertEquals(Language.JAVA.judge0Id(), event.languageId());
        assertEquals(1L, event.problemId());
        assertEquals("java", event.language());
    }

    @Test
    void submit_noDriverForTheLanguage_savesNothing() {
        when(problemRepository.findBySlug("pair-sum")).thenReturn(Optional.of(problem));

        // The fixture has only a Java driver.
        assertThrows(NoDriverException.class,
                () -> submissionService.submit("pair-sum", new SubmitRequest("python", "code"), 1L));
        verify(submissionRepository, never()).save(any());
        verify(submissionEventProducer, never()).send(any(SubmissionEvent.class));
    }

    @Test
    void buildEvent_rebuildsTheEventFromTheStoredCode() {
        Submission submission = ownedSubmission(SubmissionStatus.PENDING);

        SubmissionEvent event = submissionService.buildEvent(submission);

        assertEquals(ASSETS.assemble("pair-sum", Language.JAVA, "code").toEvent(submission), event);
    }

    // --- submit: problem not found ---

    @Test
    void submit_problemNotFound() {
        when(problemRepository.findBySlug("missing")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> submissionService.submit("missing", new SubmitRequest("java", "code"), 1L));
        verify(submissionEventProducer, never()).send(any(SubmissionEvent.class));
    }

    // --- submit: unsupported language ---

    @Test
    void submit_unsupportedLanguage() {
        when(problemRepository.findBySlug("pair-sum")).thenReturn(Optional.of(problem));

        assertThrows(com.codebite.common.exception.UnsupportedValueException.class,
                () -> submissionService.submit("pair-sum", new SubmitRequest("rust", "code"), 1L));
        verify(submissionEventProducer, never()).send(any(SubmissionEvent.class));
    }

    // --- getSubmission: ownership ---

    @Test
    void getSubmission_ownerCanView() {
        Submission submission = ownedSubmission(SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(submissionResultRepository.findBySubmissionIdOrderById(1L)).thenReturn(List.of());
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of());

        SubmissionResponse response = submissionService.getSubmission(1L, 1L);
        assertNotNull(response);
        assertEquals(1L, response.id());
    }

    @Test
    void getSubmission_mapsEachResultsErrorsOntoTheUserCodeLines() {
        TestCase testCase = new TestCase();
        testCase.setId(5L);
        testCase.setProblem(problem);
        testCase.setSample(true);
        Submission submission = Submission.pending(user, problem, "java", "a\nb\nint x = 1");
        submission.setId(1L);
        // The fixture driver puts the user's code on line 3, so combined line 5 is user line 3.
        submission.grade(Verdict.of(List.of(new CaseVerdict(SubmissionStatus.COMPILATION_ERROR, true,
                null, null, "Main.java:5: error: ';' expected\n1 error", null, null))), List.of(testCase));
        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(submissionResultRepository.findBySubmissionIdOrderById(1L)).thenReturn(submission.getResults());

        SubmissionResponse response = submissionService.getSubmission(1L, 1L);

        List<CodeError> errors = response.results().get(0).errors();
        assertEquals(1, errors.size());
        assertEquals(3, errors.get(0).line());
        assertTrue(errors.get(0).inUserCode());
    }

    @Test
    void getSubmission_problemWithoutTheDriverStillRenders_withoutErrors() {
        Problem gone = new Problem();
        gone.setId(2L);
        gone.setSlug("no-such-driver");
        TestCase testCase = new TestCase();
        testCase.setId(6L);
        testCase.setProblem(gone);
        Submission submission = Submission.pending(user, gone, "java", "code");
        submission.setId(1L);
        submission.grade(Verdict.of(List.of(new CaseVerdict(SubmissionStatus.COMPILATION_ERROR, true,
                null, null, "Main.java:1: error: x\n1 error", null, null))), List.of(testCase));
        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(submissionResultRepository.findBySubmissionIdOrderById(1L)).thenReturn(submission.getResults());

        SubmissionResponse response = submissionService.getSubmission(1L, 1L);

        assertEquals(SubmissionStatus.COMPILATION_ERROR, response.results().get(0).status());
        assertTrue(response.results().get(0).errors().isEmpty());
    }

    // --- getSubmission: review interval previews ---

    @Test
    void getSubmission_pending_hasNoReviewIntervalPreview() {
        Submission submission = ownedSubmission(SubmissionStatus.PENDING);
        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        SubmissionResponse response = submissionService.getSubmission(1L, 1L);

        assertNull(response.reviewIntervalDays());
        verify(reviewService, never()).previewIntervals(any());
    }

    @Test
    void getSubmission_judged_carriesTheReviewIntervalPreview() {
        Submission submission = ownedSubmission(SubmissionStatus.ACCEPTED);
        Map<Confidence, Integer> preview = Map.of(Confidence.AGAIN, 1, Confidence.HARD, 7,
                Confidence.GOOD, 15, Confidence.EASY, 20);
        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(reviewService.previewIntervals(submission)).thenReturn(preview);

        SubmissionResponse response = submissionService.getSubmission(1L, 1L);

        assertEquals(preview, response.reviewIntervalDays());
    }

    /** PENDING, or Accepted with no result rows. */
    private Submission ownedSubmission(SubmissionStatus status) {
        Submission submission = Submission.pending(user, problem, "java", "code");
        submission.setId(1L);
        if (status == SubmissionStatus.ACCEPTED) {
            submission.grade(Verdict.empty(), List.of());
        }
        return submission;
    }

    @Test
    void getSubmission_nonOwnerGetsDenied() {
        Submission submission = ownedSubmission(SubmissionStatus.PENDING);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));

        assertThrows(ResourceNotFoundException.class,
                () -> submissionService.getSubmission(1L, 999L));
    }

    @Test
    void getSubmission_notFound() {
        when(submissionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> submissionService.getSubmission(99L, 1L));
    }
}
