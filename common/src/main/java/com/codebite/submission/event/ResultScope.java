package com.codebite.submission.event;

import com.codebite.submission.entity.SubmissionStatus;

import java.util.function.Predicate;

/**
 * Which Verdicts on {@code submission-results} a listener acts on.
 *
 * <p>Each listener names its scope once, at the top of its handler, so the rule that decides
 * whether an event matters to it is read in one place and written in one. Admin submissions are
 * the recurring question: admin bulk validation runs as a service account, so some consumers must
 * ignore it and others must not.
 */
public enum ResultScope implements Predicate<SubmissionResultEvent> {

    /**
     * Accepted Verdicts of non-admin submissions. Streak Days: an admin's bulk validation would
     * hand the service account a Streak.
     */
    ACCEPTED_USERS,

    /**
     * Every Accepted Verdict, admins' included. Solution Commits: the GitHub Link is the opt-in,
     * so an admin account with no link commits nothing.
     */
    ACCEPTED_ALL,

    /** Every Verdict. The SSE push; stats, which drop admin submissions themselves. */
    ALL;

    @Override
    public boolean test(SubmissionResultEvent event) {
        return switch (this) {
            case ACCEPTED_USERS -> event.status() == SubmissionStatus.ACCEPTED && !event.adminSubmission();
            case ACCEPTED_ALL -> event.status() == SubmissionStatus.ACCEPTED;
            case ALL -> true;
        };
    }
}
