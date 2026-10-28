package com.codebite.progress;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.progress.UserProgress.Status;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
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

/**
 * Owns every query in {@link UserProgress} against a real database, and pins the invariants its
 * Javadoc states. Built like StatsAggregationTest: aggregate JPQL compiles and then fails at
 * runtime, so nothing here is mocked.
 */
@DataJpaTest
@ActiveProfiles("test")
@Import(UserProgress.class)
@Sql(statements = {
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM test_cases",
        "DELETE FROM problem_tags",
        "DELETE FROM problems",
        "DELETE FROM tags",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class UserProgressTest {

    @Autowired private UserProgress progress;
    @Autowired private TestEntityManager entityManager;

    private User user;
    private User admin;
    private Problem easy;
    private Problem medium;
    private Problem hard;

    @BeforeEach
    void setUp() {
        user = persistUser("progress-user", Role.USER);
        admin = persistUser("progress-admin", Role.ADMIN);
        easy = persistProblem("progress-easy", Difficulty.EASY, true);
        medium = persistProblem("progress-medium", Difficulty.MEDIUM, true);
        hard = persistProblem("progress-hard", Difficulty.HARD, true);
        entityManager.flush();
    }

    @Nested
    class StatusByProblem {

        @Test
        void solvedOnceAccepted_attemptedUntilThen_absentWhenNeverGraded() {
            submit(user, easy, SubmissionStatus.WRONG_ANSWER);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, medium, SubmissionStatus.WRONG_ANSWER);
            entityManager.flush();

            Map<Long, Status> statuses = progress.statusByProblem(user.getId(), ids(easy, medium, hard));

            assertEquals(Map.of(easy.getId(), Status.SOLVED, medium.getId(), Status.ATTEMPTED), statuses);
        }

        @Test
        void acceptedTwiceIsSolvedOnce() {
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            assertEquals(Map.of(easy.getId(), Status.SOLVED), progress.statusByProblem(user.getId(), ids(easy)));
            assertEquals(Set.of(easy.getId()), progress.solvedProblemIds(user.getId()));
        }

        @Test
        void pendingIsNeitherSolvedNorAttempted() {
            submit(user, easy, SubmissionStatus.PENDING);
            submit(user, medium, SubmissionStatus.PENDING);
            submit(user, medium, SubmissionStatus.RUNTIME_ERROR);
            entityManager.flush();

            assertEquals(Map.of(medium.getId(), Status.ATTEMPTED),
                    progress.statusByProblem(user.getId(), ids(easy, medium)));
        }

        @Test
        void anAdminsOwnValidationRunsAreInvisible() {
            submit(admin, easy, SubmissionStatus.ACCEPTED);
            submit(admin, medium, SubmissionStatus.WRONG_ANSWER);
            entityManager.flush();

            assertEquals(Map.of(), progress.statusByProblem(admin.getId(), ids(easy, medium)));
            assertEquals(Set.of(), progress.solvedProblemIds(admin.getId()));
        }

        @Test
        void onlyTheAskedForProblemsAreAnswered() {
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, hard, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            assertEquals(Map.of(easy.getId(), Status.SOLVED), progress.statusByProblem(user.getId(), ids(easy)));
            assertEquals(Map.of(), progress.statusByProblem(user.getId(), List.of()));
        }

        @Test
        void anotherUsersSubmissionsDoNotCount() {
            User other = persistUser("progress-other", Role.USER);
            submit(other, easy, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            assertEquals(Map.of(), progress.statusByProblem(user.getId(), ids(easy)));
            assertEquals(Set.of(), progress.solvedProblemIds(user.getId()));
        }
    }

    @Nested
    class SolvedProblemIds {

        @Test
        void everySolvedProblemPublishedOrNot() {
            Problem draft = persistProblem("progress-draft", Difficulty.EASY, false);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, draft, SubmissionStatus.ACCEPTED);
            submit(user, medium, SubmissionStatus.WRONG_ANSWER);
            submit(user, hard, SubmissionStatus.PENDING);
            entityManager.flush();

            assertEquals(Set.of(easy.getId(), draft.getId()), progress.solvedProblemIds(user.getId()));
        }
    }

    private static List<Long> ids(Problem... problems) {
        return java.util.Arrays.stream(problems).map(Problem::getId).toList();
    }

    private User persistUser(String name, Role role) {
        User u = new User();
        u.setUsername(name);
        u.setEmail(name + "@test.com");
        u.setPasswordHash("hash");
        u.setRole(role);
        return entityManager.persist(u);
    }

    private Problem persistProblem(String slug, Difficulty difficulty, boolean published) {
        Problem problem = new Problem();
        problem.setTitle(slug);
        problem.setSlug(slug);
        problem.setDescription("d");
        problem.setDifficulty(difficulty);
        problem.setPublished(published);
        return entityManager.persist(problem);
    }

    private Submission submit(User owner, Problem problem, SubmissionStatus status) {
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
        return entityManager.persist(submission);
    }
}
