package com.codebite.config;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class SitePropertiesTest {

    @Test
    void baseUrlDropsTheTrailingSlash() {
        SiteProperties properties = new SiteProperties();
        properties.setBaseUrl("https://code-bite.test/");

        assertThat(properties.baseUrl()).isEqualTo("https://code-bite.test");
    }

    @Test
    void baseUrlMustBeAnOrigin() {
        SiteProperties properties = new SiteProperties();

        assertThatThrownBy(() -> properties.setBaseUrl("code-bite.test"))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> properties.setBaseUrl(""))
                .isInstanceOf(IllegalArgumentException.class);
    }
}
