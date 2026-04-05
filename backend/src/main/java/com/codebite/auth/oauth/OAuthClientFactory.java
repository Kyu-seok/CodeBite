package com.codebite.auth.oauth;

import com.codebite.common.exception.UnsupportedValueException;
import com.codebite.user.entity.OAuthProvider;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class OAuthClientFactory {

    private final Map<OAuthProvider, OAuthProviderClient> clients;

    public OAuthClientFactory(GoogleOAuthClient google, GitHubOAuthClient github) {
        this.clients = Map.of(
                OAuthProvider.GOOGLE, google,
                OAuthProvider.GITHUB, github
        );
    }

    public OAuthProviderClient getClient(OAuthProvider provider) {
        OAuthProviderClient client = clients.get(provider);
        if (client == null) {
            throw new UnsupportedValueException("error.oauth.providerUnsupported", provider);
        }
        return client;
    }
}
