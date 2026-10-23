package com.codebite.github.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/** The query parameters GitHub sent to {@code /github/callback}, forwarded by the frontend. */
public record GitHubLinkCallbackRequest(
        @NotBlank String code,
        @NotNull Long installationId,
        @NotBlank String state) {
}
