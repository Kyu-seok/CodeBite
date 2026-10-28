package com.codebite.submission;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.submission.repository.SubmissionResultRepository;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DataJpaTest
@ActiveProfiles("test")
@Sql(statements = {
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM test_cases",
        "DELETE FROM problems",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class SubmissionRepositoryTest {

    @Autowired
    private SubmissionRepository submissionRepository;

    @Autowired
    private SubmissionResultRepository submissionResultRepository;

    @Autowired
    private TestEntityManager entityManager;

    private User user;
    private Problem problem;
    private TestCase testCase;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUsername("testuser");
        user.setEmail("test@test.com");
        user.setPasswordHash("hash");
        user = entityManager.persist(user);

        problem = new Problem();
        problem.setTitle("Two Sum");
        problem.setSlug("two-sum-repo");
        problem.setDescription("Description");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem = entityManager.persist(problem);

        testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput("[2,7,11,15]\n9");
        testCase.setExpectedOutput("[0,1]");
        testCase.setSample(true);
        testCase.setOrderIndex(1);
        testCase = entityManager.persist(testCase);

        entityManager.flush();
    }

    @Test
    void save_and_findById() {
        Submission submission = createSubmission(SubmissionStatus.ACCEPTED);
        submission = submissionRepository.save(submission);

        assertTrue(submissionRepository.findById(submission.getId()).isPresent());
    }

    @Test
    void findByUserIdAndProblemId_orderedByCreatedAtDesc() {
        Submission s1 = submissionRepository.save(createSubmission(SubmissionStatus.WRONG_ANSWER));
        Submission s2 = submissionRepository.save(createSubmission(SubmissionStatus.ACCEPTED));

        List<Submission> results = submissionRepository
                .findByUserIdAndProblemIdOrderByCreatedAtDesc(user.getId(), problem.getId());

        assertEquals(2, results.size());
        // Most recent first
        assertEquals(s2.getId(), results.get(0).getId());
        assertEquals(s1.getId(), results.get(1).getId());
    }

    @Test
    void findByUserIdAndProblemId_emptyForOtherUser() {
        submissionRepository.save(createSubmission(SubmissionStatus.ACCEPTED));

        User otherUser = new User();
        otherUser.setUsername("other");
        otherUser.setEmail("other@test.com");
        otherUser.setPasswordHash("hash");
        otherUser = entityManager.persist(otherUser);
        entityManager.flush();

        List<Submission> results = submissionRepository
                .findByUserIdAndProblemIdOrderByCreatedAtDesc(otherUser.getId(), problem.getId());
        assertTrue(results.isEmpty());
    }

    @Test
    void cascadeDelete_removesResults() {
        Submission submission = submissionRepository.save(createSubmission(SubmissionStatus.ACCEPTED));

        SubmissionResult result = new SubmissionResult();
        result.setSubmission(submission);
        result.setTestCase(testCase);
        result.setStatus(SubmissionStatus.ACCEPTED);
        result.setActualOutput("[0,1]");
        submissionResultRepository.save(result);

        entityManager.flush();

        submissionRepository.deleteById(submission.getId());
        entityManager.flush();

        assertFalse(submissionRepository.findById(submission.getId()).isPresent());
        assertTrue(submissionResultRepository.findBySubmissionIdOrderById(submission.getId()).isEmpty());
    }

    @Test
    void submissionResultRepository_findBySubmissionIdOrderById() {
        Submission submission = submissionRepository.save(createSubmission(SubmissionStatus.ACCEPTED));

        SubmissionResult r1 = new SubmissionResult();
        r1.setSubmission(submission);
        r1.setTestCase(testCase);
        r1.setStatus(SubmissionStatus.ACCEPTED);
        r1.setActualOutput("[0,1]");
        submissionResultRepository.save(r1);

        List<SubmissionResult> results = submissionResultRepository.findBySubmissionIdOrderById(submission.getId());
        assertEquals(1, results.size());
        assertEquals(SubmissionStatus.ACCEPTED, results.get(0).getStatus());
    }

    /** Graded with no result rows when Accepted, so tests can add their own rows explicitly. */
    private Submission createSubmission(SubmissionStatus status) {
        Submission submission = Submission.pending(user, problem, "java", "class Solution {}");
        if (status == SubmissionStatus.ACCEPTED) {
            submission.grade(Verdict.empty(), List.of());
        } else {
            submission.grade(Verdict.of(List.of(new CaseVerdict(status, true, "", null, null, 1, 1))),
                    List.of(testCase));
        }
        return submission;
    }

    /** Dropping the explicit saveAll of result rows relies on this cascade. */
    @Test
    void save_cascadesTheResultRowsGradeAdded() {
        Submission submission = Submission.pending(user, problem, "java", "class Solution {}");
        submission.grade(Verdict.of(List.of(
                new CaseVerdict(SubmissionStatus.WRONG_ANSWER, true, "[1,0]", null, null, 5, 100))), List.of(testCase));

        submission = submissionRepository.save(submission);
        entityManager.flush();
        entityManager.clear();

        List<SubmissionResult> rows = submissionResultRepository.findBySubmissionIdOrderById(submission.getId());
        assertEquals(1, rows.size());
        assertEquals(SubmissionStatus.WRONG_ANSWER, rows.get(0).getStatus());
        assertEquals("[1,0]", rows.get(0).getActualOutput());
        assertEquals(testCase.getId(), rows.get(0).getTestCase().getId());
        assertEquals(SubmissionStatus.WRONG_ANSWER,
                submissionRepository.findById(submission.getId()).orElseThrow().getStatus());
    }
}
