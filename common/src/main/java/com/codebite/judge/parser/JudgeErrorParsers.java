package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class JudgeErrorParsers {

    private final Map<String, JudgeErrorParser> byLanguage = Map.of(
            "java", new JavaErrorParser(),
            "python", new PythonErrorParser(),
            "javascript", new JavaScriptErrorParser(),
            "cpp", new CppErrorParser()
    );

    public List<CodeError> parse(String language, String compileOutput, String stderr) {
        if (language == null) return List.of();
        JudgeErrorParser parser = byLanguage.get(language.toLowerCase());
        if (parser == null) return List.of();
        return parser.parse(compileOutput, stderr);
    }
}
