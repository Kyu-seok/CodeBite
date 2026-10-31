package com.codebite.problem.dto;

import com.codebite.problem.entity.Difficulty;

import java.time.Instant;
import java.util.List;
import java.util.Map;

/** {@code tutorial}: this is the Tutorial Problem, which the detail page labels "Tutorial". */
public record ProblemDetail(
        Long id,
        Integer problemNumber,
        String title,
        String slug,
        String description,
        Difficulty difficulty,
        Map<String, String> starterCode,
        String constraints,
        boolean published,
        List<TestCaseDto> sampleTestCases,
        Instant createdAt,
        Instant updatedAt,
        boolean tutorial
) {
}
