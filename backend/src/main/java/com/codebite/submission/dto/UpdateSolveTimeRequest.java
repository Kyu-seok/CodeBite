package com.codebite.submission.dto;

import jakarta.validation.constraints.PositiveOrZero;

/** A null (or zero) solve time means the learner has no time to record: the timer never ran. */
public record UpdateSolveTimeRequest(
        @PositiveOrZero Integer solveTimeSeconds
) {
}
