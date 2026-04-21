package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PythonErrorParser implements JudgeErrorParser {

    // Traceback lines: '  File "script.py", line 42, in <module>'
    private static final Pattern FRAME_PATTERN = Pattern.compile(
            "File \"[^\"]*\", line (\\d+)");

    // Final exception line after the traceback: "TypeError: unsupported operand..."
    // Python puts the message as the last non-blank line of stderr.
    @Override
    public List<CodeError> parse(String compileOutput, String stderr) {
        List<CodeError> errors = new ArrayList<>();
        String text = (stderr != null && !stderr.isBlank()) ? stderr
                : (compileOutput != null ? compileOutput : "");
        if (text.isBlank()) return errors;

        String message = extractMessage(text);

        Matcher m = FRAME_PATTERN.matcher(text);
        while (m.find()) {
            int line = Integer.parseInt(m.group(1));
            errors.add(new CodeError(line, null, null, null, message, CodeError.Severity.ERROR, true));
        }
        return errors;
    }

    private String extractMessage(String text) {
        String[] lines = text.split("\\R");
        for (int i = lines.length - 1; i >= 0; i--) {
            String line = lines[i].trim();
            if (line.isEmpty()) continue;
            if (line.startsWith("File \"") || line.startsWith("Traceback")) continue;
            return line;
        }
        return "Runtime error";
    }
}
