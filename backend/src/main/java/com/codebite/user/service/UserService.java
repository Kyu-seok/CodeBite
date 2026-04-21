package com.codebite.user.service;

import com.codebite.auth.oauth.dto.OAuthUserInfo;
import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.user.dto.UserProfile;
import com.codebite.user.entity.OAuthProvider;
import com.codebite.user.entity.User;
import com.codebite.user.entity.UserOAuthAccount;
import com.codebite.user.repository.UserOAuthAccountRepository;
import com.codebite.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final UserOAuthAccountRepository oauthAccountRepository;

    public UserService(UserRepository userRepository, UserOAuthAccountRepository oauthAccountRepository) {
        this.userRepository = userRepository;
        this.oauthAccountRepository = oauthAccountRepository;
    }

    @Transactional
    public User findOrCreateOAuthUser(OAuthUserInfo info, OAuthProvider provider) {
        // 1. Look up by provider + providerId
        Optional<UserOAuthAccount> existingAccount =
                oauthAccountRepository.findByProviderAndProviderId(provider, info.providerId());
        if (existingAccount.isPresent()) {
            return existingAccount.get().getUser();
        }

        // 2. Look up by email — link to existing user
        Optional<User> existingUser = userRepository.findByEmail(info.email());
        if (existingUser.isPresent()) {
            User user = existingUser.get();
            createOAuthAccount(user, provider, info.providerId());
            return user;
        }

        // 3. Create new user
        User user = new User();
        user.setUsername(generateUsername(info, provider));
        user.setEmail(info.email());
        user.setAvatarUrl(info.avatarUrl());
        user = userRepository.save(user);

        createOAuthAccount(user, provider, info.providerId());
        return user;
    }

    @Transactional(readOnly = true)
    public UserProfile getUserProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));
        return toProfile(user);
    }

    public static UserProfile toProfile(User user) {
        return new UserProfile(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getRole(),
                user.getAvatarUrl(),
                user.getRecentLanguage(),
                user.getEditorSettings(),
                user.getThemePreference(),
                user.getLocale(),
                user.getCuration(),
                user.getSinglePage(),
                user.getCreatedAt()
        );
    }

    @Transactional
    public void updateEditorSettings(Long userId, String editorSettings) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));
        user.setEditorSettings(editorSettings);
        userRepository.save(user);
    }

    @Transactional
    public void updateThemePreference(Long userId, String themePreference) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));
        user.setThemePreference(themePreference);
        userRepository.save(user);
    }

    @Transactional
    public void updateLocale(Long userId, String locale) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));
        user.setLocale(locale);
        userRepository.save(user);
    }

    @Transactional
    public void updateCuration(Long userId, String curation) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));
        user.setCuration(curation);
        userRepository.save(user);
    }

    @Transactional
    public void updateSinglePage(Long userId, Boolean singlePage) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));
        user.setSinglePage(singlePage);
        userRepository.save(user);
    }

    private void createOAuthAccount(User user, OAuthProvider provider, String providerId) {
        UserOAuthAccount account = new UserOAuthAccount();
        account.setUser(user);
        account.setProvider(provider);
        account.setProviderId(providerId);
        oauthAccountRepository.save(account);
    }

    String generateUsername(OAuthUserInfo info, OAuthProvider provider) {
        String base;
        if (provider == OAuthProvider.GITHUB && info.name() != null) {
            base = info.name();
        } else {
            base = info.email().split("@")[0];
        }

        // Truncate to fit within 50-char limit (leaving room for suffix)
        if (base.length() > 45) {
            base = base.substring(0, 45);
        }

        if (!userRepository.existsByUsername(base)) {
            return base;
        }

        // Append random 4-digit suffix
        for (int i = 0; i < 10; i++) {
            String candidate = base + "_" + String.format("%04d", ThreadLocalRandom.current().nextInt(10000));
            if (!userRepository.existsByUsername(candidate)) {
                return candidate;
            }
        }

        // Fallback — extremely unlikely
        return base + "_" + System.currentTimeMillis();
    }
}
