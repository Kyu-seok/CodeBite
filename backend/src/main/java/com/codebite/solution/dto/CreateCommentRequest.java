package com.codebite.solution.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateCommentRequest(
        @NotBlank @Size(min = 1, max = 2000) String content,
        Long parentCommentId
) {
}
