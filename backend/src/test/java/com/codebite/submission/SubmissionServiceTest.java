package com.codebite.submission;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.service.DriverCodeLoader;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.submission.dto.SubmissionResponse;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.submission.service.SubmissionJudgeProcessor;
import com.codebite.submission.service.SubmissionService;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
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
    @Mock private JudgeService judgeService;
    @Mock private DriverCodeLoader driverCodeLoader;
    @Mock private SubmissionJudgeProcessor submissionJudgeProcessor;

    private SubmissionService submissionService;

    private Problem problem;
    private User user;

    @BeforeEach
    void setUp() {
        submissionService = new SubmissionService(
                submissionRepository, submissionResultRepository,
                problemRepository, testCaseRepository, userRepository,
                judgeService, driverCodeLoader, submissionJudgeProcessor);

        problem = new Problem();
        problem.setId(1L);
        problem.setTitle("Two Sum");
        problem.setSlug("two-sum");
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
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(judgeService.isLanguageSupported("java")).thenReturn(true);
        when(driverCodeLoader.getDriverCode("two-sum", "java")).thenReturn("template {USER_CODE}");
        when(judgeService.mapLanguageToId("java")).thenReturn(62);
        when(judgeService.buildSourceCode(anyString(), anyString())).thenReturn("full source");
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

        SubmissionResponse response = submissionService.submit("two-sum", new SubmitRequest("java", "code"), 1L);

        assertEquals(SubmissionStatus.PENDING, response.status());
        assertTrue(response.results().isEmpty());
        assertEquals("two-sum", response.problemSlug());
        verify(submissionJudgeProcessor).processAsync(eq(1L), eq("full source"), eq(62), eq(1L));
    }

    // --- submit: problem not found ---

    @Test
    void submit_problemNotFound() {
        when(problemRepository.findBySlug("missing")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> submissionService.submit("missing", new SubmitRequest("java", "code"), 1L));
        verify(submissionJudgeProcessor, never()).processAsync(anyLong(), anyString(), anyInt(), anyLong());
    }

    // --- submit: unsupported language ---

    @Test
    void submit_unsupportedLanguage() {
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(judgeService.isLanguageSupported("rust")).thenReturn(false);

        assertThrows(IllegalArgumentException.class,
                () -> submissionService.submit("two-sum", new SubmitRequest("rust", "code"), 1L));
        verify(submissionJudgeProcessor, never()).processAsync(anyLong(), anyString(), anyInt(), anyLong());
    }

    // --- getSubmission: ownership ---

    @Test
    void getSubmission_ownerCanView() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setUser(user);
        submission.setProblem(problem);
        submission.setLanguage("java");
        submission.setSourceCode("code");
        submission.setStatus(SubmissionStatus.ACCEPTED);

        when(submissionRepository.findById(1L)).thenReturn(Optional.of(submission));
        when(submissionResultRepository.findBySubmissionIdOrderById(1L)).thenReturn(List.of());
        when(testCaseRepository.findByProblemIdOrderByOrderIndexAsc(1L)).thenReturn(List.of());

        SubmissionResponse response = submissionService.getSubmission(1L, 1L);
        assertNotNull(response);
        assertEquals(1L, response.id());
    }

    @Test
    void getSubmission_nonOwnerGetsDenied() {
        Submission submission = new Submission();
        submission.setId(1L);
        submission.setUser(user);
        submission.setProblem(problem);

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
