package com.codebite.github;

import com.codebite.github.consumer.SolutionCommitListener;
import com.codebite.github.dto.GitHubLinkCallbackRequest;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.gateway.FakeGitHubGateway;
import com.codebite.github.gateway.FakeGitHubGateway.RecordedCommit;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubGatewayException;
import com.codebite.github.gateway.GitHubRepo;
import com.codebite.github.gateway.GitHubTransientException;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.github.service.GitHubLinkService;
import com.codebite.github.service.GitHubLinkStateService;
import com.codebite.github.service.SolutionCommitService;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.tuple;

/**
 * The Solution Commit listener, driven with {@code submission-results} events and observed through
 * what reached the fake GitHub.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class SolutionCommitListenerTest {

    private static final GitHubAccount OCTOCAT = new GitHubAccount(583231, "octocat");
    private static final GitHubRepo REPO = new GitHubRepo(1296269, "octocat/solutions", "main", false);
    private static final long INSTALLATION = 77;

    @Autowired private SolutionCommitService solutionCommitService;
    @Autowired private GitHubLinkService gitHubLinkService;
    @Autowired private GitHubLinkStateService gitHubLinkStateService;
    @Autowired private FakeGitHubGateway gitHub;
    @Autowired private UserRepository userRepository;
    @Autowired private ProblemRepository problemRepository;
    @Autowired private SubmissionRepository submissionRepository;
    @Autowired private GitHubLinkRepository linkRepository;
    @Autowired private SolutionCommitRepository solutionCommitRepository;
    @Autowired private EntityManager entityManager;
    @Autowired private MeterRegistry meterRegistry;

    private SolutionCommitListener listener;
    private User user;
    private Problem problem;

    @BeforeEach
    void setUp() {
        gitHub.reset();
        gitHub.install(INSTALLATION, REPO);
        listener = new SolutionCommitListener(solutionCommitService);

        user = new User();
        user.setUsername("solver");
        user.setEmail("solver@test.com");
        user.setRole(Role.USER);
        user = userRepository.save(user);

        problem = new Problem();
        problem.setTitle("Two Sum");
        problem.setSlug("two-sum-gh");
        problem.setDescription("Find two numbers. This text must never reach GitHub.");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem = problemRepository.save(problem);
    }

    @Test
    void acceptedSubmissionIsCommittedAsTheUserAtItsAcceptedTime() {
        link(user);
        Submission submission = accepted(user, "python", "print('hi')", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(acceptedEvent(submission));

        RecordedCommit commit = gitHub.commits().stream()
                .filter(c -> c.path().startsWith("two-sum-gh/python/"))
                .findFirst().orElseThrow();
        assertThat(commit.repositoryFullName()).isEqualTo("octocat/solutions");
        assertThat(commit.branch()).isEqualTo("main");
        assertThat(commit.path()).isEqualTo("two-sum-gh/python/2026-10-19T140509Z.py");
        assertThat(commit.content()).isEqualTo("print('hi')");
        assertThat(commit.authorName()).isEqualTo("octocat");
        assertThat(commit.authorEmail()).isEqualTo("583231+octocat@users.noreply.github.com");
        assertThat(commit.authorDate()).isEqualTo(Instant.parse("2026-10-19T14:05:09Z"));
        assertThat(commit.message()).isEqualTo("Accepted: Two Sum (python) · 12 ms, 1.5 MB");
    }

    @Test
    void firstCommitToAProblemFolderAddsItsReadmeFirst() {
        link(user);
        Submission first = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        Submission second = accepted(user, "java", "class A {}", Instant.parse("2026-10-20T09:00:00Z"));

        listener.onResult(acceptedEvent(first));
        listener.onResult(acceptedEvent(second));

        assertThat(gitHub.commits()).extracting(RecordedCommit::path).containsExactly(
                "two-sum-gh/README.md",
                "two-sum-gh/python/2026-10-19T140509Z.py",
                "two-sum-gh/java/2026-10-20T090000Z.java");
        RecordedCommit readme = gitHub.commits().get(0);
        assertThat(readme.content()).isEqualTo("""
                # Two Sum

                Difficulty: Easy

                [Solve it on CodeBite](https://code-bite.test/problems/two-sum-gh)
                """);
        assertThat(readme.message()).isEqualTo("Add README for Two Sum");
        assertThat(readme.authorEmail()).isEqualTo("583231+octocat@users.noreply.github.com");
        assertThat(readme.authorDate()).isEqualTo(Instant.parse("2026-10-19T14:05:09Z"));
    }

    @Test
    void readmeAlreadyInTheRepositoryIsLeftAlone() {
        // For example from an earlier link to the same repository.
        gitHub.seedFile(REPO.fullName(), "two-sum-gh/README.md", "my own notes");
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).extracting(RecordedCommit::path)
                .containsExactly("two-sum-gh/python/2026-10-19T140509Z.py");
    }

    @Test
    void submissionsThatWereNotAcceptedAreNeverCommitted() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(event(submission, SubmissionStatus.WRONG_ANSWER, false));
        listener.onResult(event(submission, SubmissionStatus.COMPILATION_ERROR, false));

        assertThat(gitHub.commits()).isEmpty();
        assertThat(solutionCommitRepository.findAll()).isEmpty();
    }

    @Test
    void userWithoutAGitHubLinkGetsNoSolutionCommit() {
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).isEmpty();
        assertThat(solutionCommitRepository.findAll()).isEmpty();
    }

    @Test
    void unlinkedUserGetsNoSolutionCommit() {
        link(user);
        gitHubLinkService.unlink(user.getId());
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).isEmpty();
        assertThat(solutionCommitRepository.findAll()).isEmpty();
    }

    @Test
    void uninstalledAppMarksTheLinkBrokenAndTheSolutionCommitFailed() {
        GitHubLink link = link(user);
        gitHub.uninstall(INSTALLATION);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        assertThatCode(() -> listener.onResult(acceptedEvent(submission))).doesNotThrowAnyException();

        assertThat(linkRepository.findById(link.getId()).orElseThrow().getStatus())
                .isEqualTo(GitHubLinkStatus.BROKEN);
        assertThat(solutionCommitRepository.findAll()).singleElement()
                .satisfies(sc -> assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.FAILED));
    }

    @Test
    void goneInstallationIsNeverRetriedAndIsCountedAsBroken() {
        link(user);
        gitHub.uninstall(INSTALLATION);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        double brokenBefore = outcomeCount("broken");
        double failedBefore = outcomeCount("failed");

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.calls()).isEqualTo(1);
        assertThat(outcomeCount("broken") - brokenBefore).isEqualTo(1);
        assertThat(outcomeCount("failed") - failedBefore).isZero();
    }

    @Test
    void deletedRepositoryMarksTheLinkBroken() {
        GitHubLink link = link(user);
        gitHub.deleteRepository(REPO.fullName());
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(acceptedEvent(submission));

        assertThat(linkRepository.findById(link.getId()).orElseThrow().getStatus())
                .isEqualTo(GitHubLinkStatus.BROKEN);
        assertThat(solutionCommitRepository.findAll()).singleElement()
                .satisfies(sc -> assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.FAILED));
    }

    @Test
    void brokenLinkSkipsLaterSubmissionsWithoutCallingGitHub() {
        link(user);
        gitHub.uninstall(INSTALLATION);
        listener.onResult(acceptedEvent(accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"))));
        int callsWhileBreaking = gitHub.calls();

        listener.onResult(acceptedEvent(accepted(user, "java", "class A {}", Instant.parse("2026-10-20T09:00:00Z"))));

        assertThat(gitHub.calls()).isEqualTo(callsWhileBreaking);
        assertThat(solutionCommitRepository.findAll()).hasSize(1);
    }

    @Test
    void relinkingAfterABrokenLinkRestoresSolutionCommits() {
        link(user);
        gitHub.uninstall(INSTALLATION);
        listener.onResult(acceptedEvent(accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"))));

        // The user installs the App again (a new installation) and finishes the relink.
        gitHub.authorize("relink-code", OCTOCAT, 88);
        gitHub.install(88, REPO);
        gitHubLinkService.completeInstall(user.getId(),
                new GitHubLinkCallbackRequest("relink-code", 88L, gitHubLinkStateService.issue(user.getId())));
        listener.onResult(acceptedEvent(accepted(user, "java", "class A {}", Instant.parse("2026-10-20T09:00:00Z"))));

        assertThat(gitHub.commits()).extracting(RecordedCommit::installationId, RecordedCommit::path)
                .contains(tuple(88L, "two-sum-gh/java/2026-10-20T090000Z.java"));
        assertThat(linkRepository.findCurrentByUserId(user.getId()).orElseThrow().getStatus())
                .isEqualTo(GitHubLinkStatus.ACTIVE);
    }

    @Test
    void adminSubmissionsAreCommittedLikeAnyoneElses() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(event(submission, SubmissionStatus.ACCEPTED, true));

        assertThat(gitHub.commits()).extracting(RecordedCommit::path)
                .contains("two-sum-gh/python/2026-10-19T140509Z.py");
    }

    @Test
    void redeliveredEventCommitsOnlyOnce() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(acceptedEvent(submission));
        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).extracting(RecordedCommit::path).containsExactly(
                "two-sum-gh/README.md", "two-sum-gh/python/2026-10-19T140509Z.py");
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitSha()).isEqualTo(gitHub.commits().get(1).sha());
            assertThat(sc.getCommitUrl()).isEqualTo(
                    "https://github.com/octocat/solutions/commit/" + gitHub.commits().get(1).sha());
            assertThat(sc.getPath()).isEqualTo("two-sum-gh/python/2026-10-19T140509Z.py");
            assertThat(sc.getAttempts()).isEqualTo(1);
        });
    }

    @Test
    void identicalCodeAcceptedTwiceMakesTwoFiles() {
        link(user);
        Submission first = accepted(user, "python", "same = 1", Instant.parse("2026-10-19T14:05:09Z"));
        Submission second = accepted(user, "python", "same = 1", Instant.parse("2026-10-19T14:07:30Z"));

        listener.onResult(acceptedEvent(first));
        listener.onResult(acceptedEvent(second));

        assertThat(gitHub.commits()).filteredOn(c -> c.path().contains("/python/"))
                .extracting(RecordedCommit::path, RecordedCommit::content)
                .containsExactly(
                        tuple("two-sum-gh/python/2026-10-19T140509Z.py", "same = 1"),
                        tuple("two-sum-gh/python/2026-10-19T140730Z.py", "same = 1"));
    }

    @Test
    void acceptedJustAfterUtcMidnightIsNamedForTheNewDay() {
        link(user);
        // 09:00:30 on the 20th in Seoul, where the test JVM may well run, but 00:00:30 UTC.
        Submission submission = accepted(user, "cpp", "int main() {}", Instant.parse("2026-10-20T00:00:30Z"));

        listener.onResult(acceptedEvent(submission));

        RecordedCommit commit = gitHub.commits().get(gitHub.commits().size() - 1);
        assertThat(commit.path()).isEqualTo("two-sum-gh/cpp/2026-10-20T000030Z.cpp");
        assertThat(commit.authorDate()).isEqualTo(Instant.parse("2026-10-20T00:00:30Z"));
    }

    @Test
    void briefGitHubOutageIsRetriedAndTheSolutionCommitted() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        gitHub.failNext(new GitHubTransientException("502 Bad Gateway"),
                new GitHubTransientException("503 Service Unavailable"));

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).extracting(RecordedCommit::path).containsExactly(
                "two-sum-gh/README.md", "two-sum-gh/python/2026-10-19T140509Z.py");
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitSha()).isEqualTo(gitHub.commits().get(1).sha());
            assertThat(sc.getLastError()).isNull();
        });
    }

    @Test
    void retriesRunningOutLeaveTheSolutionCommitFailed() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        gitHub.failNext(new GitHubTransientException("502 Bad Gateway"),
                new GitHubTransientException("502 Bad Gateway"),
                new GitHubTransientException("503 still down"));

        assertThatCode(() -> listener.onResult(acceptedEvent(submission))).doesNotThrowAnyException();

        assertThat(gitHub.commits()).isEmpty();
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.FAILED);
            assertThat(sc.getLastError()).isEqualTo("503 still down");
        });
    }

    @Test
    void permanentGitHubErrorIsNotRetried() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        gitHub.failNext(new GitHubGatewayException("422 Unprocessable Entity"));

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).isEmpty();
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.FAILED);
            assertThat(sc.getLastError()).isEqualTo("422 Unprocessable Entity");
        });
    }

    @Test
    void solutionThatLandedWhenItsResponseWasLostCountsAsCommitted() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        gitHub.loseResponseTo("two-sum-gh/python/2026-10-19T140509Z.py");

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).extracting(RecordedCommit::path).containsExactly(
                "two-sum-gh/README.md", "two-sum-gh/python/2026-10-19T140509Z.py");
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitUrl()).isEqualTo(
                    "https://github.com/octocat/solutions/blob/main/two-sum-gh/python/2026-10-19T140509Z.py");
        });
    }

    @Test
    void solutionPathTakenBeforeTheFirstAttemptGoesToItsOwnFile() {
        gitHub.seedFile(REPO.fullName(), "two-sum-gh/python/2026-10-19T140509Z.py", "someone else's file");
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));

        listener.onResult(acceptedEvent(submission));

        String ownPath = "two-sum-gh/python/2026-10-19T140509Z-" + submission.getId() + ".py";
        assertThat(committedFiles()).containsEntry(ownPath, "a = 1")
                .doesNotContainEntry("two-sum-gh/python/2026-10-19T140509Z.py", "a = 1");
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getPath()).isEqualTo(ownPath);
        });
    }

    @Test
    void twoSolutionsAcceptedInTheSameSecondAreBothKept() {
        link(user);
        Instant sameSecond = Instant.parse("2026-10-19T14:05:09Z");
        Submission first = accepted(user, "python", "first = 1", sameSecond);
        Submission second = accepted(user, "python", "second = 2", sameSecond);

        listener.onResult(acceptedEvent(first));
        listener.onResult(acceptedEvent(second));

        String secondPath = "two-sum-gh/python/2026-10-19T140509Z-" + second.getId() + ".py";
        assertThat(committedFiles())
                .containsEntry("two-sum-gh/python/2026-10-19T140509Z.py", "first = 1")
                .containsEntry(secondPath, "second = 2");
        assertThat(solutionCommitRepository.findAll())
                .extracting(sc -> sc.getStatus(), sc -> sc.getPath())
                .containsExactlyInAnyOrder(
                        tuple(SolutionCommitStatus.COMMITTED, "two-sum-gh/python/2026-10-19T140509Z.py"),
                        tuple(SolutionCommitStatus.COMMITTED, secondPath));
    }

    @Test
    void outcomesAreCountedForMetrics() {
        link(user);
        Submission ok = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        Submission bad = accepted(user, "java", "class A {}", Instant.parse("2026-10-19T15:00:00Z"));
        double committedBefore = outcomeCount("committed");
        double failedBefore = outcomeCount("failed");

        listener.onResult(acceptedEvent(ok));
        gitHub.failAlways(() -> new GitHubTransientException("GitHub is down"));
        listener.onResult(acceptedEvent(bad));

        assertThat(outcomeCount("committed") - committedBefore).isEqualTo(1);
        assertThat(outcomeCount("failed") - failedBefore).isEqualTo(1);
    }

    @Test
    void gitHubFailureIsRecordedAndNeverThrown() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        gitHub.failAlways(() -> new GitHubTransientException("GitHub is down"));

        assertThatCode(() -> listener.onResult(acceptedEvent(submission))).doesNotThrowAnyException();

        assertThat(gitHub.commits()).isEmpty();
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.FAILED);
            assertThat(sc.getLastError()).contains("GitHub is down");
            assertThat(sc.getAttempts()).isEqualTo(1);
        });
    }

    @Test
    void redeliveryAfterAFailureTriesAgain() {
        link(user);
        Submission submission = accepted(user, "python", "a = 1", Instant.parse("2026-10-19T14:05:09Z"));
        gitHub.failAlways(() -> new GitHubTransientException("GitHub is down"));
        listener.onResult(acceptedEvent(submission));
        gitHub.recover();

        listener.onResult(acceptedEvent(submission));

        assertThat(gitHub.commits()).extracting(RecordedCommit::path).containsExactly(
                "two-sum-gh/README.md", "two-sum-gh/python/2026-10-19T140509Z.py");
        assertThat(solutionCommitRepository.findAll()).singleElement().satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getAttempts()).isEqualTo(2);
        });
    }

    // --- fixtures ---

    /** Every file the Solution Commits added, by path, however they were committed. */
    private java.util.Map<String, String> committedFiles() {
        java.util.Map<String, String> files = new java.util.LinkedHashMap<>();
        gitHub.history().forEach(c -> files.putAll(c.files()));
        return files;
    }

    private double outcomeCount(String outcome) {
        Counter counter = meterRegistry.find("codebite.solution.commits").tag("outcome", outcome).counter();
        return counter == null ? 0 : counter.count();
    }

    private GitHubLink link(User owner) {
        return linkRepository.saveAndFlush(new GitHubLink(owner.getId(), OCTOCAT.id(), OCTOCAT.login(),
                INSTALLATION, REPO.id(), REPO.fullName(), REPO.defaultBranch(), REPO.isPrivate()));
    }

    /** An Accepted submission (12 ms, 1536 KB) made at {@code at}. */
    private Submission accepted(User owner, String language, String code, Instant at) {
        Submission submission = new Submission();
        submission.setUser(owner);
        submission.setProblem(problem);
        submission.setLanguage(language);
        submission.setSourceCode(code);
        submission.setStatus(SubmissionStatus.ACCEPTED);
        submission.setRuntimeMs(12);
        submission.setMemoryKb(1536);
        submission = submissionRepository.saveAndFlush(submission);

        // created_at is set on insert and not updatable through the entity, so backdate it in SQL.
        entityManager.createQuery("UPDATE Submission s SET s.createdAt = :at WHERE s.id = :id")
                .setParameter("at", at)
                .setParameter("id", submission.getId())
                .executeUpdate();
        entityManager.clear();
        return submission;
    }

    private SubmissionResultEvent acceptedEvent(Submission submission) {
        return event(submission, SubmissionStatus.ACCEPTED, false);
    }

    private SubmissionResultEvent event(Submission submission, SubmissionStatus status, boolean admin) {
        return new SubmissionResultEvent(submission.getId(), submission.getUser().getId(),
                problem.getId(), status, 12, 1536, submission.getLanguage(), admin);
    }
}
