package com.codebite.solution.dto;

import com.codebite.solution.entity.ReportStatus;
import com.codebite.solution.entity.ReportTargetType;

import java.time.Instant;

public record ReportListItem(
        Long id,
        ReportTargetType targetType,
        Long targetId,
        String reporterUsername,
        String reason,
        ReportStatus status,
        String preview,
        Instant createdAt
) {
}
