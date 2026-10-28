package com.codebite.user.repository;

import com.codebite.user.entity.Role;

import java.time.Instant;

/**
 * One user on the admin users page: the account, how many problems they have Solved (Accepted,
 * non-admin, each problem once) and when they last submitted anything.
 */
public record UserOverview(Long id, String username, String email, Role role, String avatarUrl,
                           Instant createdAt, long solvedCount, Instant lastSubmittedAt) {
}
