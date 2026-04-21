package com.codebite.judge.dto;

public record CodeError(
        Integer line,
        Integer column,
        Integer endLine,
        Integer endColumn,
        String message,
        Severity severity,
        boolean inUserCode
) {
    public enum Severity {
        ERROR,
        WARNING
    }

    public static CodeError userError(int line, Integer column, String message) {
        return new CodeError(line, column, null, null, message, Severity.ERROR, true);
    }

    public static CodeError templateError(String message) {
        return new CodeError(null, null, null, null, message, Severity.ERROR, false);
    }
}
