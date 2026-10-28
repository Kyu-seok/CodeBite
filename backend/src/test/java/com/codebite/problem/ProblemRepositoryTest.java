package com.codebite.problem;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.DifficultyCount;
import com.codebite.problem.repository.TagCount;
import com.codebite.problem.repository.ProblemRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DataJpaTest
@ActiveProfiles("test")
@Sql(statements = {"DELETE FROM test_cases", "DELETE FROM problem_tags", "DELETE FROM problems", "DELETE FROM tags"},
        executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
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
    void countPublishedByDifficulty_countsPublishedOnly_andIsEmptyWithoutAny() {
        assertEquals(List.of(), problemRepository.countPublishedByDifficulty());
        assertEquals(List.of(), problemRepository.countPublishedByDifficultyAndCuration(50));

        Problem e1 = createProblem("E1", "e1", Difficulty.EASY, true);
        e1.setProblemNumber(1);
        Problem e2 = createProblem("E2", "e2", Difficulty.EASY, true);
        e2.setProblemNumber(80);
        problemRepository.save(e1);
        problemRepository.save(e2);
        problemRepository.save(createProblem("H1", "h1", Difficulty.HARD, false));

        assertEquals(List.of(new DifficultyCount(Difficulty.EASY, 2)), problemRepository.countPublishedByDifficulty());
        assertEquals(List.of(new DifficultyCount(Difficulty.EASY, 1)), problemRepository.countPublishedByDifficultyAndCuration(50));
    }

    @Test
    void countPublishedByTag_countsPublishedOnly_andIsEmptyWithoutAny() {
        assertEquals(List.of(), problemRepository.countPublishedByTag());

        Tag arrays = new Tag();
        arrays.setSlug("arrays");
        arrays.setName("Arrays");
        arrays = entityManager.persist(arrays);
        Problem p1 = createProblem("P1", "p1", Difficulty.EASY, true);
        p1.getTags().add(arrays);
        Problem p2 = createProblem("P2", "p2", Difficulty.EASY, false);
        p2.getTags().add(arrays);
        problemRepository.save(p1);
        problemRepository.save(p2);

        assertEquals(Set.of(new TagCount("Arrays", "arrays", 1)), Set.copyOf(problemRepository.countPublishedByTag()));
    }

    @Test
    void findRandomPublishedSlugsExcluding_skipsTheGivenIds_andUnpublished() {
        Problem solved = problemRepository.save(createProblem("Solved", "solved", Difficulty.EASY, true));
        Problem open = problemRepository.save(createProblem("Open", "open", Difficulty.EASY, true));
        problemRepository.save(createProblem("Draft", "draft", Difficulty.EASY, false));
        Problem hardOpen = problemRepository.save(createProblem("Hard", "hard", Difficulty.HARD, true));

        assertEquals(Set.of("open", "hard"), Set.copyOf(
                problemRepository.findRandomPublishedSlugsExcluding(Set.of(solved.getId()), PageRequest.of(0, 10))));
        assertEquals(List.of("hard"),
                problemRepository.findRandomPublishedSlugsByDifficultyExcluding(
                        Difficulty.HARD, Set.of(solved.getId()), PageRequest.of(0, 10)));
        assertEquals(List.of(),
                problemRepository.findRandomPublishedSlugsExcluding(
                        Set.of(solved.getId(), open.getId(), hardOpen.getId()), PageRequest.of(0, 10)));
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
