package com.codebite.solution.dto;

import java.time.Instant;
import java.util.List;

public record SolutionListItem(
        Long id,
        String title,
        String authorUsername,
        String authorAvatarUrl,
        List<String> languages,
        List<TagSummary> tags,
        int upvotesCount,
        int downvotesCount,
        int commentsCount,
        Instant createdAt
) {
    public record TagSummary(Long id, String name, String slug) {
    }
}
