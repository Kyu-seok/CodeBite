package com.codebite.solution.entity;

import com.codebite.common.base.BaseEntity;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import com.codebite.submission.entity.Submission;
import com.codebite.user.entity.User;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import org.hibernate.annotations.Formula;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "solutions")
public class Solution extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "problem_id", nullable = false)
    private Problem problem;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User author;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "source_submission_id")
    private Submission sourceSubmission;

    @Column(nullable = false, length = 100)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "solution_languages", joinColumns = @JoinColumn(name = "solution_id"))
    @Column(name = "language", length = 20, nullable = false)
    private Set<String> languages = new HashSet<>();

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "solution_tags",
            joinColumns = @JoinColumn(name = "solution_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private Set<Tag> tags = new HashSet<>();

    @Column(name = "upvotes_count", nullable = false)
    private int upvotesCount = 0;

    @Column(name = "downvotes_count", nullable = false)
    private int downvotesCount = 0;

    @Column(name = "comments_count", nullable = false)
    private int commentsCount = 0;

    @Column(name = "views_count", nullable = false)
    private int viewsCount = 0;

    @Column(name = "is_published", nullable = false)
    private boolean published = true;

    @Formula("upvotes_count - downvotes_count")
    private int netScore;

    public Problem getProblem() {
        return problem;
    }

    public void setProblem(Problem problem) {
        this.problem = problem;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public Submission getSourceSubmission() {
        return sourceSubmission;
    }

    public void setSourceSubmission(Submission sourceSubmission) {
        this.sourceSubmission = sourceSubmission;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Set<String> getLanguages() {
        return languages;
    }

    public void setLanguages(Set<String> languages) {
        this.languages = languages;
    }

    public Set<Tag> getTags() {
        return tags;
    }

    public void setTags(Set<Tag> tags) {
        this.tags = tags;
    }

    public int getUpvotesCount() {
        return upvotesCount;
    }

    public void setUpvotesCount(int upvotesCount) {
        this.upvotesCount = upvotesCount;
    }

    public int getDownvotesCount() {
        return downvotesCount;
    }

    public void setDownvotesCount(int downvotesCount) {
        this.downvotesCount = downvotesCount;
    }

    public int getCommentsCount() {
        return commentsCount;
    }

    public void setCommentsCount(int commentsCount) {
        this.commentsCount = commentsCount;
    }

    public int getViewsCount() {
        return viewsCount;
    }

    public void setViewsCount(int viewsCount) {
        this.viewsCount = viewsCount;
    }

    public boolean isPublished() {
        return published;
    }

    public void setPublished(boolean published) {
        this.published = published;
    }

    public int getNetScore() {
        return netScore;
    }
}
