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
import java.util.List;
import java.util.Map;

@Component
public class GitHubOAuthClient implements OAuthProviderClient {

    private static final String AUTH_URL = "https://github.com/login/oauth/authorize";
    private static final String TOKEN_URL = "https://github.com/login/oauth/access_token";
    private static final String USER_URL = "https://api.github.com/user";
    private static final String EMAILS_URL = "https://api.github.com/user/emails";

    private final OAuthProperties.GitHub config;
    private final RestTemplate restTemplate;

    public GitHubOAuthClient(OAuthProperties properties) {
        this.config = properties.getGithub();
        if (config.getClientId() == null || config.getClientId().isBlank()) {
            throw new IllegalStateException(
                    "GitHub OAuth client ID is not configured. Set the GITHUB_CLIENT_ID environment variable.");
        }
        this.restTemplate = new RestTemplate();
    }

    @Override
    public String getAuthorizationUrl(String state, String redirectUri) {
        return AUTH_URL
                + "?client_id=" + encode(config.getClientId())
                + "&redirect_uri=" + encode(redirectUri)
                + "&scope=" + encode("user:email read:user")
                + "&state=" + encode(state);
    }

    @Override
    @SuppressWarnings("unchecked")
    public OAuthTokenResponse exchangeCode(String code, String redirectUri) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(List.of(MediaType.APPLICATION_JSON));

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("client_id", config.getClientId());
        body.add("client_secret", config.getClientSecret());
        body.add("code", code);
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

        // Fetch user profile
        ResponseEntity<Map> userResponse = restTemplate.exchange(
                USER_URL, HttpMethod.GET, request, Map.class);
        Map<String, Object> userBody = userResponse.getBody();

        String providerId = String.valueOf(userBody.get("id"));
        String login = (String) userBody.get("login");
        String avatarUrl = (String) userBody.get("avatar_url");
        String email = (String) userBody.get("email");

        // If email is null (private), fetch from emails endpoint
        if (email == null) {
            ResponseEntity<List> emailsResponse = restTemplate.exchange(
                    EMAILS_URL, HttpMethod.GET, request, List.class);
            List<Map<String, Object>> emails = emailsResponse.getBody();
            if (emails != null) {
                email = emails.stream()
                        .filter(e -> Boolean.TRUE.equals(e.get("primary"))
                                && Boolean.TRUE.equals(e.get("verified")))
                        .map(e -> (String) e.get("email"))
                        .findFirst()
                        .orElse(null);
            }
        }

        return new OAuthUserInfo(providerId, email, login, avatarUrl);
    }

    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
