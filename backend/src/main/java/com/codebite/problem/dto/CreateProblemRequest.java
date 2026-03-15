package com.codebite.problem.dto;

import com.codebite.problem.entity.Difficulty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.Map;

public record CreateProblemRequest(
        @NotBlank String title,
        @NotBlank String description,
        @NotNull Difficulty difficulty,
        Map<String, String> starterCode,
        Map<String, String> driverCode,
        String constraints,
        Boolean published
) {
}
