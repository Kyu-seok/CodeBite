package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class JavaScriptErrorParserTest {

    private final JavaScriptErrorParser parser = new JavaScriptErrorParser();

    @Test
    void capturesEveryUserStackFrame() throws IOException {
        String stderr = FixtureLoader.load("javascript/runtime-typeerror.txt");

        List<CodeError> errors = parser.parse(null, stderr);

        assertThat(errors).hasSize(2);
        assertThat(errors.get(0).line()).isEqualTo(5);
        assertThat(errors.get(0).column()).isEqualTo(14);
        assertThat(errors.get(1).line()).isEqualTo(10);
        assertThat(errors.get(1).column()).isEqualTo(13);
    }

    @Test
    void returnsEmptyListOnBlankInput() {
        assertThat(parser.parse(null, null)).isEmpty();
        assertThat(parser.parse("", "")).isEmpty();
    }
}
