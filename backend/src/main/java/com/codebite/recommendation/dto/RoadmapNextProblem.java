package com.codebite.recommendation.dto;

import com.codebite.problem.entity.Difficulty;

public record RoadmapNextProblem(
        String slug,
        String title,
        Difficulty difficulty
) {
}
