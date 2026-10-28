package com.codebite.problem.repository;

/** How many published problems carry one tag. */
public record TagCount(String name, String slug, long count) {
}
