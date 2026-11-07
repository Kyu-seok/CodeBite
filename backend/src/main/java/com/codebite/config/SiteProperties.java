package com.codebite.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * The site as the public sees it, bound from {@code app.site.*}: the origin that absolute links
 * (the sitemap's) are built under.
 */
@ConfigurationProperties(prefix = "app.site")
public class SiteProperties {

    private String baseUrl = "https://code-bite.com";

    /** The origin without a trailing slash, so {@code baseUrl() + "/problems"} is a URL. */
    public String baseUrl() {
        return baseUrl;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        String trimmed = baseUrl.strip();
        while (trimmed.endsWith("/")) {
            trimmed = trimmed.substring(0, trimmed.length() - 1);
        }
        if (!trimmed.startsWith("http://") && !trimmed.startsWith("https://")) {
            throw new IllegalArgumentException("app.site.base-url must be an http(s) origin, was: " + baseUrl);
        }
        this.baseUrl = trimmed;
    }
}
