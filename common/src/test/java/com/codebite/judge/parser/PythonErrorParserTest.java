package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class PythonErrorParserTest {

    private final PythonErrorParser parser = new PythonErrorParser();

    @Test
    void capturesEveryTracebackFrame() throws IOException {
        String stderr = FixtureLoader.load("python/runtime-typeerror.txt");

        List<CodeError> errors = parser.parse(null, stderr);

        assertThat(errors).hasSize(2);
        assertThat(errors.get(0).line()).isEqualTo(12);
        assertThat(errors.get(1).line()).isEqualTo(4);
        assertThat(errors).allMatch(e -> e.message().startsWith("TypeError:"));
    }

    @Test
    void returnsEmptyListOnBlankInput() {
        assertThat(parser.parse(null, null)).isEmpty();
        assertThat(parser.parse("", "")).isEmpty();
    }
}
