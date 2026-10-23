package com.codebite.github.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/** The Solution Repository chosen after an install granted several, with the callback's selection token. */
public record GitHubRepositoryChoiceRequest(
        @NotBlank String selectionToken,
        @NotNull Long repositoryId) {
}
