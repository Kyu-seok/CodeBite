package com.codebite.problem;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DataJpaTest
@ActiveProfiles("test")
@Sql(statements = {"DELETE FROM test_cases", "DELETE FROM problems"}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class ProblemRepositoryTest {

    @Autowired
    private ProblemRepository problemRepository;

    @Autowired
    private TestEntityManager entityManager;

    private Problem createProblem(String title, String slug, Difficulty difficulty, boolean published) {
        Problem p = new Problem();
        p.setTitle(title);
        p.setSlug(slug);
        p.setDescription("Description for " + title);
        p.setDifficulty(difficulty);
        p.setPublished(published);
        return p;
    }

    @Test
    void save_and_findBySlug() {
        Problem problem = createProblem("Two Sum", "pair-sum", Difficulty.EASY, true);
        problemRepository.save(problem);

        Optional<Problem> found = problemRepository.findBySlug("pair-sum");
        assertTrue(found.isPresent());
        assertEquals("Two Sum", found.get().getTitle());
    }

    @Test
    void existsBySlug_returnsTrue() {
        Problem problem = createProblem("FizzBuzz", "fizzbuzz", Difficulty.EASY, true);
        problemRepository.save(problem);

        assertTrue(problemRepository.existsBySlug("fizzbuzz"));
        assertFalse(problemRepository.existsBySlug("nonexistent"));
    }

    @Test
    void findByPublishedTrue_pagination() {
        problemRepository.save(createProblem("P1", "p1", Difficulty.EASY, true));
        problemRepository.save(createProblem("P2", "p2", Difficulty.MEDIUM, true));
        problemRepository.save(createProblem("P3", "p3", Difficulty.HARD, false));

        Page<Problem> page = problemRepository.findByPublishedTrue(PageRequest.of(0, 10));
        assertEquals(2, page.getTotalElements());
    }

    @Test
    void findByPublishedTrueAndDifficulty_filters() {
        problemRepository.save(createProblem("E1", "e1", Difficulty.EASY, true));
        problemRepository.save(createProblem("E2", "e2", Difficulty.EASY, true));
        problemRepository.save(createProblem("M1", "m1", Difficulty.MEDIUM, true));

        Page<Problem> page = problemRepository.findByPublishedTrueAndDifficulty(
                Difficulty.EASY, PageRequest.of(0, 10));
        assertEquals(2, page.getTotalElements());
    }

    @Test
    void cascadeDelete_removesTestCases() {
        Problem problem = createProblem("CascadeTest", "cascade-test", Difficulty.EASY, true);
        TestCase tc = new TestCase();
        tc.setProblem(problem);
        tc.setInput("{\"x\": 1}");
        tc.setExpectedOutput("1");
        tc.setSample(true);
        tc.setOrderIndex(1);
        problem.getTestCases().add(tc);

        problem = problemRepository.save(problem);
        Long problemId = problem.getId();

        problemRepository.deleteById(problemId);
        entityManager.flush();

        assertFalse(problemRepository.findById(problemId).isPresent());
    }

}
