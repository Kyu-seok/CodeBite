package com.codebite.auth.jwt;

import com.codebite.user.entity.Role;

public record JwtUserPrincipal(Long id, String username, Role role) {
}
