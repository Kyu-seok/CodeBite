package com.codebite.user.service;

import com.codebite.auth.oauth.dto.OAuthUserInfo;
import com.codebite.user.entity.OAuthProvider;
import com.codebite.user.entity.User;
import com.codebite.user.entity.UserOAuthAccount;
import com.codebite.user.repository.UserOAuthAccountRepository;
import com.codebite.user.repository.UserRepository;
import com.codebite.user.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserServiceOAuthTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserOAuthAccountRepository oauthAccountRepository;

    private UserService userService;

    @BeforeEach
    void setUp() {
        userService = new UserService(userRepository, oauthAccountRepository);
    }

    @Test
    void findOrCreateOAuthUser_existingOAuthAccount_returnsUser() {
        User existingUser = new User();
        existingUser.setUsername("existing");
        existingUser.setEmail("existing@test.com");

        UserOAuthAccount account = new UserOAuthAccount();
        account.setUser(existingUser);

        when(oauthAccountRepository.findByProviderAndProviderId(OAuthProvider.GITHUB, "12345"))
                .thenReturn(Optional.of(account));

        OAuthUserInfo info = new OAuthUserInfo("12345", "existing@test.com", "existing", null);
        User result = userService.findOrCreateOAuthUser(info, OAuthProvider.GITHUB);

        assertEquals("existing", result.getUsername());
        verify(userRepository, never()).save(any());
    }

    @Test
    void findOrCreateOAuthUser_existingEmailUser_linksAccount() {
        User existingUser = new User();
        existingUser.setUsername("emailuser");
        existingUser.setEmail("shared@test.com");

        when(oauthAccountRepository.findByProviderAndProviderId(OAuthProvider.GOOGLE, "g-123"))
                .thenReturn(Optional.empty());
        when(userRepository.findByEmail("shared@test.com"))
                .thenReturn(Optional.of(existingUser));

        OAuthUserInfo info = new OAuthUserInfo("g-123", "shared@test.com", "Google User", "https://avatar.url");
        User result = userService.findOrCreateOAuthUser(info, OAuthProvider.GOOGLE);

        assertEquals("emailuser", result.getUsername());

        ArgumentCaptor<UserOAuthAccount> captor = ArgumentCaptor.forClass(UserOAuthAccount.class);
        verify(oauthAccountRepository).save(captor.capture());
        assertEquals(OAuthProvider.GOOGLE, captor.getValue().getProvider());
        assertEquals("g-123", captor.getValue().getProviderId());
        verify(userRepository, never()).save(any());
    }

    @Test
    void findOrCreateOAuthUser_newUser_createsUserAndAccount() {
        when(oauthAccountRepository.findByProviderAndProviderId(OAuthProvider.GITHUB, "gh-456"))
                .thenReturn(Optional.empty());
        when(userRepository.findByEmail("new@test.com"))
                .thenReturn(Optional.empty());
        when(userRepository.existsByUsername("ghuser"))
                .thenReturn(false);

        User savedUser = new User();
        savedUser.setUsername("ghuser");
        savedUser.setEmail("new@test.com");
        when(userRepository.save(any(User.class))).thenReturn(savedUser);

        OAuthUserInfo info = new OAuthUserInfo("gh-456", "new@test.com", "ghuser", "https://avatar.url");
        User result = userService.findOrCreateOAuthUser(info, OAuthProvider.GITHUB);

        assertEquals("ghuser", result.getUsername());
        assertNull(result.getPasswordHash());
        verify(userRepository).save(any(User.class));
        verify(oauthAccountRepository).save(any(UserOAuthAccount.class));
    }

    @Test
    void generateUsername_github_usesLogin() {
        when(userRepository.existsByUsername("octocat")).thenReturn(false);

        OAuthUserInfo info = new OAuthUserInfo("1", "octocat@test.com", "octocat", null);
        String username = userService.generateUsername(info, OAuthProvider.GITHUB);

        assertEquals("octocat", username);
    }

    @Test
    void generateUsername_google_usesEmailLocalPart() {
        when(userRepository.existsByUsername("john")).thenReturn(false);

        OAuthUserInfo info = new OAuthUserInfo("1", "john@gmail.com", "John Doe", null);
        String username = userService.generateUsername(info, OAuthProvider.GOOGLE);

        assertEquals("john", username);
    }

    @Test
    void generateUsername_taken_appendsSuffix() {
        // First call checks "taken" (returns true), second call checks "taken_XXXX" (returns false)
        when(userRepository.existsByUsername(anyString())).thenReturn(true, false);

        OAuthUserInfo info = new OAuthUserInfo("1", "taken@test.com", "taken", null);
        String username = userService.generateUsername(info, OAuthProvider.GITHUB);

        assertNotNull(username);
        // Should start with "taken_" since original is taken
        assertEquals(true, username.startsWith("taken_"));
    }
}
