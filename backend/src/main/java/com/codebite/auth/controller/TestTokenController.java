package com.codebite.auth.controller;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.auth.service.UserCacheService;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.context.annotation.Profile;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * Local sign-in without OAuth (dev profile only): issues a JWT for the named user, created as USER
 * if missing. An optional {@code role} (USER or ADMIN) sets that user's role first and evicts their
 * cached profile, so {@code /api/auth/me} reports the new role at once.
 */
@Profile("dev")
@RestController
@RequestMapping("/api/auth")
public class TestTokenController {

    private final UserRepository userRepository;
    private final JwtTokenProvider tokenProvider;
    private final ObjectProvider<UserCacheService> userCacheService;

    public TestTokenController(UserRepository userRepository, JwtTokenProvider tokenProvider,
                               ObjectProvider<UserCacheService> userCacheService) {
        this.userRepository = userRepository;
        this.tokenProvider = tokenProvider;
        this.userCacheService = userCacheService;
    }

    @PostMapping("/test-token")
    @Transactional
    public ResponseEntity<Map<String, String>> issueTestToken(
            @RequestParam(defaultValue = "perf-test-1") String username,
            @RequestParam(required = false) Role role) {
        User user = userRepository.findByUsername(username).orElseGet(() -> {
            User u = new User();
            u.setUsername(username);
            u.setEmail(username + "@perf.local");
            u.setRole(Role.USER);
            return u;
        });
        // A named role is applied even to an existing user, so switching USER <-> ADMIN is one call.
        if (role != null) {
            user.setRole(role);
        }
        user = userRepository.save(user);
        if (role != null) {
            Long userId = user.getId();
            userCacheService.ifAvailable(cache -> cache.evictProfile(userId));
        }

        String token = tokenProvider.generateToken(user);
        return ResponseEntity.ok(Map.of("token", token));
    }
}
