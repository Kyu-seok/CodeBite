package com.codebite.solution.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

import java.util.Set;

public record CreateSolutionRequest(
        @NotBlank @Size(min = 5, max = 100) String title,
        @NotBlank @Size(min = 50, max = 50_000) String content,
        @NotEmpty @Size(max = 4) Set<String> languages,
        @Size(max = 5) Set<Long> tagIds,
        Long fromSubmissionId
) {
}
