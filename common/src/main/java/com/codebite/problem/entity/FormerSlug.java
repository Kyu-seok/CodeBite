package com.codebite.problem.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * A Slug a problem had before a Restatement; it still finds the problem. Rows are written only by
 * the migration that Restates the problem.
 */
@Entity
@Table(name = "problem_former_slugs")
public class FormerSlug {

    @Id
    @Column(nullable = false)
    private String slug;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "problem_id", nullable = false)
    private Problem problem;

    protected FormerSlug() {
    }

    public String getSlug() {
        return slug;
    }

    public Problem getProblem() {
        return problem;
    }
}
