package com.codebite.admin.dto;

import com.codebite.user.entity.Role;

import java.time.Instant;

public record AdminUserDto(
        Long id,
        String username,
        String email,
        Role role,
        String avatarUrl,
        Instant createdAt,
        long solvedCount,
        Instant lastActiveAt
) {
}
