package com.codebite.roadmap.dto;

import com.codebite.problem.entity.Difficulty;

public record RoadmapProblemDto(
        Long id,
        String title,
        String slug,
        Difficulty difficulty,
        String status
) {}
