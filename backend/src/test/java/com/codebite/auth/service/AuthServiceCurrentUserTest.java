package com.codebite.auth.service;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.auth.oauth.OAuthClientFactory;
import com.codebite.auth.oauth.OAuthStateService;
import com.codebite.config.OAuthProperties;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.dto.UserProfile;
import com.codebite.user.entity.User;
import com.codebite.user.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * recentLanguage isn't stored on the user; it's read from the latest submission. A profile rebuilt
 * after a cache miss (TTL or a settings change) must carry it just like the one cached at login.
 */
@ExtendWith(MockitoExtension.class)
class AuthServiceCurrentUserTest {

    private static final Long USER_ID = 14L;

    @Mock private UserService userService;
    @Mock private JwtTokenProvider tokenProvider;
    @Mock private OAuthClientFactory clientFactory;
    @Mock private OAuthStateService stateService;
    @Mock private OAuthProperties oauthProperties;
    @Mock private SubmissionRepository submissionRepository;
    @Mock private UserCacheService userCacheService;

    private AuthService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthService(userService, tokenProvider, clientFactory, stateService,
                oauthProperties, submissionRepository);
        ReflectionTestUtils.setField(authService, "userCacheService", userCacheService);
    }

    @Test
    void getCurrentUser_onCacheMiss_fillsRecentLanguageFromLatestSubmission() {
        User user = new User();
        user.setId(USER_ID);
        Submission latest = new Submission();
        latest.setLanguage("python");
        when(userCacheService.getCachedProfile(USER_ID)).thenReturn(Optional.empty());
        when(userService.getUser(USER_ID)).thenReturn(user);
        when(submissionRepository.findFirstByUserIdOrderByCreatedAtDesc(USER_ID)).thenReturn(Optional.of(latest));

        UserProfile profile = authService.getCurrentUser(USER_ID);

        assertThat(profile.recentLanguage()).isEqualTo("python");
        verify(userCacheService).cacheProfile(USER_ID, profile);
    }
}
