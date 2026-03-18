package com.codebite.auth.service;

import com.codebite.auth.dto.AuthResponse;
import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.auth.oauth.OAuthClientFactory;
import com.codebite.auth.oauth.OAuthProviderClient;
import com.codebite.auth.oauth.OAuthStateService;
import com.codebite.auth.oauth.dto.OAuthTokenResponse;
import com.codebite.auth.oauth.dto.OAuthUserInfo;
import com.codebite.config.OAuthProperties;
import com.codebite.user.dto.UserProfile;
import com.codebite.user.entity.OAuthProvider;
import com.codebite.user.entity.User;
import com.codebite.user.service.UserService;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserService userService;
    private final JwtTokenProvider tokenProvider;
    private final OAuthClientFactory clientFactory;
    private final OAuthStateService stateService;
    private final OAuthProperties oauthProperties;

    public AuthService(UserService userService,
                       JwtTokenProvider tokenProvider,
                       OAuthClientFactory clientFactory,
                       OAuthStateService stateService,
                       OAuthProperties oauthProperties) {
        this.userService = userService;
        this.tokenProvider = tokenProvider;
        this.clientFactory = clientFactory;
        this.stateService = stateService;
        this.oauthProperties = oauthProperties;
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
        String jwt = tokenProvider.generateToken(user);
        return new AuthResponse(jwt, UserService.toProfile(user));
    }

    public UserProfile getCurrentUser(Long userId) {
        return userService.getUserProfile(userId);
    }

    private OAuthProvider parseProvider(String providerName) {
        try {
            return OAuthProvider.valueOf(providerName.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Unsupported OAuth provider: " + providerName);
        }
    }
}
