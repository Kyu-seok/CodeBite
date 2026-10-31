package com.codebite.admin.dto;

/**
 * Does onboarding work: of the non-admin users who signed up in the last {@code days} days,
 * how many had an Accepted, non-admin submission within 24 hours of signing up. {@code percent}
 * is to one decimal, or null when nobody signed up, so the dashboard shows a dash, not 0%.
 */
public record OnboardingSuccess(int days, long signedUp, long acceptedWithin24h, Double percent) {
}
