package com.codebite.user.service;

import com.codebite.auth.service.UserCacheService;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserOAuthAccountRepository;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * /api/auth/me serves the cached profile, so every settings change must evict it;
 * otherwise the old theme, locale or editor settings come back on reload until the TTL runs out.
 */
@ExtendWith(MockitoExtension.class)
class UserServiceSettingsTest {

    private static final Long USER_ID = 14L;

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserOAuthAccountRepository oauthAccountRepository;

    @Mock
    private UserCacheService userCacheService;

    private UserService userService;

    @BeforeEach
    void setUp() {
        userService = new UserService(userRepository, oauthAccountRepository);
        ReflectionTestUtils.setField(userService, "userCacheService", userCacheService);
        when(userRepository.findById(USER_ID)).thenReturn(Optional.of(new User()));
    }

    @Test
    void updateThemePreference_evictsCachedProfile() {
        userService.updateThemePreference(USER_ID, "dark");
        verify(userCacheService).evictProfile(USER_ID);
    }

    @Test
    void updateLocale_evictsCachedProfile() {
        userService.updateLocale(USER_ID, "ko");
        verify(userCacheService).evictProfile(USER_ID);
    }

    @Test
    void updateEditorSettings_evictsCachedProfile() {
        userService.updateEditorSettings(USER_ID, "{\"keybinding\":\"vim\"}");
        verify(userCacheService).evictProfile(USER_ID);
    }

    @Test
    void updateCuration_evictsCachedProfile() {
        userService.updateCuration(USER_ID, "CB100");
        verify(userCacheService).evictProfile(USER_ID);
    }

    @Test
    void updateSinglePage_evictsCachedProfile() {
        userService.updateSinglePage(USER_ID, true);
        verify(userCacheService).evictProfile(USER_ID);
    }

    @Test
    void settingsUpdate_withCacheDisabled_stillSaves() {
        ReflectionTestUtils.setField(userService, "userCacheService", null);
        assertDoesNotThrow(() -> userService.updateThemePreference(USER_ID, "dark"));
    }
}
