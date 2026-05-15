package com.codebite.review.dto;

public record TagConfidenceItem(
        String tagSlug,
        String tagName,
        long again,
        long hard,
        long good,
        long easy
) {
    public long total() {
        return again + hard + good + easy;
    }
}
