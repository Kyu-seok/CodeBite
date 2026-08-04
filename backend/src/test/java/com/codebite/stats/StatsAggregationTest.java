package com.codebite.stats;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.stats.entity.ProblemStats;
import com.codebite.stats.entity.UserStats;
import com.codebite.stats.repository.ProblemStatsRepository;
import com.codebite.stats.repository.UserStatsRepository;
import com.codebite.stats.service.StatsService;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Exercises the aggregate JPQL and the recompute against a real database rather than mocks —
 * COUNT(DISTINCT CASE WHEN ...) is the sort of thing that compiles and then fails at runtime.
 */
@DataJpaTest
@ActiveProfiles("test")
@Import(StatsService.class)
@Sql(statements = {
        "DELETE FROM user_stats",
        "DELETE FROM problem_stats",
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM problems",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class StatsAggregationTest {

    @Autowired private StatsService statsService;
    @Autowired private SubmissionRepository submissionRepository;
    @Autowired private UserStatsRepository userStatsRepository;
    @Autowired private ProblemStatsRepository problemStatsRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private TestEntityManager entityManager;

    private User user;
    private Problem problemA;
    private Problem problemB;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUsername("stats-user");
        user.setEmail("stats@test.com");
        user.setPasswordHash("hash");
        user = entityManager.persist(user);

        problemA = persistProblem("stats-problem-a");
        problemB = persistProblem("stats-problem-b");
        entityManager.flush();
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

    private Submission submit(Problem problem, SubmissionStatus status, boolean admin) {
        Submission submission = new Submission();
        submission.setUser(user);
        submission.setProblem(problem);
        submission.setLanguage("python");
        submission.setSourceCode("x");
        submission.setStatus(status);
        submission.setAdminSubmission(admin);
        return entityManager.persist(submission);
    }

    @Test
    void computesSolvedAttemptedAndAcceptanceRate() {
        submit(problemA, SubmissionStatus.WRONG_ANSWER, false);
        submit(problemA, SubmissionStatus.ACCEPTED, false);
        submit(problemB, SubmissionStatus.WRONG_ANSWER, false);
        entityManager.flush();

        statsService.recompute(user.getId(), problemA.getId());

        UserStats stats = userStatsRepository.findById(user.getId()).orElseThrow();
        assertEquals(1, stats.getSolvedCount(), "only problemA was accepted");
        assertEquals(2, stats.getAttemptedCount(), "both problems were attempted");
        assertEquals(3, stats.getTotalSubmissions());
        assertEquals(1, stats.getAcceptedSubmissions());
        assertEquals(33.3, stats.acceptanceRate(), 0.05);
        assertNotNull(stats.getLastSolvedAt());
    }

    @Test
    void solvingTheSameProblemTwiceCountsOnce() {
        submit(problemA, SubmissionStatus.ACCEPTED, false);
        submit(problemA, SubmissionStatus.ACCEPTED, false);
        entityManager.flush();

        statsService.recompute(user.getId(), problemA.getId());

        UserStats stats = userStatsRepository.findById(user.getId()).orElseThrow();
        assertEquals(1, stats.getSolvedCount(), "solved count is distinct problems, not submissions");
        assertEquals(2, stats.getAcceptedSubmissions());
    }

    @Test
    void replayingTheSameEventDoesNotDoubleCount() {
        submit(problemA, SubmissionStatus.ACCEPTED, false);
        submit(problemB, SubmissionStatus.WRONG_ANSWER, false);
        entityManager.flush();

        // At-least-once delivery: the consumer will see this more than once.
        statsService.recompute(user.getId(), problemA.getId());
        UserStats first = userStatsRepository.findById(user.getId()).orElseThrow();
        int solvedAfterFirst = first.getSolvedCount();
        int totalAfterFirst = first.getTotalSubmissions();

        statsService.recompute(user.getId(), problemA.getId());
        statsService.recompute(user.getId(), problemA.getId());

        UserStats after = userStatsRepository.findById(user.getId()).orElseThrow();
        assertEquals(solvedAfterFirst, after.getSolvedCount(), "replay must converge, not accumulate");
        assertEquals(totalAfterFirst, after.getTotalSubmissions());
        assertEquals(1, after.getSolvedCount());
        assertEquals(2, after.getTotalSubmissions());
    }

    @Test
    void adminSubmissionsAreExcludedFromAggregates() {
        submit(problemA, SubmissionStatus.ACCEPTED, true);
        submit(problemA, SubmissionStatus.ACCEPTED, true);
        entityManager.flush();

        statsService.recompute(user.getId(), problemA.getId());

        UserStats stats = userStatsRepository.findById(user.getId()).orElseThrow();
        assertEquals(0, stats.getSolvedCount());
        assertEquals(0, stats.getTotalSubmissions());

        ProblemStats problemStats = problemStatsRepository.findById(problemA.getId()).orElseThrow();
        assertEquals(0, problemStats.getTotalSubmissions(), "admin runs must not skew acceptance rate");
    }

    @Test
    void pendingSubmissionsAreExcludedUntilGraded() {
        submit(problemA, SubmissionStatus.PENDING, false);
        entityManager.flush();

        statsService.recompute(user.getId(), problemA.getId());

        UserStats stats = userStatsRepository.findById(user.getId()).orElseThrow();
        assertEquals(0, stats.getTotalSubmissions(), "an ungraded submission has no outcome to count");
    }

    @Test
    void computesPerProblemAcceptanceRate() {
        User other = new User();
        other.setUsername("other-user");
        other.setEmail("other@test.com");
        other.setPasswordHash("hash");
        other = entityManager.persist(other);

        submit(problemA, SubmissionStatus.ACCEPTED, false);
        submit(problemA, SubmissionStatus.WRONG_ANSWER, false);
        submit(problemA, SubmissionStatus.WRONG_ANSWER, false);
        submit(problemA, SubmissionStatus.WRONG_ANSWER, false);
        entityManager.flush();

        statsService.recompute(user.getId(), problemA.getId());

        ProblemStats stats = problemStatsRepository.findById(problemA.getId()).orElseThrow();
        assertEquals(4, stats.getTotalSubmissions());
        assertEquals(1, stats.getAcceptedSubmissions());
        assertEquals(25.0, stats.acceptanceRate(), 0.01);
    }

    @Test
    void leaderboardRanksBySolvedCountAndSharesRanksOnTies() {
        User second = new User();
        second.setUsername("second-user");
        second.setEmail("second@test.com");
        second.setPasswordHash("hash");
        second = entityManager.persist(second);
        entityManager.flush();

        // user solves two problems, second solves one.
        submit(problemA, SubmissionStatus.ACCEPTED, false);
        submit(problemB, SubmissionStatus.ACCEPTED, false);

        Submission theirs = new Submission();
        theirs.setUser(second);
        theirs.setProblem(problemA);
        theirs.setLanguage("python");
        theirs.setSourceCode("x");
        theirs.setStatus(SubmissionStatus.ACCEPTED);
        entityManager.persist(theirs);
        entityManager.flush();

        statsService.recompute(user.getId(), problemA.getId());
        statsService.recompute(second.getId(), problemA.getId());

        var board = statsService.leaderboard(10);
        assertEquals(2, board.size());
        assertEquals(1, board.get(0).rank());
        assertEquals(2, board.get(0).solvedCount());
        assertEquals("stats-user", board.get(0).username());
        assertEquals(2, board.get(1).rank());
        assertEquals(1, board.get(1).solvedCount());
    }

    @Test
    void leaderboardExcludesUsersWhoHaveSolvedNothing() {
        submit(problemA, SubmissionStatus.WRONG_ANSWER, false);
        entityManager.flush();

        statsService.recompute(user.getId(), problemA.getId());

        assertTrue(statsService.leaderboard(10).isEmpty());
    }
}
