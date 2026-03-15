package com.codebite.problem.dto;

import com.codebite.problem.entity.Difficulty;

public record ProblemListItem(Long id, String title, String slug, Difficulty difficulty) {
}
