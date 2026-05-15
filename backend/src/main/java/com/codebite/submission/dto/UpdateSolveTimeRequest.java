package com.codebite.submission.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record UpdateSolveTimeRequest(
        @NotNull @PositiveOrZero Integer solveTimeSeconds
) {
}
