package com.codebite.solution.service;

import com.codebite.problem.entity.Tag;
import com.codebite.solution.dto.CommentResponse;
import com.codebite.solution.dto.SolutionDetail;
import com.codebite.solution.dto.SolutionListItem;
import com.codebite.solution.entity.Solution;
import com.codebite.solution.entity.SolutionComment;
import com.codebite.solution.entity.VoteDirection;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public final class SolutionMapper {

    private SolutionMapper() {
    }

    public static SolutionListItem toListItem(Solution s) {
        return new SolutionListItem(
                s.getId(),
                s.getTitle(),
                s.getAuthor().getUsername(),
                s.getAuthor().getAvatarUrl(),
                List.copyOf(s.getLanguages()),
                s.getTags().stream()
                        .map(SolutionMapper::tagSummary)
                        .sorted((a, b) -> a.name().compareTo(b.name()))
                        .collect(Collectors.toList()),
                s.getUpvotesCount(),
                s.getDownvotesCount(),
                s.getCommentsCount(),
                s.getCreatedAt()
        );
    }

    public static SolutionDetail toDetail(Solution s, VoteDirection viewerVote, Long viewerId) {
        boolean owned = viewerId != null && viewerId.equals(s.getAuthor().getId());
        Long sourceSubmissionId = s.getSourceSubmission() != null ? s.getSourceSubmission().getId() : null;
        return new SolutionDetail(
                s.getId(),
                s.getProblem().getSlug(),
                s.getTitle(),
                s.getContent(),
                s.getAuthor().getUsername(),
                s.getAuthor().getAvatarUrl(),
                s.getAuthor().getId(),
                List.copyOf(s.getLanguages()),
                s.getTags().stream()
                        .map(SolutionMapper::tagSummary)
                        .sorted((a, b) -> a.name().compareTo(b.name()))
                        .collect(Collectors.toList()),
                s.getUpvotesCount(),
                s.getDownvotesCount(),
                s.getCommentsCount(),
                s.getViewsCount(),
                s.isPublished(),
                sourceSubmissionId,
                viewerVote,
                owned,
                s.getCreatedAt(),
                s.getUpdatedAt()
        );
    }

    public static CommentResponse toCommentResponse(SolutionComment c, Long viewerId, List<CommentResponse> replies) {
        boolean owned = viewerId != null && viewerId.equals(c.getAuthor().getId());
        return new CommentResponse(
                c.getId(),
                c.getSolution().getId(),
                c.getParentComment() != null ? c.getParentComment().getId() : null,
                c.getAuthor().getUsername(),
                c.getAuthor().getAvatarUrl(),
                c.getAuthor().getId(),
                c.getContent(),
                c.isEdited(),
                owned,
                c.getCreatedAt(),
                c.getUpdatedAt(),
                replies != null ? replies : Collections.emptyList()
        );
    }

    private static SolutionListItem.TagSummary tagSummary(Tag t) {
        return new SolutionListItem.TagSummary(t.getId(), t.getName(), t.getSlug());
    }
}
