package com.codebite.problem.service;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import jakarta.persistence.criteria.Join;
import org.springframework.data.jpa.domain.Specification;

public final class ProblemSpecifications {

    private ProblemSpecifications() {}

    public static Specification<Problem> isPublished() {
        return (root, query, cb) -> cb.isTrue(root.get("published"));
    }

    public static Specification<Problem> hasDifficulty(Difficulty difficulty) {
        return (root, query, cb) -> cb.equal(root.get("difficulty"), difficulty);
    }

    public static Specification<Problem> titleContains(String search) {
        return (root, query, cb) ->
                cb.like(cb.lower(root.get("title")), "%" + search.toLowerCase() + "%");
    }

    public static Specification<Problem> hasTag(String tagSlug) {
        return (root, query, cb) -> {
            query.distinct(true);
            Join<Problem, Tag> tags = root.join("tags");
            return cb.equal(tags.get("slug"), tagSlug);
        };
    }
}
