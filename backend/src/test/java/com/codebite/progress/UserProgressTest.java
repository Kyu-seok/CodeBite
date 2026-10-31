package com.codebite.progress;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Curation;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.entity.TestCase;
import com.codebite.progress.UserProgress.ActivityDay;
import com.codebite.progress.UserProgress.Aggregate;
import com.codebite.progress.UserProgress.Status;
import com.codebite.progress.UserProgress.TagProgress;
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

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;
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

    @Nested
    class SolvedByDifficulty {

        @Test
        void countsDistinctPublishedProblemsPerDifficulty() {
            Problem easy2 = persistProblem("progress-easy-2", Difficulty.EASY, true);
            Problem draft = persistProblem("progress-draft", Difficulty.HARD, false);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, easy2, SubmissionStatus.ACCEPTED);
            submit(user, medium, SubmissionStatus.WRONG_ANSWER);
            submit(user, draft, SubmissionStatus.ACCEPTED);
            submit(admin, hard, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            assertEquals(Map.of(Difficulty.EASY, 2),
                    progress.solvedByDifficulty(user.getId(), Optional.empty()),
                    "two Accepted on one problem count once; unpublished, attempted and admin do not count");
        }

        @Test
        void curationLimitsByProblemNumber() {
            easy.setProblemNumber(10);
            hard.setProblemNumber(120);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, hard, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            assertEquals(Map.of(Difficulty.EASY, 1, Difficulty.HARD, 1),
                    progress.solvedByDifficulty(user.getId(), Optional.empty()));
            assertEquals(Map.of(Difficulty.EASY, 1),
                    progress.solvedByDifficulty(user.getId(), Optional.of(Curation.CB100)));
        }

        @Test
        void theTutorialProblemIsSolvedButInNoCuration() {
            easy.setProblemNumber(0);
            medium.setProblemNumber(1);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, medium, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            assertEquals(Map.of(Difficulty.EASY, 1, Difficulty.MEDIUM, 1),
                    progress.solvedByDifficulty(user.getId(), Optional.empty()));
            assertEquals(Map.of(Difficulty.MEDIUM, 1),
                    progress.solvedByDifficulty(user.getId(), Optional.of(Curation.CB50)));
        }

        @Test
        void nothingSolvedIsAnEmptyMap() {
            submit(user, easy, SubmissionStatus.WRONG_ANSWER);
            entityManager.flush();

            assertEquals(Map.of(), progress.solvedByDifficulty(user.getId(), Optional.empty()));
        }
    }

    @Nested
    class SolvedByTag {

        @Test
        void countsDistinctPublishedProblemsPerTag() {
            Tag arrays = persistTag("arrays", "Arrays");
            Tag hashing = persistTag("hashing", "Hashing");
            Problem draft = persistProblem("progress-draft", Difficulty.EASY, false);
            easy.getTags().addAll(Set.of(arrays, hashing));
            medium.getTags().add(arrays);
            hard.getTags().add(hashing);
            draft.getTags().add(arrays);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, medium, SubmissionStatus.ACCEPTED);
            submit(user, hard, SubmissionStatus.WRONG_ANSWER);
            submit(user, draft, SubmissionStatus.ACCEPTED);
            submit(admin, hard, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            List<TagProgress> byTag = progress.solvedByTag(user.getId());

            assertEquals(Set.of(new TagProgress("arrays", "Arrays", 2L), new TagProgress("hashing", "Hashing", 1L)),
                    Set.copyOf(byTag));
        }

        @Test
        void nothingSolvedIsAnEmptyList() {
            easy.getTags().add(persistTag("arrays", "Arrays"));
            submit(user, easy, SubmissionStatus.TIME_LIMIT_EXCEEDED);
            entityManager.flush();

            assertEquals(List.of(), progress.solvedByTag(user.getId()));
        }
    }

    @Nested
    class AggregateRow {

        @Test
        void countsSolvedAttemptedTotalAcceptedAndLastSolved_gradedNonAdminOnly() {
            submit(user, easy, SubmissionStatus.WRONG_ANSWER);
            submit(user, easy, SubmissionStatus.ACCEPTED);
            Submission latest = submit(user, easy, SubmissionStatus.ACCEPTED);
            submit(user, medium, SubmissionStatus.WRONG_ANSWER);
            submit(user, hard, SubmissionStatus.PENDING);
            submit(admin, hard, SubmissionStatus.ACCEPTED);
            entityManager.flush();

            Aggregate aggregate = progress.aggregate(user.getId());

            assertEquals(new Aggregate(1L, 2L, 4L, 2L, latest.getCreatedAt()), aggregate,
                    "easy Solved once, two problems Attempted, four graded, two Accepted; PENDING and admin ignored");
            assertEquals(new Aggregate(0L, 0L, 0L, 0L, null), progress.aggregate(admin.getId()));
        }

        @Test
        void noSubmissionsIsAllZeros() {
            assertEquals(new Aggregate(0L, 0L, 0L, 0L, null), progress.aggregate(user.getId()),
                    "SUM over no rows is null in SQL; the row must still come back as zeros");
        }
    }

    @Nested
    class Activity {

        @Test
        void bucketsByUtcDay_everyStatus_sinceInclusive() {
            submittedAt(submit(user, easy, SubmissionStatus.WRONG_ANSWER), "2026-03-01T23:59:59Z");
            submittedAt(submit(user, easy, SubmissionStatus.ACCEPTED), "2026-03-02T00:00:01Z");
            submittedAt(submit(user, medium, SubmissionStatus.PENDING), "2026-03-02T12:00:00Z");
            submittedAt(submit(user, hard, SubmissionStatus.ACCEPTED), "2026-02-28T23:59:59Z");
            submittedAt(submit(admin, hard, SubmissionStatus.ACCEPTED), "2026-03-05T00:00:00Z");
            entityManager.flush();
            entityManager.clear();

            List<ActivityDay> days = progress.activity(user.getId(), Instant.parse("2026-03-01T23:59:59Z"));

            assertEquals(List.of(
                            new ActivityDay(LocalDate.parse("2026-03-01"), 1),
                            new ActivityDay(LocalDate.parse("2026-03-02"), 2)),
                    days, "a second before and a second after UTC midnight are different days; PENDING counts");
        }

        @Test
        void anAdminsOwnSubmissionsAreTheirActivity() {
            submittedAt(submit(admin, easy, SubmissionStatus.ACCEPTED), "2026-03-05T00:00:00Z");
            entityManager.flush();
            entityManager.clear();

            assertEquals(List.of(new ActivityDay(LocalDate.parse("2026-03-05"), 1)),
                    progress.activity(admin.getId(), Instant.EPOCH));
        }

        @Test
        void noSubmissionsIsAnEmptyList() {
            assertEquals(List.of(), progress.activity(user.getId(), Instant.EPOCH));
        }

        /** created_at is not updatable through the entity, so it is set as StreakRecordingTest does. */
        private void submittedAt(Submission submission, String instant) {
            entityManager.flush();
            entityManager.getEntityManager()
                    .createQuery("UPDATE Submission s SET s.createdAt = :at WHERE s.id = :id")
                    .setParameter("at", Instant.parse(instant))
                    .setParameter("id", submission.getId())
                    .executeUpdate();
        }
    }

    private Tag persistTag(String slug, String name) {
        Tag tag = new Tag();
        tag.setSlug(slug);
        tag.setName(name);
        return entityManager.persist(tag);
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
