package com.codebite.solution.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ReportRequest(
        @NotBlank @Size(min = 1, max = 500) String reason
) {
}
