package com.codebite.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.oauth")
public class OAuthProperties {

    private Google google = new Google();
    private GitHub github = new GitHub();
    private String redirectBaseUri = "http://localhost:5173/auth/callback";
    private long stateExpirationMs = 300000;

    public Google getGoogle() {
        return google;
    }

    public void setGoogle(Google google) {
        this.google = google;
    }

    public GitHub getGithub() {
        return github;
    }

    public void setGithub(GitHub github) {
        this.github = github;
    }

    public String getRedirectBaseUri() {
        return redirectBaseUri;
    }

    public void setRedirectBaseUri(String redirectBaseUri) {
        this.redirectBaseUri = redirectBaseUri;
    }

    public long getStateExpirationMs() {
        return stateExpirationMs;
    }

    public void setStateExpirationMs(long stateExpirationMs) {
        this.stateExpirationMs = stateExpirationMs;
    }

    public static class Google {
        private String clientId = "";
        private String clientSecret = "";

        public String getClientId() {
            return clientId;
        }

        public void setClientId(String clientId) {
            this.clientId = clientId;
        }

        public String getClientSecret() {
            return clientSecret;
        }

        public void setClientSecret(String clientSecret) {
            this.clientSecret = clientSecret;
        }
    }

    public static class GitHub {
        private String clientId = "";
        private String clientSecret = "";

        public String getClientId() {
            return clientId;
        }

        public void setClientId(String clientId) {
            this.clientId = clientId;
        }

        public String getClientSecret() {
            return clientSecret;
        }

        public void setClientSecret(String clientSecret) {
            this.clientSecret = clientSecret;
        }
    }
}
