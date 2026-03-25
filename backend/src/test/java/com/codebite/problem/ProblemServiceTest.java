package com.codebite.problem;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.problem.dto.CreateProblemRequest;
import com.codebite.problem.dto.CreateTestCaseRequest;
import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.TestCaseDto;
import com.codebite.problem.dto.UpdateProblemRequest;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.problem.service.ProblemService;
import com.codebite.problem.service.StarterCodeLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProblemServiceTest {

    @Mock
    private ProblemRepository problemRepository;

    @Mock
    private TestCaseRepository testCaseRepository;

    @Mock
    private StarterCodeLoader starterCodeLoader;

    private ProblemService problemService;

    @BeforeEach
    void setUp() {
        problemService = new ProblemService(problemRepository, testCaseRepository, starterCodeLoader);
    }

    private Problem buildProblem(Long id, String title, String slug, boolean published) {
        Problem p = new Problem();
        p.setId(id);
        p.setTitle(title);
        p.setSlug(slug);
        p.setDescription("Description");
        p.setDifficulty(Difficulty.EASY);
        p.setPublished(published);
        return p;
    }

    @Test
    void listPublishedProblems_returnsPage() {
        Problem p1 = buildProblem(1L, "Two Sum", "two-sum", true);
        Page<Problem> page = new PageImpl<>(List.of(p1));
        when(problemRepository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);

        Page<ProblemListItem> result = problemService.listPublishedProblems(null, null, null, PageRequest.of(0, 10));
        assertEquals(1, result.getTotalElements());
        assertEquals("Two Sum", result.getContent().get(0).title());
    }

    @Test
    void listPublishedProblems_withDifficultyFilter() {
        Problem p1 = buildProblem(1L, "Easy One", "easy-one", true);
        Page<Problem> page = new PageImpl<>(List.of(p1));
        when(problemRepository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);

        Page<ProblemListItem> result = problemService.listPublishedProblems(Difficulty.EASY, null, null, PageRequest.of(0, 10));
        assertEquals(1, result.getTotalElements());
    }

    @Test
    void getProblemBySlug_returnsDetail() {
        Problem problem = buildProblem(1L, "Two Sum", "two-sum", true);
        when(problemRepository.findBySlug("two-sum")).thenReturn(Optional.of(problem));
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L)).thenReturn(List.of());
        when(starterCodeLoader.getStarterCode("two-sum")).thenReturn(Map.of("java", "class Solution {}"));

        ProblemDetail detail = problemService.getProblemBySlug("two-sum");
        assertEquals("Two Sum", detail.title());
        assertEquals("two-sum", detail.slug());
        assertEquals(Map.of("java", "class Solution {}"), detail.starterCode());
    }

    @Test
    void getProblemBySlug_notFound_throws() {
        when(problemRepository.findBySlug("missing")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> problemService.getProblemBySlug("missing"));
    }

    @Test
    void getProblemBySlug_unpublished_throws() {
        Problem problem = buildProblem(1L, "Draft", "draft", false);
        when(problemRepository.findBySlug("draft")).thenReturn(Optional.of(problem));

        assertThrows(ResourceNotFoundException.class,
                () -> problemService.getProblemBySlug("draft"));
    }

    @Test
    void createProblem_slugifiesTitle() {
        when(problemRepository.existsBySlug("two-sum")).thenReturn(false);
        when(problemRepository.save(any())).thenAnswer(inv -> {
            Problem p = inv.getArgument(0);
            p.setId(1L);
            return p;
        });

        CreateProblemRequest request = new CreateProblemRequest(
                "Two Sum", "Description", Difficulty.EASY,
                "constraints", true);

        ProblemDetail result = problemService.createProblem(request);
        assertEquals("two-sum", result.slug());
    }

    @Test
    void createProblem_slugCollision_appendsSuffix() {
        when(problemRepository.existsBySlug("two-sum")).thenReturn(true);
        when(problemRepository.existsBySlug("two-sum-2")).thenReturn(false);
        when(problemRepository.save(any())).thenAnswer(inv -> {
            Problem p = inv.getArgument(0);
            p.setId(1L);
            return p;
        });

        CreateProblemRequest request = new CreateProblemRequest(
                "Two Sum", "Description", Difficulty.EASY, null, false);

        ProblemDetail result = problemService.createProblem(request);
        assertEquals("two-sum-2", result.slug());
    }

    @Test
    void updateProblem_partialUpdate() {
        Problem existing = buildProblem(1L, "Old Title", "old-title", false);
        when(problemRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(problemRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L)).thenReturn(List.of());

        UpdateProblemRequest request = new UpdateProblemRequest(
                null, null, null, null, true);

        ProblemDetail result = problemService.updateProblem(1L, request);
        assertTrue(result.published());
        assertEquals("Old Title", result.title());
    }

    @Test
    void updateProblem_notFound_throws() {
        when(problemRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> problemService.updateProblem(99L, new UpdateProblemRequest(
                        null, null, null, null, null)));
    }

    @Test
    void addTestCase_success() {
        Problem problem = buildProblem(1L, "Problem", "problem", true);
        when(problemRepository.findById(1L)).thenReturn(Optional.of(problem));
        when(testCaseRepository.save(any())).thenAnswer(inv -> {
            TestCase tc = inv.getArgument(0);
            tc.setId(1L);
            return tc;
        });

        CreateTestCaseRequest request = new CreateTestCaseRequest(
                "{\"x\": 1}", "1", true, 1);

        TestCaseDto result = problemService.addTestCase(1L, request);
        assertNotNull(result);
        assertEquals("{\"x\": 1}", result.input());
        assertTrue(result.sample());
    }

    @Test
    void addTestCase_problemNotFound_throws() {
        when(problemRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class,
                () -> problemService.addTestCase(99L, new CreateTestCaseRequest(
                        "input", "output", false, 0)));
    }
}
