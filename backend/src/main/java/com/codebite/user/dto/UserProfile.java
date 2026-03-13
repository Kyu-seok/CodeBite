package com.codebite.user.dto;

import com.codebite.user.entity.Role;

import java.time.Instant;

public record UserProfile(Long id, String username, String email, Role role, Instant createdAt) {
}
