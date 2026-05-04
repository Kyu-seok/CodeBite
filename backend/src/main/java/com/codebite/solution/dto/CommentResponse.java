package com.codebite.solution.dto;

import java.time.Instant;
import java.util.List;

public record CommentResponse(
        Long id,
        Long solutionId,
        Long parentCommentId,
        String authorUsername,
        String authorAvatarUrl,
        Long authorId,
        String content,
        boolean edited,
        boolean ownedByViewer,
        Instant createdAt,
        Instant updatedAt,
        List<CommentResponse> replies
) {
}
