package com.codebite.problem;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.problem.service.ProblemDtos;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.repository.ProblemTranslationRepository;
import com.codebite.problem.service.ProblemCatalogue;
import com.codebite.progress.ProblemPopularity;
import com.codebite.progress.UserProgress;
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
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProblemCatalogueTest {

    @Mock private ProblemRepository problemRepository;
    @Mock private ProblemTranslationRepository translationRepository;
    @Mock private TestCaseRepository testCaseRepository;
    @Mock private ProblemPopularity problemPopularity;
    @Mock private UserProgress userProgress;

    private ProblemCatalogue problemService;

    @BeforeEach
    void setUp() {
        problemService = new ProblemCatalogue(problemRepository, translationRepository, testCaseRepository,
                problemPopularity, userProgress, new ProblemDtos(new ProblemAssets("classpath:problem-assets/")));
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
        Problem p1 = buildProblem(1L, "Two Sum", "pair-sum", true);
        Page<Problem> page = new PageImpl<>(List.of(p1));
        when(problemRepository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(problemPopularity.acceptanceRates(List.of(1L))).thenReturn(Map.of());

        Page<ProblemListItem> result = problemService.listPublishedProblems(null, null, null, null, null, PageRequest.of(0, 10));
        assertEquals(1, result.getTotalElements());
        assertEquals("Two Sum", result.getContent().get(0).title());
    }

    @Test
    void listPublishedProblems_withDifficultyFilter() {
        Problem p1 = buildProblem(1L, "Easy One", "easy-one", true);
        Page<Problem> page = new PageImpl<>(List.of(p1));
        when(problemRepository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(problemPopularity.acceptanceRates(List.of(1L))).thenReturn(Map.of());

        Page<ProblemListItem> result = problemService.listPublishedProblems(Difficulty.EASY, null, null, null, null, PageRequest.of(0, 10));
        assertEquals(1, result.getTotalElements());
    }

    @Test
    void getRandomProblemSlug_prefersAProblemTheUserHasNotSolved() {
        when(userProgress.solvedProblemIds(7L)).thenReturn(Set.of(1L, 2L));
        when(problemRepository.findRandomPublishedSlugsExcluding(eq(Set.of(1L, 2L)), any(PageRequest.class)))
                .thenReturn(List.of("fresh"));

        assertEquals("fresh", problemService.getRandomProblemSlug(null, 7L));
        verify(problemRepository, never()).findRandomPublishedSlugs(any());
    }

    @Test
    void getRandomProblemSlug_withNothingSolved_picksAnyWithoutAnEmptyNotIn() {
        when(userProgress.solvedProblemIds(7L)).thenReturn(Set.of());
        when(problemRepository.findRandomPublishedSlugs(any(PageRequest.class))).thenReturn(List.of("any"));

        assertEquals("any", problemService.getRandomProblemSlug(null, 7L));
        verify(problemRepository, never()).findRandomPublishedSlugsExcluding(any(), any());
    }

    @Test
    void getRandomProblemSlug_signedOut_picksAny() {
        when(problemRepository.findRandomPublishedSlugsByDifficulty(eq(Difficulty.HARD), any(PageRequest.class)))
                .thenReturn(List.of("any-hard"));

        assertEquals("any-hard", problemService.getRandomProblemSlug(Difficulty.HARD, null));
        verify(userProgress, never()).solvedProblemIds(any());
    }

    @Test
    void getRandomProblemSlug_noPublishedProblems_throws() {
        when(problemRepository.findRandomPublishedSlugs(any(PageRequest.class))).thenReturn(List.of());

        assertThrows(ResourceNotFoundException.class, () -> problemService.getRandomProblemSlug(null, null));
    }

    @Test
    void getProblemBySlug_returnsDetail() {
        Problem problem = buildProblem(1L, "Two Sum", "pair-sum", true);
        when(problemRepository.findBySlug("pair-sum")).thenReturn(Optional.of(problem));
        when(testCaseRepository.findByProblemIdAndSampleTrueOrderByOrderIndexAsc(1L)).thenReturn(List.of());

        ProblemDetail detail = problemService.getProblemBySlug("pair-sum");
        assertEquals("Two Sum", detail.title());
        assertEquals("pair-sum", detail.slug());
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
}
