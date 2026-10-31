package com.codebite.onboarding;

import java.util.Arrays;
import java.util.Locale;

/**
 * What the Tutorial reports as it happens, in funnel order (GLOSSARY.md, Onboarding). Not the
 * Tutorial's six card steps: a milestone is a counted event, written lower case in the API and
 * the metric tag.
 */
public enum TutorialMilestone {
    STARTED, RAN, SUBMITTED, ACCEPTED, SKIPPED;

    /** The lower-case name used in the path and the {@code milestone} tag. */
    public String tag() {
        return name().toLowerCase(Locale.ROOT);
    }

    /** The milestone with this lower-case name; IllegalArgumentException (a 400) for any other. */
    public static TutorialMilestone ofTag(String tag) {
        return Arrays.stream(values())
                .filter(milestone -> milestone.tag().equals(tag))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown Tutorial milestone: " + tag));
    }
}
