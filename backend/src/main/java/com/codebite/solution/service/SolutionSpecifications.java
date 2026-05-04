package com.codebite.solution.service;

import com.codebite.problem.entity.Tag;
import com.codebite.solution.entity.Solution;
import jakarta.persistence.criteria.Join;
import org.springframework.data.jpa.domain.Specification;

public final class SolutionSpecifications {

    private SolutionSpecifications() {
    }

    public static Specification<Solution> publishedAndProblemSlug(String slug) {
        return (root, query, cb) -> cb.and(
                cb.isTrue(root.get("published")),
                cb.equal(root.get("problem").get("slug"), slug)
        );
    }

    public static Specification<Solution> hasLanguage(String language) {
        return (root, query, cb) -> {
            query.distinct(true);
            return cb.isMember(language, root.get("languages"));
        };
    }

    public static Specification<Solution> hasTagSlug(String tagSlug) {
        return (root, query, cb) -> {
            Join<Solution, Tag> tags = root.join("tags");
            query.distinct(true);
            return cb.equal(tags.get("slug"), tagSlug);
        };
    }

    public static Specification<Solution> titleContains(String search) {
        return (root, query, cb) ->
                cb.like(cb.lower(root.get("title")), "%" + search.toLowerCase() + "%");
    }
}
