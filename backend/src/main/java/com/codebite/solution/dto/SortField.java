package com.codebite.solution.dto;

public enum SortField {
    NET_SCORE,
    RECENT,
    COMMENTS,
    OLDEST;

    public static SortField fromString(String value) {
        if (value == null) return NET_SCORE;
        try {
            return SortField.valueOf(value.trim().toUpperCase().replace('-', '_'));
        } catch (IllegalArgumentException e) {
            return NET_SCORE;
        }
    }
}
