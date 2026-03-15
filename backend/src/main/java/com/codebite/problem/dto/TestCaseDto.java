package com.codebite.problem.dto;

public record TestCaseDto(Long id, String input, String expectedOutput, boolean sample, int orderIndex) {
}
