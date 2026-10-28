package com.codebite.review.schedule;

import com.codebite.review.entity.Confidence;

import java.time.Instant;
import java.util.Objects;

/**
 * A Confidence given to one judged submission, timestamped at that moment. Re-rating a
 * submission replaces its Review and its timestamp, so a (user, problem) pair has at most
 * one Review per submission.
 */
public record Review(Confidence confidence, Instant at) {

    public Review {
        Objects.requireNonNull(confidence, "confidence");
        Objects.requireNonNull(at, "at");
    }
}
