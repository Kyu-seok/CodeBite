package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class JavaScriptErrorParser implements JudgeErrorParser {

    // Node syntax-error header: "/path/script.js:42"
    private static final Pattern SYNTAX_HEADER_PATTERN = Pattern.compile(
            "^[^\\s:]+\\.js:(\\d+)$", Pattern.MULTILINE);

    // Stack frames: "    at Object.<anonymous> (/path/script.js:42:13)" or "    at /path/script.js:42:13"
    private static final Pattern FRAME_PATTERN = Pattern.compile(
            "at\\s+(?:[^()\\n]+\\s+)?\\(?[^()\\s]*\\.js:(\\d+):(\\d+)\\)?");

    // Error message: lines like "SyntaxError: Unexpected token" or "TypeError: ..."
    private static final Pattern MESSAGE_PATTERN = Pattern.compile(
            "^\\w*Error(?::\\s*(.+))?$", Pattern.MULTILINE);

    @Override
    public List<CodeError> parse(String compileOutput, String stderr) {
        List<CodeError> errors = new ArrayList<>();
        String text = (stderr != null && !stderr.isBlank()) ? stderr
                : (compileOutput != null ? compileOutput : "");
        if (text.isBlank()) return errors;

        String message = extractMessage(text);

        Matcher frameMatcher = FRAME_PATTERN.matcher(text);
        while (frameMatcher.find()) {
            int line = Integer.parseInt(frameMatcher.group(1));
            int column = Integer.parseInt(frameMatcher.group(2));
            errors.add(new CodeError(line, column, null, null, message, CodeError.Severity.ERROR, true));
        }

        if (errors.isEmpty()) {
            Matcher syntaxMatcher = SYNTAX_HEADER_PATTERN.matcher(text);
            if (syntaxMatcher.find()) {
                int line = Integer.parseInt(syntaxMatcher.group(1));
                errors.add(new CodeError(line, null, null, null, message, CodeError.Severity.ERROR, true));
            }
        }

        return errors;
    }

    private String extractMessage(String text) {
        Matcher m = MESSAGE_PATTERN.matcher(text);
        String last = "Runtime error";
        while (m.find()) {
            String full = m.group(0).trim();
            last = full.isEmpty() ? last : full;
        }
        return last;
    }
}
