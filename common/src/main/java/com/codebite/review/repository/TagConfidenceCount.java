package com.codebite.review.repository;

import com.codebite.review.entity.Confidence;

/** How many of a user's Reviews of problems carrying one tag gave one confidence. */
public record TagConfidenceCount(String slug, String name, Confidence confidence, long count) {
}
