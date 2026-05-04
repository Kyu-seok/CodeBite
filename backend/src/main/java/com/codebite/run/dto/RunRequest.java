package com.codebite.run.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.List;

public record RunRequest(
        @NotBlank String language,
        @NotBlank @Size(max = 100_000) String sourceCode,
        @Valid @Size(max = 5) List<CustomTestCaseInput> customTestCases
) {
}
