package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;

import java.util.List;

public interface JudgeErrorParser {
    /**
     * Parse Judge0 compile_output and stderr into a list of {@link CodeError}s
     * with line numbers in the <em>combined</em> source (driver + user code).
     * The caller is responsible for mapping these to user-buffer lines.
     */
    List<CodeError> parse(String compileOutput, String stderr);
}
