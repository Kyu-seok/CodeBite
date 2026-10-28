package com.codebite.judge.grader;

import com.codebite.submission.entity.SubmissionStatus;

import java.util.List;

/**
 * The outcome of grading one program against an ordered list of test cases (docs/adr/0005).
 *
 * <p>{@code cases} keeps input order. {@code overall} is the status of the first case that
 * {@link CaseVerdict#fails()}, or ACCEPTED when none does, so an Unjudged Case that ran to
 * completion never decides it. {@code maxRuntimeMs} and {@code maxMemoryKb} ignore cases Judge0
 * reported no figure for and are null when no case has one.
 */
public record Verdict(SubmissionStatus overall,
                      List<CaseVerdict> cases,
                      Integer maxRuntimeMs,
                      Integer maxMemoryKb) {

    public static Verdict empty() {
        return new Verdict(SubmissionStatus.ACCEPTED, List.of(), null, null);
    }

    public static Verdict of(List<CaseVerdict> cases) {
        SubmissionStatus overall = SubmissionStatus.ACCEPTED;
        Integer maxRuntimeMs = null;
        Integer maxMemoryKb = null;

        for (CaseVerdict caseVerdict : cases) {
            if (caseVerdict.fails() && overall == SubmissionStatus.ACCEPTED) {
                overall = caseVerdict.status();
            }
            if (caseVerdict.runtimeMs() != null) {
                maxRuntimeMs = maxRuntimeMs == null
                        ? caseVerdict.runtimeMs() : Math.max(maxRuntimeMs, caseVerdict.runtimeMs());
            }
            if (caseVerdict.memoryKb() != null) {
                maxMemoryKb = maxMemoryKb == null
                        ? caseVerdict.memoryKb() : Math.max(maxMemoryKb, caseVerdict.memoryKb());
            }
        }

        return new Verdict(overall, List.copyOf(cases), maxRuntimeMs, maxMemoryKb);
    }
}
