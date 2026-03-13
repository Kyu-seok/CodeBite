package com.codebite.auth.dto;

import com.codebite.user.dto.UserProfile;

public record AuthResponse(String token, String tokenType, UserProfile user) {

    public AuthResponse(String token, UserProfile user) {
        this(token, "Bearer", user);
    }
}
