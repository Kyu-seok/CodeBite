package com.codebite.problem.repository;

import java.time.Instant;

/** A published problem as the sitemap lists it: its current Slug and when it last changed. */
public record SitemapEntry(String slug, Instant updatedAt) {
}
