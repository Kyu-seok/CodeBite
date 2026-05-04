package com.codebite.solution.dto;

import com.codebite.solution.entity.VoteDirection;

public record VoteResponse(
        VoteDirection viewerVote,
        int upvotesCount,
        int downvotesCount
) {
}
