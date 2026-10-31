package com.codebite.user.repository;

import java.time.Instant;

/**
 * A user's sign-up and their first Accepted, non-admin submission, or null when they have none:
 * the row behind the admin dashboard's onboarding success figure.
 */
public record SignUp(Instant signedUpAt, Instant firstAcceptedAt) {
}
