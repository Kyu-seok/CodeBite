package com.codebite.github;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;

import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/** The Solution Commit as {@code GET /api/submissions/{id}} reports it. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class SubmissionSolutionCommitIntegrationTest {

    private static final String PATH = "two-sum-sc/python/2026-10-19T140509Z.py";

    @Autowired private MockMvc mockMvc;
    @Autowired private JwtTokenProvider jwtTokenProvider;
    @Autowired private UserRepository userRepository;
    @Autowired private ProblemRepository problemRepository;
    @Autowired private SubmissionRepository submissionRepository;
    @Autowired private GitHubLinkRepository linkRepository;
    @Autowired private SolutionCommitRepository solutionCommitRepository;

    private User user;
    private String token;
    private Submission submission;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUsername("committer");
        user.setEmail("committer@test.com");
        user.setRole(Role.USER);
        user = userRepository.save(user);
        token = jwtTokenProvider.generateToken(user);

        Problem problem = new Problem();
        problem.setTitle("Two Sum");
        problem.setSlug("two-sum-sc");
        problem.setDescription("Find two numbers.");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem = problemRepository.save(problem);

        submission = Submission.pending(user, problem, "python", "print('hi')");
        submission.grade(Verdict.empty(), List.of());
        submission = submissionRepository.save(submission);
    }

    @Test
    void submissionWithoutASolutionCommitHasNone() throws Exception {
        detail().andExpect(jsonPath("$.solutionCommit").value(nullValue()));
    }

    @Test
    void pendingSolutionCommitHasNoLinkYet() throws Exception {
        solutionCommitRepository.save(new SolutionCommit(submission.getId(), link().getId(), PATH));

        detail().andExpect(jsonPath("$.solutionCommit.status").value("PENDING"))
                .andExpect(jsonPath("$.solutionCommit.commitUrl").value(nullValue()));
    }

    @Test
    void committedSolutionCommitLinksToTheCommit() throws Exception {
        SolutionCommit sc = new SolutionCommit(submission.getId(), link().getId(), PATH);
        sc.markCommitted("abc123", "https://github.com/octocat/solutions/commit/abc123", Instant.now());
        solutionCommitRepository.save(sc);

        detail().andExpect(jsonPath("$.solutionCommit.status").value("COMMITTED"))
                .andExpect(jsonPath("$.solutionCommit.commitUrl")
                        .value("https://github.com/octocat/solutions/commit/abc123"));
    }

    @Test
    void failedSolutionCommitIsReportedWithoutALink() throws Exception {
        SolutionCommit sc = new SolutionCommit(submission.getId(), link().getId(), PATH);
        sc.markFailed("503 Service Unavailable");
        solutionCommitRepository.save(sc);

        detail().andExpect(jsonPath("$.solutionCommit.status").value("FAILED"))
                .andExpect(jsonPath("$.solutionCommit.commitUrl").value(nullValue()))
                .andExpect(jsonPath("$.status").value("ACCEPTED"));
    }

    // --- fixtures ---

    private GitHubLink link() {
        return linkRepository.saveAndFlush(new GitHubLink(user.getId(), 583231, "octocat", 77,
                1296269, "octocat/solutions", "main", false));
    }

    private ResultActions detail() throws Exception {
        return mockMvc.perform(get("/api/submissions/" + submission.getId())
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }
}
