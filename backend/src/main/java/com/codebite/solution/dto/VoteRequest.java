package com.codebite.solution.dto;

import com.codebite.solution.entity.VoteDirection;
import jakarta.validation.constraints.NotNull;

public record VoteRequest(
        @NotNull VoteDirection direction
) {
}
