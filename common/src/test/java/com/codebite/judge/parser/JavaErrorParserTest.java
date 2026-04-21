package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class JavaErrorParserTest {

    private final JavaErrorParser parser = new JavaErrorParser();

    @Test
    void parsesJavacCompileError() throws IOException {
        String out = FixtureLoader.load("java/compile-missing-semicolon.txt");

        List<CodeError> errors = parser.parse(out, null);

        assertThat(errors).hasSize(1);
        CodeError e = errors.get(0);
        assertThat(e.line()).isEqualTo(5);
        assertThat(e.severity()).isEqualTo(CodeError.Severity.ERROR);
        assertThat(e.message()).contains("';' expected");
        assertThat(e.inUserCode()).isTrue();
    }

    @Test
    void parsesEveryStackFrameFromRuntimeException() throws IOException {
        String stderr = FixtureLoader.load("java/runtime-npe.txt");

        List<CodeError> errors = parser.parse(null, stderr);

        assertThat(errors).hasSize(2);
        assertThat(errors.get(0).line()).isEqualTo(7);
        assertThat(errors.get(1).line()).isEqualTo(14);
        assertThat(errors).allMatch(e -> e.message().contains("NullPointerException"));
    }

    @Test
    void returnsEmptyListOnNullAndBlankInput() {
        assertThat(parser.parse(null, null)).isEmpty();
        assertThat(parser.parse("", "")).isEmpty();
    }
}
