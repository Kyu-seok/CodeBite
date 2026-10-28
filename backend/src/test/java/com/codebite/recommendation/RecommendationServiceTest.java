package com.codebite.recommendation;

import com.codebite.recommendation.dto.WeakCategoryItem;
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

import java.util.List;

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
}
