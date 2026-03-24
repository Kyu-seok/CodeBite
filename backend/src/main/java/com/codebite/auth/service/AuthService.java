package com.codebite.auth.service;

import com.codebite.auth.dto.AuthResponse;
import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.auth.oauth.OAuthClientFactory;
import com.codebite.auth.oauth.OAuthProviderClient;
import com.codebite.auth.oauth.OAuthStateService;
import com.codebite.auth.oauth.dto.OAuthTokenResponse;
import com.codebite.auth.oauth.dto.OAuthUserInfo;
import com.codebite.config.OAuthProperties;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.dto.UserProfile;
import com.codebite.user.entity.OAuthProvider;
import com.codebite.user.entity.User;
import com.codebite.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AuthService {

    private final UserService userService;
    private final JwtTokenProvider tokenProvider;
    private final OAuthClientFactory clientFactory;
    private final OAuthStateService stateService;
    private final OAuthProperties oauthProperties;
    private final SubmissionRepository submissionRepository;

    @Autowired(required = false)
    private UserCacheService userCacheService;

    public AuthService(UserService userService,
                       JwtTokenProvider tokenProvider,
                       OAuthClientFactory clientFactory,
                       OAuthStateService stateService,
                       OAuthProperties oauthProperties,
                       SubmissionRepository submissionRepository) {
        this.userService = userService;
        this.tokenProvider = tokenProvider;
        this.clientFactory = clientFactory;
        this.stateService = stateService;
        this.oauthProperties = oauthProperties;
        this.submissionRepository = submissionRepository;
    }

    public String getAuthorizationUrl(String providerName) {
        OAuthProvider provider = parseProvider(providerName);
        OAuthProviderClient client = clientFactory.getClient(provider);
        String state = stateService.generateState(providerName);
        String redirectUri = oauthProperties.getRedirectBaseUri() + "/" + providerName;
        return client.getAuthorizationUrl(state, redirectUri);
    }

    public AuthResponse handleOAuthCallback(String providerName, String code, String state) {
        String stateProvider = stateService.validateState(state);
        if (!providerName.equalsIgnoreCase(stateProvider)) {
            throw new com.codebite.common.exception.InvalidOAuthStateException(
                    "State provider mismatch");
        }

        OAuthProvider provider = parseProvider(providerName);
        OAuthProviderClient client = clientFactory.getClient(provider);
        String redirectUri = oauthProperties.getRedirectBaseUri() + "/" + providerName;

        OAuthTokenResponse tokenResponse = client.exchangeCode(code, redirectUri);
        OAuthUserInfo userInfo = client.getUserInfo(tokenResponse.accessToken());

        User user = userService.findOrCreateOAuthUser(userInfo, provider);
        submissionRepository.findFirstByUserIdOrderByCreatedAtDesc(user.getId())
                .ifPresent(s -> user.setRecentLanguage(s.getLanguage()));
        String jwt = tokenProvider.generateToken(user);
        UserProfile profile = UserService.toProfile(user);
        if (userCacheService != null) {
            userCacheService.cacheProfile(user.getId(), profile);
        }
        return new AuthResponse(jwt, profile);
    }

    public UserProfile getCurrentUser(Long userId) {
        if (userCacheService != null) {
            Optional<UserProfile> cached = userCacheService.getCachedProfile(userId);
            if (cached.isPresent()) {
                return cached.get();
            }
        }
        UserProfile profile = userService.getUserProfile(userId);
        if (userCacheService != null) {
            userCacheService.cacheProfile(userId, profile);
        }
        return profile;
    }

    private OAuthProvider parseProvider(String providerName) {
        try {
            return OAuthProvider.valueOf(providerName.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Unsupported OAuth provider: " + providerName);
        }
    }
}
