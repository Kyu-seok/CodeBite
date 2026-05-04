package com.codebite.solution.dto;

import com.codebite.solution.entity.VoteDirection;

import java.time.Instant;
import java.util.List;

public record SolutionDetail(
        Long id,
        String problemSlug,
        String title,
        String content,
        String authorUsername,
        String authorAvatarUrl,
        Long authorId,
        List<String> languages,
        List<SolutionListItem.TagSummary> tags,
        int upvotesCount,
        int downvotesCount,
        int commentsCount,
        int viewsCount,
        boolean published,
        Long sourceSubmissionId,
        VoteDirection viewerVote,
        boolean ownedByViewer,
        Instant createdAt,
        Instant updatedAt
) {
}
