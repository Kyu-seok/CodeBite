package com.codebite.common.exception;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;

class MessageBundlesTest {

    @Test
    void englishAndKoreanBundlesHaveTheSameKeys() throws IOException {
        Set<String> english = keys("messages.properties");
        Set<String> korean = keys("messages_ko.properties");

        assertAll(
                () -> assertEquals(Set.of(), missing(english, korean), "keys missing from messages_ko.properties"),
                () -> assertEquals(Set.of(), missing(korean, english), "keys missing from messages.properties"));
    }

    private static Set<String> keys(String bundle) throws IOException {
        Properties properties = new Properties();
        try (InputStream in = MessageBundlesTest.class.getClassLoader().getResourceAsStream(bundle)) {
            properties.load(new InputStreamReader(in, StandardCharsets.UTF_8));
        }
        return properties.stringPropertyNames();
    }

    private static SortedSet<String> missing(Set<String> from, Set<String> in) {
        SortedSet<String> missing = new TreeSet<>(from);
        missing.removeAll(in);
        return missing;
    }
}
