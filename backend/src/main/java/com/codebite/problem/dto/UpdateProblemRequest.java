package com.codebite.problem.dto;

import com.codebite.problem.entity.Difficulty;

public record UpdateProblemRequest(
        String title,
        String description,
        Difficulty difficulty,
        String constraints,
        Boolean published
) {
}
