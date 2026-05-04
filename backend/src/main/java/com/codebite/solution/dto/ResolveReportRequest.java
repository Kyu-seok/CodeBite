package com.codebite.solution.dto;

import jakarta.validation.constraints.NotNull;

public record ResolveReportRequest(
        @NotNull ResolveAction action
) {
    public enum ResolveAction {
        DISMISS,
        HIDE_CONTENT,
        DELETE_CONTENT
    }
}
