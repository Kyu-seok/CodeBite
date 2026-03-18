package com.codebite.auth.oauth;

import com.codebite.auth.oauth.dto.OAuthTokenResponse;
import com.codebite.auth.oauth.dto.OAuthUserInfo;
import com.codebite.config.OAuthProperties;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Component
public class GoogleOAuthClient implements OAuthProviderClient {

    private static final String AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USER_INFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";

    private final OAuthProperties.Google config;
    private final RestTemplate restTemplate;

    public GoogleOAuthClient(OAuthProperties properties) {
        this.config = properties.getGoogle();
        if (config.getClientId() == null || config.getClientId().isBlank()) {
            throw new IllegalStateException(
                    "Google OAuth client ID is not configured. Set the GOOGLE_CLIENT_ID environment variable.");
        }
        this.restTemplate = new RestTemplate();
    }

    @Override
    public String getAuthorizationUrl(String state, String redirectUri) {
        return AUTH_URL
                + "?client_id=" + encode(config.getClientId())
                + "&redirect_uri=" + encode(redirectUri)
                + "&response_type=code"
                + "&scope=" + encode("openid email profile")
                + "&state=" + encode(state);
    }

    @Override
    @SuppressWarnings("unchecked")
    public OAuthTokenResponse exchangeCode(String code, String redirectUri) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("client_id", config.getClientId());
        body.add("client_secret", config.getClientSecret());
        body.add("code", code);
        body.add("grant_type", "authorization_code");
        body.add("redirect_uri", redirectUri);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(body, headers);
        ResponseEntity<Map> response = restTemplate.postForEntity(TOKEN_URL, request, Map.class);

        Map<String, Object> responseBody = response.getBody();
        String accessToken = (String) responseBody.get("access_token");
        String tokenType = (String) responseBody.get("token_type");
        return new OAuthTokenResponse(accessToken, tokenType);
    }

    @Override
    @SuppressWarnings("unchecked")
    public OAuthUserInfo getUserInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);

        HttpEntity<Void> request = new HttpEntity<>(headers);
        ResponseEntity<Map> response = restTemplate.exchange(
                USER_INFO_URL, HttpMethod.GET, request, Map.class);

        Map<String, Object> body = response.getBody();
        String providerId = (String) body.get("sub");
        String email = (String) body.get("email");
        String name = (String) body.get("name");
        String avatarUrl = (String) body.get("picture");
        return new OAuthUserInfo(providerId, email, name, avatarUrl);
    }

    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
