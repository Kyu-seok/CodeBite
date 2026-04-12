package com.codebite.problem.dto;

import com.codebite.problem.entity.Difficulty;

import java.util.List;

public record ProblemListItem(Long id, Integer problemNumber, String title, String slug, Difficulty difficulty, List<String> tags, String status, Double acceptanceRate) {
}
