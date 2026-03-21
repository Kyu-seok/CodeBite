package com.codebite.judge.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public record JudgeResponse(
        String token,
        Status status,
        String stdout,
        String stderr,
        @JsonProperty("compile_output") String compileOutput,
        String time,
        Integer memory
) {
    public record Status(int id, String description) {
    }
}
