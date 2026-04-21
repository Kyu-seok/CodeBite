package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class JavaErrorParser implements JudgeErrorParser {

    // javac: "Main.java:42: error: ';' expected"
    private static final Pattern COMPILE_PATTERN = Pattern.compile(
            "^[^\\s:]+\\.java:(\\d+):\\s*(error|warning):\\s*(.+)$",
            Pattern.MULTILINE);

    // Stack frame: "\tat Main.solve(Main.java:42)" — we grab every user-code-range frame
    private static final Pattern STACK_FRAME_PATTERN = Pattern.compile(
            "at\\s+[\\w.$<>]+\\([^)]*\\.java:(\\d+)\\)");

    // Runtime exception header: "Exception in thread "main" java.lang.RuntimeException: msg"
    private static final Pattern EXCEPTION_HEADER_PATTERN = Pattern.compile(
            "^(?:Exception in thread \"[^\"]*\"|Caused by:)\\s*(.+)$", Pattern.MULTILINE);

    @Override
    public List<CodeError> parse(String compileOutput, String stderr) {
        List<CodeError> errors = new ArrayList<>();

        if (compileOutput != null && !compileOutput.isBlank()) {
            Matcher m = COMPILE_PATTERN.matcher(compileOutput);
            while (m.find()) {
                int line = Integer.parseInt(m.group(1));
                CodeError.Severity severity = "warning".equalsIgnoreCase(m.group(2))
                        ? CodeError.Severity.WARNING
                        : CodeError.Severity.ERROR;
                errors.add(new CodeError(line, null, null, null, m.group(3).trim(), severity, true));
            }
            if (!errors.isEmpty()) return errors;
        }

        if (stderr != null && !stderr.isBlank()) {
            String message = extractExceptionMessage(stderr);
            Matcher m = STACK_FRAME_PATTERN.matcher(stderr);
            while (m.find()) {
                int line = Integer.parseInt(m.group(1));
                errors.add(new CodeError(line, null, null, null, message, CodeError.Severity.ERROR, true));
            }
        }

        return errors;
    }

    private String extractExceptionMessage(String stderr) {
        Matcher m = EXCEPTION_HEADER_PATTERN.matcher(stderr);
        String last = "Runtime error";
        while (m.find()) {
            last = m.group(1).trim();
        }
        return last;
    }
}
