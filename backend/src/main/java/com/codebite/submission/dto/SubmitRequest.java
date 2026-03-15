package com.codebite.submission.dto;

import jakarta.validation.constraints.NotBlank;

public record SubmitRequest(
        @NotBlank String language,
        @NotBlank String sourceCode
) {
}
