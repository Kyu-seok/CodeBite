package com.codebite.auth.oauth;

import com.codebite.auth.oauth.dto.OAuthTokenResponse;
import com.codebite.auth.oauth.dto.OAuthUserInfo;

public interface OAuthProviderClient {

    String getAuthorizationUrl(String state, String redirectUri);

    OAuthTokenResponse exchangeCode(String code, String redirectUri);

    OAuthUserInfo getUserInfo(String accessToken);
}
