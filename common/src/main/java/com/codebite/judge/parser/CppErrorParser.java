package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CppErrorParser implements JudgeErrorParser {

    // g++/clang: "main.cpp:42:13: error: 'foo' was not declared in this scope"
    private static final Pattern DIAGNOSTIC_PATTERN = Pattern.compile(
            "^[^\\s:]+\\.(?:cpp|cc|cxx|c\\+\\+|hpp|h):(\\d+):(\\d+):\\s*(error|warning|note):\\s*(.+)$",
            Pattern.MULTILINE);

    @Override
    public List<CodeError> parse(String compileOutput, String stderr) {
        List<CodeError> errors = new ArrayList<>();
        String text = (compileOutput != null && !compileOutput.isBlank()) ? compileOutput
                : (stderr != null ? stderr : "");
        if (text.isBlank()) return errors;

        Matcher m = DIAGNOSTIC_PATTERN.matcher(text);
        while (m.find()) {
            int line = Integer.parseInt(m.group(1));
            int column = Integer.parseInt(m.group(2));
            String kind = m.group(3);
            CodeError.Severity severity = "warning".equalsIgnoreCase(kind)
                    ? CodeError.Severity.WARNING
                    : CodeError.Severity.ERROR;
            if ("note".equalsIgnoreCase(kind)) continue;
            errors.add(new CodeError(line, column, null, null, m.group(4).trim(), severity, true));
        }
        return errors;
    }
}
