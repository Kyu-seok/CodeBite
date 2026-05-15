package com.codebite.review.dto;

import com.codebite.review.entity.Confidence;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record SetReviewRequest(
        @NotNull Confidence confidence,
        @Size(max = 500) String notes
) {
}
