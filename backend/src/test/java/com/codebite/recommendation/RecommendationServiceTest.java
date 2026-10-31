package com.codebite.recommendation;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.recommendation.dto.RoadmapNextItem;
import com.codebite.recommendation.dto.RoadmapNextProblem;
import com.codebite.recommendation.dto.WeakCategoryItem;
import com.codebite.roadmap.entity.RoadmapCategory;
import com.codebite.progress.UserProgress;
import com.codebite.recommendation.service.RecommendationService;
import com.codebite.review.entity.Confidence;
import com.codebite.review.repository.ReviewRepository;
import com.codebite.review.repository.TagConfidenceCount;
import com.codebite.roadmap.repository.RoadmapCategoryRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RecommendationServiceTest {

    @Mock private ReviewRepository reviewRepository;
    @Mock private RoadmapCategoryRepository roadmapRepository;
    @Mock private UserProgress userProgress;

    private RecommendationService service;

    @BeforeEach
    void setUp() {
        service = new RecommendationService(reviewRepository, roadmapRepository, userProgress);
    }

    @Test
    void weakTags_sortsAscendingByAverage_andLimits() {
        // Arrays: 4 EASY → avg 4.0
        // DP: 3 AGAIN, 1 GOOD → avg = (3*1 + 1*3) / 4 = 1.5
        // Trees: 2 HARD, 2 GOOD → avg = (2*2 + 2*3) / 4 = 2.5
        when(reviewRepository.countConfidenceByTag(1L)).thenReturn(List.of(
                new TagConfidenceCount("arrays", "Arrays", Confidence.EASY, 4),
                new TagConfidenceCount("dp", "DP", Confidence.AGAIN, 3),
                new TagConfidenceCount("dp", "DP", Confidence.GOOD, 1),
                new TagConfidenceCount("trees", "Trees", Confidence.HARD, 2),
                new TagConfidenceCount("trees", "Trees", Confidence.GOOD, 2)));

        List<WeakCategoryItem> weak = service.getWeakTags(1L, 2);

        assertEquals(2, weak.size());
        assertEquals("dp", weak.get(0).tagSlug());
        assertEquals(1.5, weak.get(0).avgConfidence(), 0.001);
        assertEquals(4L, weak.get(0).ratedSubmissionCount());
        assertEquals("trees", weak.get(1).tagSlug());
        assertEquals(2.5, weak.get(1).avgConfidence(), 0.001);
    }

    @Test
    void weakTags_emptyHistory_returnsEmpty() {
        when(reviewRepository.countConfidenceByTag(1L)).thenReturn(List.of());
        assertEquals(0, service.getWeakTags(1L, 3).size());
    }

    @Test
    void roadmapNext_neverOffersTheTutorialProblem() {
        Problem tutorial = problem(10L, "piggy-bank-total", 0);
        Problem normal = problem(11L, "pair-sum", 1);
        RoadmapCategory arrays = category(1L, "arrays", tutorial, normal);
        when(roadmapRepository.findAllByOrderByDisplayOrderAsc()).thenReturn(List.of(arrays));

        when(userProgress.solvedProblemIds(1L)).thenReturn(Set.of());
        assertEquals(List.of(List.of("pair-sum")), offeredSlugs(service.getRoadmapNext(1L)));

        when(userProgress.solvedProblemIds(1L)).thenReturn(Set.of(11L));
        assertEquals(List.of(), offeredSlugs(service.getRoadmapNext(1L)),
                "a category whose only unsolved problem is the Tutorial Problem is done");
    }

    private static List<List<String>> offeredSlugs(List<RoadmapNextItem> items) {
        return items.stream().map(i -> i.unsolvedProblems().stream().map(RoadmapNextProblem::slug).toList()).toList();
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
