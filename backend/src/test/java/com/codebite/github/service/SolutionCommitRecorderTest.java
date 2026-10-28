package com.codebite.github.service;

import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubInstallationGoneException;
import com.codebite.github.gateway.GitHubTransientException;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Supplier;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.assertj.core.api.Assertions.tuple;

/**
 * The rules {@link SolutionCommitRecorder} owns for live Solution Commits and Imports alike, at its
 * interface: {@code plan} and {@code record}, with no GitHub involved.
 *
 * <p>Not {@code @Transactional}: the recorder opens its own transactions, and the test checks what
 * they leave behind (including after a failure inside one), so it cleans up its own rows instead.
 */
@SpringBootTest
@ActiveProfiles("test")
class SolutionCommitRecorderTest {

    private static final String README = """
            # Two Sum

            Difficulty: Easy

            [Solve it on CodeBite](https://code-bite.test/problems/two-sum-rec)
            """;

    @Autowired private SolutionCommitRecorder recorder;
    @Autowired private UserRepository userRepository;
    @Autowired private ProblemRepository problemRepository;
    @Autowired private SubmissionRepository submissionRepository;
    @Autowired private GitHubLinkRepository linkRepository;
    @Autowired private SolutionCommitRepository solutionCommitRepository;
    @Autowired private EntityManager entityManager;
    @Autowired private MeterRegistry meterRegistry;
    @Autowired private PlatformTransactionManager transactionManager;

    private TransactionTemplate tx;
    private User user;
    private Problem twoSum;
    private Problem lruCache;
    private GitHubLink link;
    private final List<GitHubLink> links = new ArrayList<>();
    private final List<Submission> submissions = new ArrayList<>();

    @BeforeEach
    void setUp() {
        tx = new TransactionTemplate(transactionManager);
        user = inTx(() -> {
            User u = new User();
            u.setUsername("recorder-user");
            u.setEmail("recorder-user@test.com");
            u.setRole(Role.USER);
            return userRepository.save(u);
        });
        twoSum = saveProblem("Two Sum", "two-sum-rec", Difficulty.EASY);
        lruCache = saveProblem("LRU Cache", "lru-cache-rec", Difficulty.MEDIUM);
        link = link("octocat/solutions");
    }

    @AfterEach
    void cleanUp() {
        inTx(() -> {
            List<Long> linkIds = links.stream().map(GitHubLink::getId).toList();
            solutionCommitRepository.findAll().stream()
                    .filter(sc -> linkIds.contains(sc.getGithubLinkId()))
                    .forEach(solutionCommitRepository::delete);
            links.forEach(l -> linkRepository.deleteById(l.getId()));
            submissions.forEach(s -> submissionRepository.deleteById(s.getId()));
            problemRepository.deleteById(twoSum.getId());
            problemRepository.deleteById(lruCache.getId());
            userRepository.deleteById(user.getId());
            return null;
        });
    }

    // --- plan ---

    @Test
    void planGivesEachProblemFolderItsReadmeOnceWithinOnePlanInSubmissionOrder() {
        Submission first = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Submission second = accepted(twoSum, "java", "class A {}", "2026-03-02T10:00:00Z");
        Submission other = accepted(lruCache, "cpp", "int main() {}", "2026-03-03T10:00:00Z");

        Plan plan = recorder.plan(link, List.of(first, second, other));

        assertThat(plan.linkId()).isEqualTo(link.getId());
        assertThat(plan.installationId()).isEqualTo(77);
        assertThat(plan.repositoryFullName()).isEqualTo("octocat/solutions");
        assertThat(plan.branch()).isEqualTo("main");
        assertThat(plan.commits()).extracting(PlannedCommit::hasReadme).containsExactly(true, false, true);
        assertThat(files(plan.commits().get(0))).containsExactly(
                Map.entry("two-sum-rec/README.md", README),
                Map.entry("two-sum-rec/python/2026-03-01T100000Z.py", "print(1)"));
        assertThat(files(plan.commits().get(1))).containsExactly(
                Map.entry("two-sum-rec/java/2026-03-02T100000Z.java", "class A {}"));
        assertThat(plan.commits().get(2).commit().files().get(0).path()).isEqualTo("lru-cache-rec/README.md");
        assertThat(plan.commits()).extracting(PlannedCommit::attemptedBefore).containsOnly(false);
        assertThat(plan.commits()).extracting(PlannedCommit::solutionCommitId)
                .containsExactly(row(first).getId(), row(second).getId(), row(other).getId());
        assertThat(plan.commits().get(0).commit().message()).isEqualTo("Accepted: Two Sum (python) · 12 ms, 1.5 MB");
        assertThat(plan.commits().get(0).commit().authorDate()).isEqualTo(Instant.parse("2026-03-01T10:00:00Z"));
        assertThat(plan.commits().get(0).commit().author().noreplyEmail())
                .isEqualTo("583231+octocat@users.noreply.github.com");
    }

    @Test
    void folderCommittedByAnEarlierPlanGetsNoSecondReadme() {
        Submission first = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan earlier = recorder.plan(link, List.of(first));
        recorder.record(earlier, earlier.commits(), committed(earlier));
        Submission later = accepted(twoSum, "java", "class A {}", "2026-10-20T10:00:00Z");

        Plan plan = recorder.plan(link, List.of(later));

        assertThat(plan.commits()).singleElement().satisfies(pc -> {
            assertThat(pc.hasReadme()).isFalse();
            assertThat(pc.solutionPath()).isEqualTo("two-sum-rec/java/2026-10-20T100000Z.java");
        });
    }

    @Test
    void readmeIsPlannedAgainAfterAFailedFirstAttemptButNotAfterACommittedOne() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan first = recorder.plan(link, List.of(submission));
        recorder.record(first, first.commits(), new Outcome.Failed(new GitHubTransientException("down")));

        Plan second = recorder.plan(link, List.of(submission));
        assertThat(second.commits()).singleElement().satisfies(pc -> {
            assertThat(pc.hasReadme()).isTrue();
            assertThat(pc.attemptedBefore()).isTrue();
            assertThat(pc.solutionCommitId()).isEqualTo(first.commits().get(0).solutionCommitId());
        });

        recorder.record(second, second.commits(), committed(second));
        Submission next = accepted(twoSum, "java", "class A {}", "2026-03-02T10:00:00Z");
        assertThat(recorder.plan(link, List.of(next)).commits()).singleElement()
                .satisfies(pc -> assertThat(pc.hasReadme()).isFalse());
    }

    @Test
    void folderCommittedThroughAnEarlierLinkStillGetsItsReadmeThroughANewOne() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan throughOld = recorder.plan(link, List.of(submission));
        recorder.record(throughOld, throughOld.commits(), committed(throughOld));
        inTx(() -> {
            linkRepository.findById(link.getId()).orElseThrow().unlink(Instant.now());
            return null;
        });
        GitHubLink newLink = link("octocat/new-solutions");

        Plan plan = recorder.plan(newLink, List.of(submission));

        assertThat(plan.repositoryFullName()).isEqualTo("octocat/new-solutions");
        assertThat(plan.commits()).singleElement().satisfies(pc -> {
            assertThat(pc.hasReadme()).isTrue();
            assertThat(pc.attemptedBefore()).isFalse();
            assertThat(pc.solutionCommitId()).isNotEqualTo(throughOld.commits().get(0).solutionCommitId());
        });
    }

    @Test
    void submissionsAlreadyCommittedThroughTheLinkAreDropped() {
        Submission imported = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Submission fresh = accepted(twoSum, "java", "class A {}", "2026-03-02T10:00:00Z");
        Plan earlier = recorder.plan(link, List.of(imported));
        recorder.record(earlier, earlier.commits(), committed(earlier));

        assertThat(recorder.plan(link, List.of(imported)).isEmpty()).isTrue();
        assertThat(recorder.plan(link, List.of(imported, fresh)).commits())
                .extracting(PlannedCommit::solutionPath)
                .containsExactly("two-sum-rec/java/2026-03-02T100000Z.java");
        assertThat(row(imported).getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
    }

    @Test
    void secondSolutionAcceptedInTheSameSecondGetsItsOwnPath() {
        Submission first = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Submission second = accepted(twoSum, "python", "print(2)", "2026-03-01T10:00:00Z");

        Plan plan = recorder.plan(link, List.of(first, second));

        String secondPath = "two-sum-rec/python/2026-03-01T100000Z-" + second.getId() + ".py";
        assertThat(plan.commits()).extracting(PlannedCommit::solutionPath, PlannedCommit::disambiguated)
                .containsExactly(
                        tuple("two-sum-rec/python/2026-03-01T100000Z.py", false),
                        tuple(secondPath, true));
        assertThat(plan.commits().get(1).disambiguatedPath()).isEqualTo(secondPath);
        assertThat(row(second).getPath()).isEqualTo(secondPath);
        // Planning again finds the rows, so the paths stay put.
        assertThat(recorder.plan(link, List.of(second, first)).commits()).extracting(PlannedCommit::solutionPath)
                .containsExactly(secondPath, "two-sum-rec/python/2026-03-01T100000Z.py");
    }

    @Test
    void plannedCommitMovedToItsOwnPathDropsTheReadme() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        PlannedCommit planned = recorder.plan(link, List.of(submission)).commits().get(0);
        assertThat(planned.hasReadme()).isTrue();
        assertThat(planned.asSingleFile().path()).isEqualTo("two-sum-rec/python/2026-03-01T100000Z.py");
        assertThat(planned.asSingleFile().content()).isEqualTo("print(1)");

        PlannedCommit moved = planned.movedTo(planned.disambiguatedPath());

        assertThat(moved.hasReadme()).isFalse();
        assertThat(moved.disambiguated()).isTrue();
        assertThat(files(moved)).containsExactly(Map.entry(planned.disambiguatedPath(), "print(1)"));
        assertThat(moved.commit().message()).isEqualTo(planned.commit().message());
        assertThat(moved.commit().authorDate()).isEqualTo(planned.commit().authorDate());
        assertThat(moved.solutionCommitId()).isEqualTo(planned.solutionCommitId());
    }

    // --- record ---

    @Test
    void committedSetsShaUrlAndCommittedAtAndCountsEachPlannedCommit() {
        Submission first = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Submission second = accepted(lruCache, "cpp", "int main() {}", "2026-03-02T10:00:00Z");
        Plan plan = recorder.plan(link, List.of(first, second));
        double before = count("committed");
        Instant start = Instant.now();

        recorder.record(plan, plan.commits(), new Outcome.Committed(List.of(
                new CommittedFile("sha1", "https://github.com/octocat/solutions/commit/sha1"),
                new CommittedFile("sha2", "https://github.com/octocat/solutions/commit/sha2"))));

        assertThat(row(first)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitSha()).isEqualTo("sha1");
            assertThat(sc.getCommitUrl()).isEqualTo("https://github.com/octocat/solutions/commit/sha1");
            assertThat(sc.getCommittedAt()).isAfterOrEqualTo(start);
            assertThat(sc.getAttempts()).isEqualTo(1);
            assertThat(sc.getLastError()).isNull();
        });
        assertThat(row(second).getCommitSha()).isEqualTo("sha2");
        assertThat(count("committed") - before).isEqualTo(2);
    }

    @Test
    void committedWithoutAUrlLinksToTheFileAtTheRowsCurrentPath() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan plan = recorder.plan(link, List.of(submission));
        PlannedCommit planned = plan.commits().get(0);
        String ownPath = planned.disambiguatedPath();

        recorder.moveTo(planned.solutionCommitId(), ownPath);
        recorder.record(plan, List.of(planned.movedTo(ownPath)), new Outcome.Committed(List.of(
                new CommittedFile(null, null))));

        assertThat(row(submission)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getPath()).isEqualTo(ownPath);
            assertThat(sc.getCommitSha()).isNull();
            assertThat(sc.getCommitUrl()).isEqualTo("https://github.com/octocat/solutions/blob/main/" + ownPath);
        });
    }

    @Test
    void committedMustHaveOneFilePerPlannedCommit() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan plan = recorder.plan(link, List.of(submission));

        assertThatThrownBy(() -> recorder.record(plan, plan.commits(), new Outcome.Committed(List.of())))
                .isInstanceOf(IllegalArgumentException.class);

        assertThat(row(submission).getStatus()).isEqualTo(SolutionCommitStatus.PENDING);
    }

    @Test
    void failedRecordsTheErrorAndCountsEachPlannedCommit() {
        Submission first = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Submission second = accepted(lruCache, "cpp", "int main() {}", "2026-03-02T10:00:00Z");
        Plan plan = recorder.plan(link, List.of(first, second));
        double failedBefore = count("failed");
        double brokenBefore = count("broken");

        recorder.record(plan, plan.commits(), Outcome.failure(new GitHubTransientException("GitHub is down")));

        for (Submission submission : List.of(first, second)) {
            assertThat(row(submission)).satisfies(sc -> {
                assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.FAILED);
                assertThat(sc.getLastError()).isEqualTo("GitHub is down");
                assertThat(sc.getAttempts()).isEqualTo(1);
            });
        }
        assertThat(count("failed") - failedBefore).isEqualTo(2);
        assertThat(count("broken") - brokenBefore).isZero();
        assertThat(currentLink().getStatus()).isEqualTo(GitHubLinkStatus.ACTIVE);
    }

    @Test
    void failedOnACommittedRowIsANoOp() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan plan = recorder.plan(link, List.of(submission));
        recorder.record(plan, plan.commits(), committed(plan));
        SolutionCommit before = row(submission);
        assertThat(recorder.isCommitted(before.getId())).isTrue();

        recorder.record(plan, plan.commits(), new Outcome.Failed(new GitHubTransientException("late failure")));
        recorder.moveTo(before.getId(), plan.commits().get(0).disambiguatedPath());

        assertThat(row(submission)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
            assertThat(sc.getCommitSha()).isEqualTo(before.getCommitSha());
            assertThat(sc.getPath()).isEqualTo(before.getPath());
            assertThat(sc.getAttempts()).isEqualTo(1);
            assertThat(sc.getLastError()).isNull();
        });
    }

    @Test
    void brokenFailsTheRowsMarksTheLinkBrokenAndCountsBroken() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan plan = recorder.plan(link, List.of(submission));
        double brokenBefore = count("broken");
        double failedBefore = count("failed");

        recorder.record(plan, plan.commits(), Outcome.failure(new GitHubInstallationGoneException("gone")));

        assertThat(row(submission)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.FAILED);
            assertThat(sc.getLastError()).isEqualTo("gone");
        });
        assertThat(currentLink().getStatus()).isEqualTo(GitHubLinkStatus.BROKEN);
        assertThat(count("broken") - brokenBefore).isEqualTo(1);
        assertThat(count("failed") - failedBefore).isZero();
    }

    @Test
    void linkEffectRunsInTheSameTransactionAsTheRows() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        Plan plan = recorder.plan(link, List.of(submission));
        inTx(() -> {
            linkRepository.findById(link.getId()).orElseThrow().unlink(Instant.now());
            return null;
        });
        double before = count("committed");

        assertThatThrownBy(() -> recorder.record(plan, plan.commits(), committed(plan),
                l -> { throw new IllegalStateException("link effect refused"); }))
                .isInstanceOf(IllegalStateException.class);

        assertThat(row(submission)).satisfies(sc -> {
            assertThat(sc.getStatus()).isEqualTo(SolutionCommitStatus.PENDING);
            assertThat(sc.getAttempts()).isZero();
        });
        assertThat(count("committed") - before).isZero();

        recorder.record(plan, plan.commits(), committed(plan), GitHubLink::markBroken);
        assertThat(row(submission).getStatus()).isEqualTo(SolutionCommitStatus.COMMITTED);
        // The effect saw the link as it is now (UNLINKED), which markBroken leaves alone.
        assertThat(currentLink().getStatus()).isEqualTo(GitHubLinkStatus.UNLINKED);
    }

    @Test
    void isCommittedAndMoveToReadAndWriteTheRow() {
        Submission submission = accepted(twoSum, "python", "print(1)", "2026-03-01T10:00:00Z");
        PlannedCommit planned = recorder.plan(link, List.of(submission)).commits().get(0);

        assertThat(recorder.isCommitted(planned.solutionCommitId())).isFalse();
        recorder.moveTo(planned.solutionCommitId(), planned.disambiguatedPath());

        assertThat(row(submission).getPath()).isEqualTo(planned.disambiguatedPath());
        assertThat(recorder.isCommitted(Long.MAX_VALUE)).isFalse();
    }

    // --- fixtures ---

    private Outcome.Committed committed(Plan plan) {
        return new Outcome.Committed(plan.commits().stream()
                .map(pc -> new CommittedFile("sha-" + pc.solutionCommitId(),
                        "https://github.com/" + plan.repositoryFullName() + "/commit/sha-" + pc.solutionCommitId()))
                .toList());
    }

    private static List<Map.Entry<String, String>> files(PlannedCommit planned) {
        return planned.commit().files().stream().map(f -> Map.entry(f.path(), f.content())).toList();
    }

    private SolutionCommit row(Submission submission) {
        return solutionCommitRepository.findFirstBySubmissionIdOrderByIdDesc(submission.getId()).orElseThrow();
    }

    private GitHubLink currentLink() {
        return linkRepository.findById(link.getId()).orElseThrow();
    }

    private double count(String outcome) {
        Counter counter = meterRegistry.find("codebite.solution.commits").tag("outcome", outcome).counter();
        return counter == null ? 0 : counter.count();
    }

    private <T> T inTx(Supplier<T> work) {
        return tx.execute(status -> work.get());
    }

    private GitHubLink link(String fullName) {
        GitHubLink saved = inTx(() -> linkRepository.saveAndFlush(new GitHubLink(user.getId(), 583231, "octocat",
                77, fullName.hashCode(), fullName, "main", false)));
        links.add(saved);
        return saved;
    }

    private Problem saveProblem(String title, String slug, Difficulty difficulty) {
        return inTx(() -> {
            Problem problem = new Problem();
            problem.setTitle(title);
            problem.setSlug(slug);
            problem.setDescription("Never reaches GitHub.");
            problem.setDifficulty(difficulty);
            problem.setPublished(true);
            return problemRepository.save(problem);
        });
    }

    /** An Accepted submission (12 ms, 1536 KB) made at {@code at}, with its problem loaded. */
    private Submission accepted(Problem problem, String language, String code, String at) {
        Submission saved = inTx(() -> {
            Submission submission = new Submission();
            submission.setUser(user);
            submission.setProblem(problem);
            submission.setLanguage(language);
            submission.setSourceCode(code);
            submission.setStatus(SubmissionStatus.ACCEPTED);
            submission.setRuntimeMs(12);
            submission.setMemoryKb(1536);
            submission = submissionRepository.saveAndFlush(submission);
            // created_at is set on insert and not updatable through the entity, so backdate it in SQL.
            entityManager.createQuery("UPDATE Submission s SET s.createdAt = :at WHERE s.id = :id")
                    .setParameter("at", Instant.parse(at))
                    .setParameter("id", submission.getId())
                    .executeUpdate();
            entityManager.clear();
            return entityManager.createQuery(
                            "SELECT s FROM Submission s JOIN FETCH s.problem WHERE s.id = :id", Submission.class)
                    .setParameter("id", submission.getId())
                    .getSingleResult();
        });
        submissions.add(saved);
        return saved;
    }
}
