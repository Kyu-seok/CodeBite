package com.codebite.problem;

import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.ProblemStats;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.service.ProblemCatalogue;
import com.codebite.problem.service.ProblemDtos;
import com.codebite.progress.ProblemPopularity;
import com.codebite.progress.UserProgress;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.entity.SubmissionStatus;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * The Tutorial Problem (#0, docs/adr/0007) in the catalogue, against a real database: in no
 * curation and never the random pick, but in the plain list, first, and on its detail page.
 */
@DataJpaTest
@ActiveProfiles("test")
@Import({ProblemCatalogue.class, UserProgress.class, ProblemPopularity.class, ProblemDtos.class,
        ProblemCatalogueTutorialTest.Assets.class})
@Sql(statements = {
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM test_cases",
        "DELETE FROM problem_tags",
        "DELETE FROM problems",
        "DELETE FROM tags",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class ProblemCatalogueTutorialTest {

    @TestConfiguration
    static class Assets {
        @Bean
        ProblemAssets problemAssets() {
            return new ProblemAssets("classpath:problem-assets/");
        }
    }

    private static final PageRequest BY_NUMBER = PageRequest.of(0, 20, Sort.by("problemNumber").ascending());

    @Autowired private ProblemCatalogue catalogue;
    @Autowired private TestEntityManager entityManager;

    private Problem tutorial;
    private Problem normal;

    @BeforeEach
    void setUp() {
        tutorial = persistProblem("piggy-bank-total", 0);
        normal = persistProblem("pair-sum", 1);
        entityManager.flush();
    }

    @Test
    void thePlainListShowsTheTutorialProblemFirst_aCurationLeavesItOut() {
        assertEquals(List.of("piggy-bank-total", "pair-sum"),
                slugs(catalogue.listPublishedProblems(null, null, null, null, null, BY_NUMBER).getContent()));
        assertEquals(List.of("pair-sum"),
                slugs(catalogue.listPublishedProblems(null, null, null, "CB50", null, BY_NUMBER).getContent()));
    }

    @Test
    void headerCountsLeaveTheTutorialProblemOutOfACurationOnly() {
        User user = persistUser("tutorial-user", Role.USER);
        accept(user, tutorial);
        accept(user, normal);
        entityManager.flush();

        assertEquals(new ProblemStats(2, 0, 0, 2, 0, 0), catalogue.getStats(user.getId(), null));
        assertEquals(new ProblemStats(1, 0, 0, 1, 0, 0), catalogue.getStats(user.getId(), "CB50"));
        assertEquals(new ProblemStats(1, 0, 0, 0, 0, 0), catalogue.getStats(null, "CB100"));
    }

    @Test
    void theRandomPickIsNeverTheTutorialProblem() {
        User user = persistUser("tutorial-user", Role.USER);
        entityManager.flush();
        for (int i = 0; i < 20; i++) {
            assertEquals("pair-sum", catalogue.getRandomProblemSlug(null, null));
            assertEquals("pair-sum", catalogue.getRandomProblemSlug(Difficulty.EASY, null));
            assertEquals("pair-sum", catalogue.getRandomProblemSlug(null, user.getId()));
        }
    }

    @Test
    void theRandomPickIsNeverTheTutorialProblem_evenWhenTheRestIsSolved() {
        User user = persistUser("tutorial-user", Role.USER);
        accept(user, normal);
        entityManager.flush();
        for (int i = 0; i < 20; i++) {
            assertEquals("pair-sum", catalogue.getRandomProblemSlug(null, user.getId()));
            assertEquals("pair-sum", catalogue.getRandomProblemSlug(Difficulty.EASY, user.getId()));
        }
    }

    @Test
    void theListAndDetailPageLabelTheTutorialProblemOnly() {
        List<ProblemListItem> items =
                catalogue.listPublishedProblems(null, null, null, null, null, BY_NUMBER).getContent();
        assertEquals(List.of(true, false), items.stream().map(ProblemListItem::tutorial).toList());

        assertTrue(catalogue.getProblemBySlug("piggy-bank-total").tutorial());
        assertFalse(catalogue.getProblemBySlug("pair-sum").tutorial());
    }

    private static List<String> slugs(List<ProblemListItem> items) {
        return items.stream().map(ProblemListItem::slug).toList();
    }

    private Problem persistProblem(String slug, int number) {
        Problem problem = new Problem();
        problem.setTitle(slug);
        problem.setSlug(slug);
        problem.setDescription("d");
        problem.setDifficulty(Difficulty.EASY);
        problem.setProblemNumber(number);
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

    private void accept(User owner, Problem problem) {
        Submission submission = Submission.pending(owner, problem, "python", "x");
        TestCase testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput("1");
        testCase.setExpectedOutput("1");
        testCase.setOrderIndex(1);
        testCase = entityManager.persist(testCase);
        submission.grade(Verdict.of(List.of(new CaseVerdict(SubmissionStatus.ACCEPTED, true, "", null, null, 1, 1))),
                List.of(testCase));
        entityManager.persist(submission);
    }
}
