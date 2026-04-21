package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class CppErrorParserTest {

    private final CppErrorParser parser = new CppErrorParser();

    @Test
    void parsesGccCompileError() throws IOException {
        String compileOutput = FixtureLoader.load("cpp/compile-undeclared.txt");

        List<CodeError> errors = parser.parse(compileOutput, null);

        assertThat(errors).hasSize(1);
        CodeError e = errors.get(0);
        assertThat(e.line()).isEqualTo(9);
        assertThat(e.column()).isEqualTo(5);
        assertThat(e.severity()).isEqualTo(CodeError.Severity.ERROR);
        assertThat(e.message()).contains("was not declared");
    }

    @Test
    void returnsEmptyListOnBlankInput() {
        assertThat(parser.parse(null, null)).isEmpty();
    }
}
