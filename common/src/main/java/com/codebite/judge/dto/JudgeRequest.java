package com.codebite.judge.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record JudgeRequest(
        @JsonProperty("source_code") String sourceCode,
        @JsonProperty("language_id") int languageId,
        @JsonProperty("stdin") String stdin
) {
}
