package com.codebite.problem.dto;

import com.codebite.problem.entity.Difficulty;

import java.util.List;

/** {@code tutorial}: this is the Tutorial Problem, which the list labels "Tutorial". */
public record ProblemListItem(Long id, Integer problemNumber, String title, String slug, Difficulty difficulty, List<String> tags, String status, Double acceptanceRate, boolean tutorial) {
}
