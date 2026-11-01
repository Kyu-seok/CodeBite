package com.codebite.problem.guarantee;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;

/** A Test Case's input as its Driver reads it: one value per line. */
public record CaseInput(List<String> lines) {

    private static final ObjectMapper JSON = new ObjectMapper();

    public static CaseInput of(String input) {
        return new CaseInput(List.of(input.strip().split("\\R")));
    }

    public String line(int index) {
        return lines.get(index).strip();
    }

    public long integer(int index) {
        return Long.parseLong(line(index));
    }

    public long[] integers(int index) {
        return parse(index, new TypeReference<List<Long>>() {}).stream().mapToLong(Long::longValue).toArray();
    }

    public <T> T parse(int index, TypeReference<T> type) {
        try {
            return JSON.readValue(line(index), type);
        } catch (JsonProcessingException e) {
            throw new IllegalArgumentException("Line " + (index + 1) + " is not " + type.getType() + ": " + line(index), e);
        }
    }
}
