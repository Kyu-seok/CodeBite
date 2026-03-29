package com.codebite.profile.dto;

import java.time.Instant;

public record RecentSubmission(
        Long id,
        String problemTitle,
        String problemSlug,
        String difficulty,
        String status,
        String language,
        Integer runtimeMs,
        Integer memoryKb,
        Instant createdAt
) {}
