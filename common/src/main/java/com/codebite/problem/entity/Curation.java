package com.codebite.problem.entity;

import java.util.Locale;
import java.util.Optional;

/**
 * A curated subset of the catalogue: the problems numbered 1 to {@link #lastNumber()}. It starts
 * at 1, not 0, so the Tutorial Problem ({@link Problem#TUTORIAL_NUMBER}) belongs to no curation
 * (docs/adr/0007). Every curation filter and count goes through {@link #firstNumber()} and
 * {@link #lastNumber()}.
 */
public enum Curation {
    CB50(50), CB100(100), CB200(200);

    private final int lastNumber;

    Curation(int lastNumber) {
        this.lastNumber = lastNumber;
    }

    public int firstNumber() {
        return 1;
    }

    public int lastNumber() {
        return lastNumber;
    }

    /** The curation a request names, case-insensitively; empty for none, blank or one CodeBite doesn't have. */
    public static Optional<Curation> ofRequest(String name) {
        if (name == null || name.isBlank()) return Optional.empty();
        try {
            return Optional.of(valueOf(name.trim().toUpperCase(Locale.ROOT)));
        } catch (IllegalArgumentException unknown) {
            return Optional.empty();
        }
    }
}
