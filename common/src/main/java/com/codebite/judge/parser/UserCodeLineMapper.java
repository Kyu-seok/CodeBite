package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Translates parser output (in combined-file coordinates) into user-buffer
 * coordinates. Errors outside the user's code range are collapsed into a
 * single {@code inUserCode=false} banner entry — a wrong underline on user
 * code is worse than no underline when the fault is actually in the driver.
 */
@Component
public class UserCodeLineMapper {

    private static final String TEMPLATE_ERROR_MESSAGE =
            "Internal template error. Please use the Bug report button.";

    public List<CodeError> mapToUserSpace(
            List<CodeError> combinedFileErrors,
            int userCodeStartLine,
            int userCodeLineCount
    ) {
        if (combinedFileErrors == null || combinedFileErrors.isEmpty()) {
            return List.of();
        }

        List<CodeError> mapped = new ArrayList<>();
        boolean anyInUserCode = false;

        for (CodeError error : combinedFileErrors) {
            if (error.line() == null) {
                mapped.add(error);
                if (error.inUserCode()) anyInUserCode = true;
                continue;
            }

            int userLine = error.line() - userCodeStartLine + 1;
            if (userLine >= 1 && userLine <= userCodeLineCount) {
                Integer userEndLine = null;
                if (error.endLine() != null) {
                    int candidate = error.endLine() - userCodeStartLine + 1;
                    userEndLine = (candidate >= userLine && candidate <= userCodeLineCount)
                            ? candidate : null;
                }
                mapped.add(new CodeError(
                        userLine,
                        error.column(),
                        userEndLine,
                        error.endColumn(),
                        error.message(),
                        error.severity(),
                        true
                ));
                anyInUserCode = true;
            } else if (userLine > userCodeLineCount && userCodeLineCount > 0) {
                // Error reported past user code — almost always a cascade from
                // unbalanced braces / unclosed strings in user code, since the
                // driver suffix is known-good. Pin to the last user line.
                mapped.add(new CodeError(
                        userCodeLineCount,
                        null,
                        null,
                        null,
                        error.message(),
                        error.severity(),
                        true
                ));
                anyInUserCode = true;
            }
            // else: above user code — driver prefix, genuinely not our problem.
        }

        if (!anyInUserCode) {
            return List.of(CodeError.templateError(TEMPLATE_ERROR_MESSAGE));
        }
        return mapped;
    }
}
