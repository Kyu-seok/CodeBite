package com.codebite.judge.grader;

import com.codebite.judge.dto.JudgeResponse;
import com.codebite.submission.entity.SubmissionStatus;

/**
 * The outcome of one test case: the Judge0 response mapped to a {@link SubmissionStatus}.
 *
 * <p>{@code judged} is false only for an Unjudged Case that ran to completion; such a case never
 * {@link #fails()}. {@code stdout} is trimmed, and {@code runtimeMs} is Judge0's wall time in
 * seconds converted to milliseconds, or null when Judge0 reported none.
 */
public record CaseVerdict(SubmissionStatus status,
                          boolean judged,
                          String stdout,
                          String stderr,
                          String compileOutput,
                          Integer runtimeMs,
                          Integer memoryKb) {

    public boolean fails() {
        return judged && status != SubmissionStatus.ACCEPTED;
    }

    /**
     * Maps a terminal Judge0 response. With an expected output, status 3 (program finished) is
     * ACCEPTED when the trimmed stdout equals the trimmed expected output and WRONG_ANSWER
     * otherwise. Without one, status 3 is ACCEPTED but unjudged. Every other status is judged
     * whether or not an expected output exists: a program that does not compile, crashes or
     * runs out of time has failed regardless of what it was meant to print.
     */
    public static CaseVerdict of(JudgeResponse response, String expectedOrNull) {
        String stdout = response.stdout() != null ? response.stdout().trim() : null;
        int statusId = response.status() != null ? response.status().id() : -1;

        SubmissionStatus status;
        boolean judged = true;
        if (statusId == 3) {
            if (expectedOrNull == null || expectedOrNull.isBlank()) {
                status = SubmissionStatus.ACCEPTED;
                judged = false;
            } else {
                String actual = stdout != null ? stdout : "";
                status = actual.equals(expectedOrNull.trim())
                        ? SubmissionStatus.ACCEPTED
                        : SubmissionStatus.WRONG_ANSWER;
            }
        } else if (statusId == 5) {
            status = SubmissionStatus.TIME_LIMIT_EXCEEDED;
        } else if (statusId == 6) {
            status = SubmissionStatus.COMPILATION_ERROR;
        } else if (statusId >= 7 && statusId <= 12) {
            status = SubmissionStatus.RUNTIME_ERROR;
        } else {
            status = SubmissionStatus.INTERNAL_ERROR;
        }

        return new CaseVerdict(status, judged, stdout, response.stderr(), response.compileOutput(),
                parseTimeToMs(response.time()), response.memory());
    }

    private static Integer parseTimeToMs(String time) {
        if (time == null) return null;
        try {
            return (int) (Double.parseDouble(time) * 1000);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
