package com.codebite.roadmap;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemTranslationRepository;
import com.codebite.progress.UserProgress;
import com.codebite.roadmap.dto.RoadmapCategoryDto;
import com.codebite.roadmap.dto.RoadmapProblemDto;
import com.codebite.roadmap.entity.RoadmapCategory;
import com.codebite.roadmap.repository.RoadmapCategoryRepository;
import com.codebite.roadmap.service.RoadmapService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RoadmapServiceTest {

    @Mock private RoadmapCategoryRepository categoryRepository;
    @Mock private UserProgress userProgress;
    @Mock private ProblemTranslationRepository translationRepository;

    private RoadmapService service;

    @BeforeEach
    void setUp() {
        service = new RoadmapService(categoryRepository, userProgress, translationRepository);
    }

    @Test
    void theRoadmapNeverShowsTheTutorialProblem() {
        Problem tutorial = problem(10L, "piggy-bank-total", 0);
        Problem normal = problem(11L, "pair-sum", 1);
        when(categoryRepository.findAllByOrderByDisplayOrderAsc())
                .thenReturn(List.of(category(1L, "arrays", tutorial, normal)));
        when(userProgress.statusByProblem(eq(7L), any())).thenReturn(Map.of());

        assertEquals(List.of(List.of("pair-sum")), slugs(service.getRoadmap(7L).categories()));
        assertEquals(List.of(List.of("pair-sum")), slugs(service.getRoadmap(null).categories()));
    }

    private static List<List<String>> slugs(List<RoadmapCategoryDto> categories) {
        return categories.stream().map(c -> c.problems().stream().map(RoadmapProblemDto::slug).toList()).toList();
    }

    private static Problem problem(Long id, String slug, int number) {
        Problem p = new Problem();
        p.setId(id);
        p.setSlug(slug);
        p.setTitle(slug);
        p.setDifficulty(Difficulty.EASY);
        p.setProblemNumber(number);
        p.setPublished(true);
        return p;
    }

    private static RoadmapCategory category(Long id, String slug, Problem... problems) {
        RoadmapCategory c = new RoadmapCategory();
        c.setId(id);
        c.setSlug(slug);
        c.setName(slug);
        c.setProblems(new ArrayList<>(List.of(problems)));
        return c;
    }
}
