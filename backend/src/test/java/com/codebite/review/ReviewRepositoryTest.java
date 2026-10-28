package com.codebite.review;

import com.codebite.common.time.DayCount;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.entity.TestCase;
import com.codebite.review.entity.Confidence;
import com.codebite.review.repository.ReviewRepository;
import com.codebite.review.repository.TagConfidenceCount;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** The two constructor projections of ReviewRepository, each with its zero-rows case. */
@DataJpaTest
@ActiveProfiles("test")
@Sql(statements = {
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM test_cases",
        "DELETE FROM problem_tags",
        "DELETE FROM problems",
        "DELETE FROM tags",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class ReviewRepositoryTest {

    @Autowired private ReviewRepository reviewRepository;
    @Autowired private TestEntityManager entityManager;

    private User user;
    private Problem arraysProblem;
    private Problem treesProblem;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUsername("review-user");
        user.setEmail("review@test.com");
        user.setPasswordHash("hash");
        user = entityManager.persist(user);
        arraysProblem = persistProblem("review-arrays", persistTag("arrays", "Arrays"));
        treesProblem = persistProblem("review-trees", persistTag("trees", "Trees"));
        entityManager.flush();
    }

    @Test
    void countDailyReviews_isEmptyWithoutRatings_andCountsRatingsPerDay() {
        assertEquals(List.of(), reviewRepository.countDailyReviews(user.getId(), Instant.EPOCH));

        // Noon UTC keeps the day the same in any session timezone the CAST may use.
        rate(arraysProblem, Confidence.GOOD, "2026-03-01T12:00:00Z");
        rate(arraysProblem, Confidence.EASY, "2026-03-01T12:30:00Z");
        rate(treesProblem, Confidence.AGAIN, "2026-03-03T12:00:00Z");
        submit(treesProblem); // graded but never rated
        entityManager.flush();

        assertEquals(List.of(new DayCount(LocalDate.parse("2026-03-01"), 2), new DayCount(LocalDate.parse("2026-03-03"), 1)),
                reviewRepository.countDailyReviews(user.getId(), Instant.EPOCH));
        assertEquals(List.of(new DayCount(LocalDate.parse("2026-03-03"), 1)),
                reviewRepository.countDailyReviews(user.getId(), Instant.parse("2026-03-02T00:00:00Z")));
    }

    @Test
    void countConfidenceByTag_isEmptyWithoutRatings_andCountsPerTagAndConfidence() {
        assertEquals(List.of(), reviewRepository.countConfidenceByTag(user.getId()));

        rate(arraysProblem, Confidence.GOOD, "2026-03-01T12:00:00Z");
        rate(arraysProblem, Confidence.GOOD, "2026-03-02T12:00:00Z");
        rate(arraysProblem, Confidence.AGAIN, "2026-03-03T12:00:00Z");
        rate(treesProblem, Confidence.HARD, "2026-03-03T12:00:00Z");
        submit(treesProblem);
        entityManager.flush();

        assertEquals(Set.of(
                        new TagConfidenceCount("arrays", "Arrays", Confidence.GOOD, 2),
                        new TagConfidenceCount("arrays", "Arrays", Confidence.AGAIN, 1),
                        new TagConfidenceCount("trees", "Trees", Confidence.HARD, 1)),
                Set.copyOf(reviewRepository.countConfidenceByTag(user.getId())));
    }

    private void rate(Problem problem, Confidence confidence, String reviewedAt) {
        Submission submission = submit(problem);
        submission.setConfidence(confidence);
        submission.setReviewedAt(Instant.parse(reviewedAt));
    }

    private Submission submit(Problem problem) {
        TestCase testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput("1");
        testCase.setExpectedOutput("1");
        testCase.setOrderIndex(1);
        testCase = entityManager.persist(testCase);
        Submission submission = Submission.pending(user, problem, "python", "x");
        submission.grade(Verdict.of(List.of(new CaseVerdict(SubmissionStatus.ACCEPTED, true, "", null, null, 1, 1))),
                List.of(testCase));
        return entityManager.persist(submission);
    }

    private Tag persistTag(String slug, String name) {
        Tag tag = new Tag();
        tag.setSlug(slug);
        tag.setName(name);
        return entityManager.persist(tag);
    }

    private Problem persistProblem(String slug, Tag tag) {
        Problem problem = new Problem();
        problem.setTitle(slug);
        problem.setSlug(slug);
        problem.setDescription("d");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem.getTags().add(tag);
        return entityManager.persist(problem);
    }
}
