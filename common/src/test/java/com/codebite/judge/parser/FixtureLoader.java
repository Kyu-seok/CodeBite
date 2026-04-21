package com.codebite.judge.parser;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

final class FixtureLoader {
    private FixtureLoader() {}

    static String load(String path) throws IOException {
        try (InputStream in = FixtureLoader.class.getClassLoader()
                .getResourceAsStream("judge-errors/" + path)) {
            if (in == null) throw new IOException("Fixture not found: " + path);
            return new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
