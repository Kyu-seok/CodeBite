package com.codebite.judge.parser;

import com.codebite.judge.Language;
import com.codebite.judge.dto.CodeError;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class JudgeErrorParsers {

    private final Map<Language, JudgeErrorParser> byLanguage = Map.of(
            Language.JAVA, new JavaErrorParser(),
            Language.PYTHON, new PythonErrorParser(),
            Language.JAVASCRIPT, new JavaScriptErrorParser(),
            Language.CPP, new CppErrorParser()
    );

    public List<CodeError> parse(String language, String compileOutput, String stderr) {
        return Language.fromCode(language)
                .map(byLanguage::get)
                .map(parser -> parser.parse(compileOutput, stderr))
                .orElse(List.of());
    }
}
