package com.codebite.github;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.github.gateway.FakeGitHubGateway;
import com.codebite.github.gateway.FakeGitHubGateway.RecordedBatchCommit;
import com.codebite.github.gateway.FakeGitHubGateway.RecordedCommit;
import com.codebite.github.gateway.GitHubTransientException;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.github.service.GitHubImportService;
import com.codebite.github.service.SolutionCommitService;
import com.codebite.github.gateway.FakeGitHubGateway.RecordedPush;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubRepo;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

import java.time.Instant;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Import ({@code POST /api/github/link/import}) through the API, observed through what reached the
 * fake GitHub. Kafka is off in tests, so the test publisher runs the Import synchronously.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class GitHubImportIntegrationTest {

    private static final GitHubAccount OCTOCAT = new GitHubAccount(583231, "octocat");
    private static final long INSTALLATION = 77;
    private static final String NOREPLY = "583231+octocat@users.noreply.github.com";

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private JwtTokenProvider jwtTokenProvider;
    @Autowired private FakeGitHubGateway gitHub;
    @Autowired private UserRepository userRepository;
    @Autowired private ProblemRepository problemRepository;
    @Autowired private SubmissionRepository submissionRepository;
    @Autowired private EntityManager entityManager;
    @Autowired private SolutionCommitService solutionCommitService;
    @Autowired private MeterRegistry meterRegistry;
    @Autowired private GitHubImportService gitHubImportService;
    @Autowired private SolutionCommitRepository solutionCommitRepository;

    private User user;
    private String token;
    private Problem twoSum;
    private Problem lruCache;

    @BeforeEach
    void setUp() {
        gitHub.reset();
        user = saveUser("importer", Role.USER);
        token = jwtTokenProvider.generateToken(user);
        twoSum = saveProblem("Two Sum", "two-sum-imp", Difficulty.EASY);
        lruCache = saveProblem("LRU Cache", "lru-cache-imp", Difficulty.MEDIUM);
    }

    @Test
    void importPushesEarlierAcceptedSubmissionsOldestFirstInOneBatch() throws Exception {
        submit(user, lruCache, "cpp", "int main() {}", SubmissionStatus.ACCEPTED, "2026-05-10T08:30:00Z");
        submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED, "2026-03-01T23:59:59Z");
        submit(user, twoSum, "java", "class A {}", SubmissionStatus.WRONG_ANSWER, "2026-03-01T12:00:00Z");
        Submission admin = submit(user, twoSum, "java", "class B {}", SubmissionStatus.ACCEPTED, "2026-03-02T00:00:01Z");
        markAdminSubmission(admin);
        submit(saveUser("someone-else", Role.USER), twoSum, "python", "print(2)", SubmissionStatus.ACCEPTED,
                "2026-03-03T00:00:00Z");
        link("octocat/solutions");

        startImport().andExpect(status().isAccepted())
                .andExpect(jsonPath("$.importState").value("RUNNING"));

        assertThat(gitHub.pushes()).hasSize(1);
        RecordedPush push = gitHub.pushes().get(0);
        assertThat(push.repositoryFullName()).isEqualTo("octocat/solutions");
        assertThat(push.branch()).isEqualTo("main");
        assertThat(push.installationId()).isEqualTo(INSTALLATION);
        assertThat(push.commits()).extracting(RecordedBatchCommit::files).containsExactly(
                Map.of("two-sum-imp/README.md", """
                                # Two Sum

                                Difficulty: Easy

                                [Solve it on CodeBite](https://code-bite.test/problems/two-sum-imp)
                                """,
                        "two-sum-imp/python/2026-03-01T235959Z.py", "print(1)"),
                Map.of("two-sum-imp/java/2026-03-02T000001Z.java", "class B {}"),
                Map.of("lru-cache-imp/README.md", """
                                # LRU Cache

                                Difficulty: Medium

                                [Solve it on CodeBite](https://code-bite.test/problems/lru-cache-imp)
                                """,
                        "lru-cache-imp/cpp/2026-05-10T083000Z.cpp", "int main() {}"));
        assertThat(push.commits()).extracting(RecordedBatchCommit::message).containsExactly(
                "Accepted: Two Sum (python) · 12 ms, 1.5 MB",
                "Accepted: Two Sum (java) · 12 ms, 1.5 MB",
                "Accepted: LRU Cache (cpp) · 12 ms, 1.5 MB");
        assertThat(push.commits()).extracting(RecordedBatchCommit::authorDate).containsExactly(
                Instant.parse("2026-03-01T23:59:59Z"),
                Instant.parse("2026-03-02T00:00:01Z"),
                Instant.parse("2026-05-10T08:30:00Z"));
        assertThat(push.commits()).allSatisfy(c -> {
            assertThat(c.authorName()).isEqualTo("octocat");
            assertThat(c.authorEmail()).isEqualTo(NOREPLY);
        });

        getLink().andExpect(jsonPath("$.importState").value("DONE"));
    }

    @Test
    void importExcludesSubmissionsAfterTheLinkAndThoseAlreadyCommitted() throws Exception {
        Submission committedLive = submit(user, twoSum, "python", "print('live')", SubmissionStatus.ACCEPTED,
                "2026-03-01T10:00:00Z");
        submit(user, twoSum, "java", "class Earlier {}", SubmissionStatus.ACCEPTED, "2026-04-01T10:00:00Z");
        link("octocat/solutions");
        linkCreatedAt("2026-06-01T00:00:00Z");
        submit(user, twoSum, "cpp", "int after() {}", SubmissionStatus.ACCEPTED, "2026-07-01T10:00:00Z");
        // A submission accepted just before linking whose event arrived after it: committed live.
        solutionCommitService.commitAccepted(user.getId(), committedLive.getId());
        assertThat(gitHub.commits()).extracting(RecordedCommit::path)
                .containsExactly("two-sum-imp/README.md", "two-sum-imp/python/2026-03-01T100000Z.py");

        startImport().andExpect(status().isAccepted());

        assertThat(gitHub.pushes()).hasSize(1);
        // The folder was already started through this link, so no second README.
        assertThat(gitHub.pushes().get(0).commits()).extracting(RecordedBatchCommit::files).containsExactly(
                Map.of("two-sum-imp/java/2026-04-01T100000Z.java", "class Earlier {}"));
        getLink().andExpect(jsonPath("$.importState").value("DONE"));
    }

    @Test
    void importedSolutionsCountAsCommittedForLaterLiveCommits() throws Exception {
        submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED, "2026-03-01T10:00:00Z");
        link("octocat/solutions");
        startImport().andExpect(status().isAccepted());
        Submission later = submit(user, twoSum, "java", "class Later {}", SubmissionStatus.ACCEPTED,
                "2026-10-20T10:00:00Z");

        solutionCommitService.commitAccepted(user.getId(), later.getId());

        // The Import already added the folder's README, so the live commit adds only its file.
        assertThat(gitHub.commits()).extracting(RecordedCommit::path)
                .containsExactly("two-sum-imp/java/2026-10-20T100000Z.java");
    }

    @Test
    void liveEventForAnImportedSubmissionLeavesItCommitted() throws Exception {
        Submission imported = submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED,
                "2026-03-01T10:00:00Z");
        link("octocat/solutions");
        startImport().andExpect(status().isAccepted());
        String importedUrl = solutionCommitOf(imported).getCommitUrl();

        solutionCommitService.commitAccepted(user.getId(), imported.getId());

        assertThat(solutionCommitOf(imported)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitUrl()).isEqualTo(importedUrl).isNotNull();
        });
        assertThat(gitHub.history()).hasSize(1);
    }

    @Test
    void importLandingWhileALiveCommitIsInFlightLeavesItCommitted() throws Exception {
        Submission earlier = submit(user, twoSum, "java", "class A {}", SubmissionStatus.ACCEPTED,
                "2026-02-01T10:00:00Z");
        Submission racing = submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED,
                "2026-03-01T10:00:00Z");
        link("octocat/solutions");
        // The folder is started, so the live commit adds just its file.
        solutionCommitService.commitAccepted(user.getId(), earlier.getId());
        gitHub.beforeNextCommit(() -> gitHubImportService.start(user.getId()));

        solutionCommitService.commitAccepted(user.getId(), racing.getId());

        assertThat(gitHub.pushes()).hasSize(1);
        assertThat(solutionCommitOf(racing)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitUrl()).isEqualTo(
                    "https://github.com/octocat/solutions/commit/" + gitHub.pushes().get(0).commits().get(0).sha());
        });
    }

    @Test
    void importLandingWhileAFolderStartingLiveCommitIsInFlightLeavesItCommitted() throws Exception {
        Submission racing = submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED,
                "2026-03-01T10:00:00Z");
        link("octocat/solutions");
        gitHub.beforeNextCommit(() -> gitHubImportService.start(user.getId()));

        solutionCommitService.commitAccepted(user.getId(), racing.getId());

        assertThat(gitHub.history()).hasSize(1);
        assertThat(solutionCommitOf(racing)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitUrl()).isEqualTo(
                    "https://github.com/octocat/solutions/commit/" + gitHub.history().get(0).sha());
        });
    }

    @Test
    void importIsNotReRunnableOnceDone() throws Exception {
        submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED, "2026-03-01T10:00:00Z");
        link("octocat/solutions");
        startImport().andExpect(status().isAccepted());

        startImport().andExpect(status().isConflict());

        assertThat(gitHub.pushes()).hasSize(1);
        getLink().andExpect(jsonPath("$.importState").value("DONE"));
    }

    @Test
    void runningImportCannotBeStartedAgain() throws Exception {
        link("octocat/solutions");
        entityManager.createQuery("UPDATE GitHubLink l SET l.importState = "
                        + "com.codebite.github.entity.GitHubImportState.RUNNING WHERE l.userId = :userId")
                .setParameter("userId", user.getId())
                .executeUpdate();
        entityManager.clear();

        startImport().andExpect(status().isConflict());

        assertThat(gitHub.pushes()).isEmpty();
    }

    @Test
    void failedImportCanBeRetried() throws Exception {
        submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED, "2026-03-01T10:00:00Z");
        submit(user, lruCache, "cpp", "int main() {}", SubmissionStatus.ACCEPTED, "2026-03-02T10:00:00Z");
        link("octocat/solutions");
        gitHub.failNext(new GitHubTransientException("GitHub is down"));

        startImport().andExpect(status().isAccepted());

        assertThat(gitHub.pushes()).isEmpty();
        getLink().andExpect(jsonPath("$.importState").value("FAILED"));

        startImport().andExpect(status().isAccepted());

        assertThat(gitHub.pushes()).hasSize(1);
        assertThat(gitHub.pushes().get(0).commits()).hasSize(2);
        getLink().andExpect(jsonPath("$.importState").value("DONE"));
    }

    @Test
    void relinkedRepositoryIsOfferedImportAgain() throws Exception {
        submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED, "2026-03-01T10:00:00Z");
        link("octocat/solutions");
        startImport().andExpect(status().isAccepted());

        link("octocat/new-solutions");
        getLink().andExpect(jsonPath("$.importState").value("AVAILABLE"));
        startImport().andExpect(status().isAccepted());

        assertThat(gitHub.pushes()).extracting(RecordedPush::repositoryFullName)
                .containsExactly("octocat/solutions", "octocat/new-solutions");
        assertThat(gitHub.pushes().get(1).commits()).extracting(RecordedBatchCommit::files).containsExactly(
                Map.of("two-sum-imp/README.md", gitHub.pushes().get(0).commits().get(0).files().get("two-sum-imp/README.md"),
                        "two-sum-imp/python/2026-03-01T100000Z.py", "print(1)"));
        getLink().andExpect(jsonPath("$.importState").value("DONE"));
    }

    @Test
    void importWithNothingEarlierFinishesWithoutPushing() throws Exception {
        link("octocat/solutions");

        startImport().andExpect(status().isAccepted());

        assertThat(gitHub.pushes()).isEmpty();
        getLink().andExpect(jsonPath("$.importState").value("DONE"));
    }

    @Test
    void uninstalledAppMarksTheLinkBrokenAndTheImportFailed() throws Exception {
        submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED, "2026-03-01T10:00:00Z");
        link("octocat/solutions");
        gitHub.uninstall(INSTALLATION);
        double brokenBefore = solutionCommits("broken");

        startImport().andExpect(status().isAccepted());

        assertThat(gitHub.pushes()).isEmpty();
        getLink().andExpect(jsonPath("$.status").value("BROKEN"))
                .andExpect(jsonPath("$.importState").value("FAILED"));
        assertThat(solutionCommits("broken") - brokenBefore).isEqualTo(1);
    }

    @Test
    void brokenLinkCannotStartAnImport() throws Exception {
        link("octocat/solutions");
        entityManager.createQuery("UPDATE GitHubLink l SET l.status = "
                        + "com.codebite.github.entity.GitHubLinkStatus.BROKEN WHERE l.userId = :userId")
                .setParameter("userId", user.getId())
                .executeUpdate();
        entityManager.clear();
        gitHub.uninstall(INSTALLATION);

        startImport().andExpect(status().isConflict());

        assertThat(gitHub.pushes()).isEmpty();
    }

    @Test
    void importCountsEachSolutionCommit() throws Exception {
        submit(user, twoSum, "python", "print(1)", SubmissionStatus.ACCEPTED, "2026-03-01T10:00:00Z");
        submit(user, lruCache, "cpp", "int main() {}", SubmissionStatus.ACCEPTED, "2026-03-02T10:00:00Z");
        link("octocat/solutions");
        double committedBefore = solutionCommits("committed");
        double failedBefore = solutionCommits("failed");
        gitHub.failNext(new GitHubTransientException("GitHub is down"));

        startImport().andExpect(status().isAccepted());
        assertThat(solutionCommits("failed") - failedBefore).isEqualTo(2);

        startImport().andExpect(status().isAccepted());
        assertThat(solutionCommits("committed") - committedBefore).isEqualTo(2);
    }

    @Test
    void importWithoutALinkIsNotFound() throws Exception {
        startImport().andExpect(status().isNotFound());
    }

    @Test
    void importRequiresAuth() throws Exception {
        mockMvc.perform(post("/api/github/link/import")).andExpect(status().isUnauthorized());
    }

    // --- helpers ---

    private SolutionCommit solutionCommitOf(Submission submission) {
        entityManager.flush();
        entityManager.clear();
        return solutionCommitRepository.findFirstBySubmissionIdOrderByIdDesc(submission.getId()).orElseThrow();
    }

    private double solutionCommits(String outcome) {
        Counter counter = meterRegistry.find("codebite.solution.commits").tag("outcome", outcome).counter();
        return counter == null ? 0 : counter.count();
    }

    private void linkCreatedAt(String at) {
        entityManager.createQuery("UPDATE GitHubLink l SET l.createdAt = :at WHERE l.userId = :userId")
                .setParameter("at", Instant.parse(at))
                .setParameter("userId", user.getId())
                .executeUpdate();
        entityManager.clear();
    }

    private ResultActions startImport() throws Exception {
        return mockMvc.perform(post("/api/github/link/import").header("Authorization", "Bearer " + token));
    }

    private ResultActions getLink() throws Exception {
        return mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    /** Links {@code fullName} through the install callback, as the user would. */
    private void link(String fullName) throws Exception {
        gitHub.authorize("code-" + fullName, OCTOCAT, INSTALLATION);
        gitHub.install(INSTALLATION, new GitHubRepo(fullName.hashCode(), fullName, "main", false));
        mockMvc.perform(post("/api/github/link/callback")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(Map.of(
                                "code", "code-" + fullName, "installationId", INSTALLATION, "state", state()))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.link.repositoryFullName").value(fullName));
    }

    private String state() throws Exception {
        String body = mockMvc.perform(get("/api/github/link/install").header("Authorization", "Bearer " + token))
                .andReturn().getResponse().getContentAsString();
        String installUrl = objectMapper.readTree(body).get("installUrl").asText();
        return UriComponentsBuilder.fromUriString(installUrl).build().getQueryParams().getFirst("state");
    }

    /** A graded submission (12 ms, 1536 KB) made at {@code at}. */
    private Submission submit(User owner, Problem problem, String language, String code,
                              SubmissionStatus status, String at) {
        Submission submission = new Submission();
        submission.setUser(owner);
        submission.setProblem(problem);
        submission.setLanguage(language);
        submission.setSourceCode(code);
        submission.setStatus(status);
        submission.setRuntimeMs(12);
        submission.setMemoryKb(1536);
        submission = submissionRepository.saveAndFlush(submission);
        // created_at is set on insert and not updatable through the entity, so backdate it in SQL.
        entityManager.createQuery("UPDATE Submission s SET s.createdAt = :at WHERE s.id = :id")
                .setParameter("at", Instant.parse(at))
                .setParameter("id", submission.getId())
                .executeUpdate();
        entityManager.clear();
        return submission;
    }

    private void markAdminSubmission(Submission submission) {
        entityManager.createQuery("UPDATE Submission s SET s.adminSubmission = true WHERE s.id = :id")
                .setParameter("id", submission.getId())
                .executeUpdate();
        entityManager.clear();
    }

    private User saveUser(String username, Role role) {
        User u = new User();
        u.setUsername(username);
        u.setEmail(username + "@test.com");
        u.setRole(role);
        return userRepository.save(u);
    }

    private Problem saveProblem(String title, String slug, Difficulty difficulty) {
        Problem problem = new Problem();
        problem.setTitle(title);
        problem.setSlug(slug);
        problem.setDescription("Never reaches GitHub.");
        problem.setDifficulty(difficulty);
        problem.setPublished(true);
        return problemRepository.save(problem);
    }
}
