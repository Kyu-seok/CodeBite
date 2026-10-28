package com.codebite.progress;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.progress.ProblemPopularity.Rate;
import com.codebite.stats.entity.ProblemStats;
import com.codebite.stats.repository.ProblemStatsRepository;
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
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.util.List;
import java.util.Map;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

/** Acceptance Rate comes from problem_stats alone; these pin what a row, no row and a zero row read. */
@DataJpaTest
@ActiveProfiles("test")
@Import(ProblemPopularity.class)
@Sql(statements = {
        "DELETE FROM problem_stats",
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM test_cases",
        "DELETE FROM problems",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class ProblemPopularityTest {

    @Autowired private ProblemPopularity popularity;
    @Autowired private ProblemStatsRepository problemStatsRepository;
    @Autowired private TestEntityManager entityManager;

    private Problem counted;
    private Problem zeroRow;
    private Problem noRow;

    @BeforeEach
    void setUp() {
        counted = persistProblem("popularity-counted");
        zeroRow = persistProblem("popularity-zero-row");
        noRow = persistProblem("popularity-no-row");
        persistStats(counted, 3, 1);
        persistStats(zeroRow, 0, 0);
        entityManager.flush();
        entityManager.clear();
    }

    @Test
    void readsTheRowAndRoundsLikeProblemStats() {
        Map<Long, Rate> rates = popularity.acceptanceRates(List.of(counted.getId()));

        assertEquals(new Rate(3, 1, 33.3), rates.get(counted.getId()));
        assertEquals(33.3, rates.get(counted.getId()).percentIfGraded());
    }

    @Test
    void aProblemWithoutARowReadsZero() {
        Map<Long, Rate> rates = popularity.acceptanceRates(List.of(counted.getId(), noRow.getId()));

        assertEquals(Set.of(counted.getId(), noRow.getId()), rates.keySet(), "every requested id is answered");
        assertEquals(Rate.NONE, rates.get(noRow.getId()));
        assertEquals(0.0, rates.get(noRow.getId()).percent());
        assertNull(rates.get(noRow.getId()).percentIfGraded(), "nothing graded shows no percentage");
    }

    @Test
    void aZeroRowReadsLikeNoRow() {
        Rate rate = popularity.acceptanceRates(List.of(zeroRow.getId())).get(zeroRow.getId());

        assertEquals(Rate.NONE, rate);
        assertNull(rate.percentIfGraded());
    }

    @Test
    void noIdsMeansNoRates() {
        assertEquals(Map.of(), popularity.acceptanceRates(List.of()));
    }

    @Test
    void recountIsLive_gradedNonAdminOnly_andRoundsLikeTheRow() {
        User user = persistUser("popularity-user", Role.USER);
        User admin = persistUser("popularity-admin", Role.ADMIN);
        submit(user, noRow, SubmissionStatus.ACCEPTED);
        submit(user, noRow, SubmissionStatus.WRONG_ANSWER);
        submit(user, noRow, SubmissionStatus.WRONG_ANSWER);
        submit(user, noRow, SubmissionStatus.PENDING);
        submit(admin, noRow, SubmissionStatus.ACCEPTED);
        entityManager.flush();

        assertEquals(new Rate(3, 1, 33.3), popularity.recount(noRow.getId()));
        assertEquals(Rate.NONE, popularity.acceptanceRates(List.of(noRow.getId())).get(noRow.getId()),
                "a recount is not a read: the row is written by StatsService");
    }

    @Test
    void recountOfAProblemNobodyGradedIsNone() {
        assertEquals(Rate.NONE, popularity.recount(noRow.getId()), "SUM over no rows must come back 0, not null");
    }

    @Test
    void forAllReturnsOnlyProblemsWithARow() {
        Map<Long, Rate> rates = popularity.acceptanceRatesForAll();

        assertEquals(Set.of(counted.getId(), zeroRow.getId()), rates.keySet());
        assertEquals(new Rate(3, 1, 33.3), rates.get(counted.getId()));
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

    private User persistUser(String name, Role role) {
        User u = new User();
        u.setUsername(name);
        u.setEmail(name + "@test.com");
        u.setPasswordHash("hash");
        u.setRole(role);
        return entityManager.persist(u);
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

    private void persistStats(Problem problem, int total, int accepted) {
        ProblemStats stats = new ProblemStats(problem.getId());
        stats.setTotalSubmissions(total);
        stats.setAcceptedSubmissions(accepted);
        problemStatsRepository.save(stats);
    }
}
