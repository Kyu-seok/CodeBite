package com.codebite.submission.dto;

import jakarta.validation.constraints.Size;

public record UpdateNoteRequest(
        @Size(max = 500) String notes
) {
}
