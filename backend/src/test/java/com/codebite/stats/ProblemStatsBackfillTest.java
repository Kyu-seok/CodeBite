package com.codebite.stats;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.progress.ProblemPopularity;
import com.codebite.progress.UserProgress;
import com.codebite.stats.entity.ProblemStats;
import com.codebite.stats.repository.ProblemStatsRepository;
import com.codebite.stats.service.StatsService;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.context.annotation.Import;
import org.springframework.core.io.ClassPathResource;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

/**
 * The V195 backfill must write exactly what the stats consumer writes, so that a backfilled
 * problem_stats row and a consumer-written one are the same row. Flyway already ran the migration
 * against an empty H2 at context start (proving its syntax); here its statements are re-run over
 * seeded submissions and compared with {@link StatsService#recompute}.
 */
@DataJpaTest
@ActiveProfiles("test")
@Import({StatsService.class, UserProgress.class, ProblemPopularity.class})
@Sql(statements = {
        "DELETE FROM user_stats",
        "DELETE FROM problem_stats",
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM test_cases",
        "DELETE FROM problems",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class ProblemStatsBackfillTest {

    private static final String MIGRATION = "db/migration/V195__backfill_problem_stats.sql";

    @Autowired private StatsService statsService;
    @Autowired private ProblemStatsRepository problemStatsRepository;
    @Autowired private TestEntityManager entityManager;

    private User user;
    private User other;
    private User admin;
    private Problem mixed;      // graded by two users, plus admin and PENDING noise
    private Problem adminOnly;  // only an admin's validation run
    private Problem untouched;  // no submissions at all
    private Problem pendingOnly;

    @BeforeEach
    void setUp() {
        user = persistUser("backfill-user", Role.USER);
        other = persistUser("backfill-other", Role.USER);
        admin = persistUser("backfill-admin", Role.ADMIN);
        mixed = persistProblem("backfill-mixed");
        adminOnly = persistProblem("backfill-admin-only");
        untouched = persistProblem("backfill-untouched");
        pendingOnly = persistProblem("backfill-pending-only");

        submit(user, mixed, SubmissionStatus.ACCEPTED);
        submit(user, mixed, SubmissionStatus.WRONG_ANSWER);
        submit(user, mixed, SubmissionStatus.PENDING);
        submit(other, mixed, SubmissionStatus.TIME_LIMIT_EXCEEDED);
        submit(other, mixed, SubmissionStatus.ACCEPTED);
        submit(admin, mixed, SubmissionStatus.ACCEPTED);
        submit(admin, adminOnly, SubmissionStatus.ACCEPTED);
        submit(user, pendingOnly, SubmissionStatus.PENDING);
        entityManager.flush();
        entityManager.clear();
    }

    @Test
    void countsGradedNonAdminSubmissionsPerProblem() throws IOException {
        runMigration();

        Map<Long, ProblemStats> rows = rowsByProblem();
        assertEquals(List.of(mixed.getId()), rows.keySet().stream().sorted().toList(),
                "only a problem with a graded non-admin submission gets a row");
        assertEquals(4, rows.get(mixed.getId()).getTotalSubmissions(), "PENDING and admin rows do not count");
        assertEquals(2, rows.get(mixed.getId()).getAcceptedSubmissions());
        assertEquals(50.0, rows.get(mixed.getId()).acceptanceRate(), 0.01);
    }

    @Test
    void writesWhatTheStatsConsumerWrites() throws IOException {
        runMigration();
        Map<Long, List<Integer>> backfilled = snapshot();

        problemStatsRepository.deleteAll();
        entityManager.flush();
        entityManager.clear();
        // The events the consumer would have processed: one per graded non-admin submission.
        statsService.recompute(user.getId(), mixed.getId());
        statsService.recompute(other.getId(), mixed.getId());
        entityManager.flush();
        entityManager.clear();

        assertEquals(backfilled, snapshot(), "a backfilled row must equal a consumer-written one");
    }

    @Test
    void replacesWhateverWasThereAndIsIdempotent() throws IOException {
        ProblemStats stale = new ProblemStats(untouched.getId());
        stale.setTotalSubmissions(99);
        stale.setAcceptedSubmissions(99);
        problemStatsRepository.save(stale);
        entityManager.flush();
        entityManager.clear();

        runMigration();
        Map<Long, List<Integer>> first = snapshot();
        runMigration();

        assertFalse(first.containsKey(untouched.getId()), "a row with nothing behind it is removed");
        assertEquals(first, snapshot(), "running the backfill again changes nothing");
    }

    private void runMigration() throws IOException {
        String sql = new ClassPathResource(MIGRATION).getContentAsString(StandardCharsets.UTF_8);
        String withoutComments = Arrays.stream(sql.split("\n"))
                .filter(line -> !line.trim().startsWith("--"))
                .collect(Collectors.joining("\n"));
        for (String statement : withoutComments.split(";")) {
            if (!statement.isBlank()) {
                entityManager.getEntityManager().createNativeQuery(statement).executeUpdate();
            }
        }
        entityManager.clear();
    }

    private Map<Long, ProblemStats> rowsByProblem() {
        return problemStatsRepository.findAll().stream()
                .collect(Collectors.toMap(ProblemStats::getProblemId, Function.identity()));
    }

    /** (total, accepted) per problem, comparable by value. */
    private Map<Long, List<Integer>> snapshot() {
        return problemStatsRepository.findAll().stream().collect(Collectors.toMap(
                ProblemStats::getProblemId,
                s -> List.of(s.getTotalSubmissions(), s.getAcceptedSubmissions())));
    }

    private User persistUser(String name, Role role) {
        User u = new User();
        u.setUsername(name);
        u.setEmail(name + "@test.com");
        u.setPasswordHash("hash");
        u.setRole(role);
        return entityManager.persist(u);
    }

    private Problem persistProblem(String slug) {
        Problem problem = new Problem();
        problem.setTitle(slug);
        problem.setSlug(slug);
        problem.setDescription("d");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        return entityManager.persist(problem);
    }

    private void submit(User owner, Problem problem, SubmissionStatus status) {
        Submission submission = Submission.pending(owner, problem, "python", "x");
        if (status != SubmissionStatus.PENDING) {
            TestCase testCase = new TestCase();
            testCase.setProblem(problem);
            testCase.setInput("1");
            testCase.setExpectedOutput("1");
            testCase.setOrderIndex(1);
            testCase = entityManager.persist(testCase);
            submission.grade(Verdict.of(List.of(new CaseVerdict(status, true, "", null, null, 1, 1))),
                    List.of(testCase));
        }
        entityManager.persist(submission);
    }
}
