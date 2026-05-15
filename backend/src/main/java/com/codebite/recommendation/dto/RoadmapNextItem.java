package com.codebite.recommendation.dto;

import java.util.List;

public record RoadmapNextItem(
        String categorySlug,
        String categoryName,
        String description,
        List<RoadmapNextProblem> unsolvedProblems
) {
}
