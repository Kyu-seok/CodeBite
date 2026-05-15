package com.codebite.recommendation;

import com.codebite.recommendation.dto.WeakCategoryItem;
import com.codebite.recommendation.service.RecommendationService;
import com.codebite.review.entity.Confidence;
import com.codebite.roadmap.repository.RoadmapCategoryRepository;
import com.codebite.submission.repository.SubmissionRepository;
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

    @Mock private SubmissionRepository submissionRepository;
    @Mock private RoadmapCategoryRepository roadmapRepository;

    private RecommendationService service;

    @BeforeEach
    void setUp() {
        service = new RecommendationService(submissionRepository, roadmapRepository);
    }

    @Test
    void weakTags_sortsAscendingByAverage_andLimits() {
        // Arrays: 4 EASY → avg 4.0
        // DP: 3 AGAIN, 1 GOOD → avg = (3*1 + 1*3) / 4 = 1.5
        // Trees: 2 HARD, 2 GOOD → avg = (2*2 + 2*3) / 4 = 2.5
        when(submissionRepository.countConfidenceByTag(1L)).thenReturn(List.of(
                new Object[]{"arrays", "Arrays", Confidence.EASY, 4L},
                new Object[]{"dp", "DP", Confidence.AGAIN, 3L},
                new Object[]{"dp", "DP", Confidence.GOOD, 1L},
                new Object[]{"trees", "Trees", Confidence.HARD, 2L},
                new Object[]{"trees", "Trees", Confidence.GOOD, 2L}));

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
        when(submissionRepository.countConfidenceByTag(1L)).thenReturn(List.of());
        assertEquals(0, service.getWeakTags(1L, 3).size());
    }
}
