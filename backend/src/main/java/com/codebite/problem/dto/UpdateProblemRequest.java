package com.codebite.problem.dto;

import com.codebite.problem.entity.Difficulty;

import java.util.Map;

public record UpdateProblemRequest(
        String title,
        String description,
        Difficulty difficulty,
        Map<String, String> starterCode,
        Map<String, String> driverCode,
        String constraints,
        Boolean published
) {
}
