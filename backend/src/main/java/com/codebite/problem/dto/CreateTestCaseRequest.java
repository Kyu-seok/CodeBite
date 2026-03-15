package com.codebite.problem.dto;

import jakarta.validation.constraints.NotBlank;

public record CreateTestCaseRequest(
        @NotBlank String input,
        @NotBlank String expectedOutput,
        Boolean sample,
        Integer orderIndex
) {
}
