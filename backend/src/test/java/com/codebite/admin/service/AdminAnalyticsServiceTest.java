package com.codebite.admin.service;

import com.codebite.admin.dto.OnboardingSuccess;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.progress.ProblemPopularity;
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

import java.time.Duration;
import java.time.Instant;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * The admin analytics figures against a real database: they are aggregate JPQL, which compiles
 * and then fails at runtime, so nothing here is mocked.
 */
@DataJpaTest
@ActiveProfiles("test")
@Import({AdminAnalyticsService.class, ProblemPopularity.class})
@Sql(statements = {
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM test_cases",
        "DELETE FROM problem_tags",
        "DELETE FROM problems",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class AdminAnalyticsServiceTest {

    @Autowired private AdminAnalyticsService analytics;
    @Autowired private TestEntityManager entityManager;

    private Problem problem;
    private final Instant now = Instant.now();

    @BeforeEach
    void setUp() {
        problem = new Problem();
        problem.setTitle("analytics-problem");
        problem.setSlug("analytics-problem");
        problem.setDescription("d");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem = entityManager.persist(problem);
        entityManager.flush();
    }

    @Nested
    class OnboardingSuccessFigure {

        @Test
        void countsUsersWhoseFirstAcceptedCameWithin24HoursOfSigningUp() {
            User quick = userSignedUp("quick", Role.USER, now.minus(Duration.ofDays(5)));
            submitAt(quick, SubmissionStatus.WRONG_ANSWER, now.minus(Duration.ofDays(5)).plus(Duration.ofHours(1)));
            submitAt(quick, SubmissionStatus.ACCEPTED, now.minus(Duration.ofDays(5)).plus(Duration.ofHours(23)));

            User slow = userSignedUp("slow", Role.USER, now.minus(Duration.ofDays(5)));
            submitAt(slow, SubmissionStatus.ACCEPTED, now.minus(Duration.ofDays(5)).plus(Duration.ofHours(25)));

            User failing = userSignedUp("failing", Role.USER, now.minus(Duration.ofDays(3)));
            submitAt(failing, SubmissionStatus.WRONG_ANSWER, now.minus(Duration.ofDays(3)).plus(Duration.ofHours(1)));

            userSignedUp("idle", Role.USER, now.minus(Duration.ofDays(2)));

            assertEquals(new OnboardingSuccess(30, 4, 1, 25.0), analytics.getOnboardingSuccess(30));
        }

        @Test
        void leavesOutUsersWhoSignedUpBeforeThePeriod() {
            User old = userSignedUp("old", Role.USER, now.minus(Duration.ofDays(40)));
            submitAt(old, SubmissionStatus.ACCEPTED, now.minus(Duration.ofDays(40)).plus(Duration.ofHours(1)));

            User recent = userSignedUp("recent", Role.USER, now.minus(Duration.ofDays(1)));
            submitAt(recent, SubmissionStatus.ACCEPTED, now.minus(Duration.ofDays(1)).plus(Duration.ofHours(2)));

            userSignedUp("recent-idle", Role.USER, now.minus(Duration.ofDays(6)));
            userSignedUp("recent-idle-2", Role.USER, now.minus(Duration.ofDays(6)));

            assertEquals(new OnboardingSuccess(7, 3, 1, 33.3), analytics.getOnboardingSuccess(7));
        }

        @Test
        void anAdminsSubmissionsDoNotCount_andAdminsAreNotNewUsers() {
            User admin = userSignedUp("admin", Role.ADMIN, now.minus(Duration.ofDays(2)));
            submitAt(admin, SubmissionStatus.ACCEPTED, now.minus(Duration.ofDays(2)).plus(Duration.ofHours(1)));

            // A user later promoted to admin: their submissions as admin are validation runs.
            User promoted = userSignedUp("promoted", Role.USER, now.minus(Duration.ofDays(2)));
            Submission run = submitAt(promoted, SubmissionStatus.ACCEPTED,
                    now.minus(Duration.ofDays(2)).plus(Duration.ofHours(1)));
            markAdminSubmission(run);

            assertEquals(new OnboardingSuccess(30, 1, 0, 0.0), analytics.getOnboardingSuccess(30));
        }

        @Test
        void noSignUpsIsNoFigure() {
            assertEquals(new OnboardingSuccess(30, 0, 0, null), analytics.getOnboardingSuccess(30));
        }
    }

    private User userSignedUp(String name, Role role, Instant at) {
        User u = new User();
        u.setUsername(name);
        u.setEmail(name + "@test.com");
        u.setPasswordHash("hash");
        u.setRole(role);
        u = entityManager.persist(u);
        entityManager.flush();
        entityManager.getEntityManager()
                .createQuery("UPDATE User u SET u.createdAt = :at WHERE u.id = :id")
                .setParameter("at", at)
                .setParameter("id", u.getId())
                .executeUpdate();
        return u;
    }

    private Submission submitAt(User owner, SubmissionStatus status, Instant at) {
        Submission submission = Submission.pending(owner, problem, "python", "x");
        TestCase testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput("1");
        testCase.setExpectedOutput("1");
        testCase.setOrderIndex(1);
        testCase = entityManager.persist(testCase);
        submission.grade(Verdict.of(List.of(new CaseVerdict(status, true, "", null, null, 1, 1))),
                List.of(testCase));
        submission = entityManager.persist(submission);
        entityManager.flush();
        entityManager.getEntityManager()
                .createQuery("UPDATE Submission s SET s.createdAt = :at WHERE s.id = :id")
                .setParameter("at", at)
                .setParameter("id", submission.getId())
                .executeUpdate();
        return submission;
    }

    private void markAdminSubmission(Submission submission) {
        entityManager.getEntityManager()
                .createQuery("UPDATE Submission s SET s.adminSubmission = true WHERE s.id = :id")
                .setParameter("id", submission.getId())
                .executeUpdate();
    }
}
