package com.codebite.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * The CodeBite GitHub App used for GitHub Links and Solution Commits (ADR 0003), bound from
 * {@code app.github.*}. Everything defaults to empty so the backend starts without an App; GitHub
 * Link endpoints then answer 503 until it is configured. {@code scripts/setup-github-app-dev.sh}
 * creates a dev App and writes these values to {@code infra/.env}.
 */
@ConfigurationProperties(prefix = "app.github")
public class GitHubAppProperties {

    private String appId = "";
    private String clientId = "";
    private String clientSecret = "";
    /** Base64 of the whole PEM file GitHub issues (PKCS#1, {@code BEGIN RSA PRIVATE KEY}). */
    private String privateKeyBase64 = "";
    /** The App's slug, from its public link {@code https://github.com/apps/<slug>}. */
    private String slug = "";
    /** Overrides the install URL derived from {@link #slug}. */
    private String installUrl = "";
    private String apiBaseUrl = "https://api.github.com";
    /** Host of the OAuth endpoints ({@code /login/oauth/access_token}). */
    private String webBaseUrl = "https://github.com";
    /** Public CodeBite URL, for the links in Solution Repository READMEs. */
    private String codebiteBaseUrl = "https://code-bite.com";
    /** How long an install state stays valid; installing on GitHub can take a few minutes. */
    private long stateExpirationMs = 900_000;

    /** True when every value needed to install the App and act as it is present. */
    public boolean isConfigured() {
        return !appId.isBlank() && !clientId.isBlank() && !clientSecret.isBlank()
                && !privateKeyBase64.isBlank() && !resolvedInstallUrl().isBlank();
    }

    /** The App's "install on a repository" page, without a state parameter. */
    public String resolvedInstallUrl() {
        if (!installUrl.isBlank()) {
            return installUrl;
        }
        return slug.isBlank() ? "" : webBaseUrl + "/apps/" + slug + "/installations/new";
    }

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

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

    public String getPrivateKeyBase64() {
        return privateKeyBase64;
    }

    public void setPrivateKeyBase64(String privateKeyBase64) {
        this.privateKeyBase64 = privateKeyBase64;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getInstallUrl() {
        return installUrl;
    }

    public void setInstallUrl(String installUrl) {
        this.installUrl = installUrl;
    }

    public String getApiBaseUrl() {
        return apiBaseUrl;
    }

    public void setApiBaseUrl(String apiBaseUrl) {
        this.apiBaseUrl = apiBaseUrl;
    }

    public String getWebBaseUrl() {
        return webBaseUrl;
    }

    public void setWebBaseUrl(String webBaseUrl) {
        this.webBaseUrl = webBaseUrl;
    }

    public long getStateExpirationMs() {
        return stateExpirationMs;
    }

    public void setStateExpirationMs(long stateExpirationMs) {
        this.stateExpirationMs = stateExpirationMs;
    }

    public String getCodebiteBaseUrl() {
        return codebiteBaseUrl;
    }

    public void setCodebiteBaseUrl(String codebiteBaseUrl) {
        this.codebiteBaseUrl = codebiteBaseUrl;
    }
}
