package com.codebite.problem.repository;

import com.codebite.problem.entity.Difficulty;

/** How many published problems there are of one difficulty. */
public record DifficultyCount(Difficulty difficulty, long count) {
}
