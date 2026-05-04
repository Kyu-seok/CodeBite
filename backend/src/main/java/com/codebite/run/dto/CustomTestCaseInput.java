package com.codebite.run.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CustomTestCaseInput(
        @NotNull @Size(max = 10_000) String input,
        @Size(max = 10_000) String expectedOutput
) {
}
