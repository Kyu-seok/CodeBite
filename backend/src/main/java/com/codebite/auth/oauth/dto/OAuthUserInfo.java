package com.codebite.auth.oauth.dto;

public record OAuthUserInfo(String providerId, String email, String name, String avatarUrl) {
}
