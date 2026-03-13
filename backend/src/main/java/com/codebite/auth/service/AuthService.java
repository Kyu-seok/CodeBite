package com.codebite.auth.service;

import com.codebite.auth.dto.AuthResponse;
import com.codebite.auth.dto.LoginRequest;
import com.codebite.auth.dto.RegisterRequest;
import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.user.dto.UserProfile;
import com.codebite.user.entity.User;
import com.codebite.user.service.UserService;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserService userService;
    private final JwtTokenProvider tokenProvider;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UserService userService, JwtTokenProvider tokenProvider, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.tokenProvider = tokenProvider;
        this.passwordEncoder = passwordEncoder;
    }

    public AuthResponse register(RegisterRequest request) {
        User user = userService.createUser(request.username(), request.email(), request.password());
        String token = tokenProvider.generateToken(user);
        return new AuthResponse(token, UserService.toProfile(user));
    }

    public AuthResponse login(LoginRequest request) {
        User user = userService.findByUsername(request.username());

        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new BadCredentialsException("Invalid username or password");
        }

        String token = tokenProvider.generateToken(user);
        return new AuthResponse(token, UserService.toProfile(user));
    }

    public UserProfile getCurrentUser(Long userId) {
        return userService.getUserProfile(userId);
    }
}
