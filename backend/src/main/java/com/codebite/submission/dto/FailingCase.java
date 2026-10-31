package com.codebite.submission.dto;

import com.codebite.judge.dto.CodeError;
import com.codebite.judge.program.Program;
import com.codebite.problem.entity.TestCase;
import com.codebite.submission.entity.SubmissionResult;
import com.codebite.submission.entity.SubmissionStatus;

import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * A submission's Failing Case (GLOSSARY.md): the first stored case, in order, that is not
 * Accepted. Its input and expected output are given even when the case is hidden, the one hidden
 * case a submission reveals (docs/adr/0006).
 *
 * @param position 1-based, among {@code total} graded cases
 */
public record FailingCase(
        Long testCaseId,
        int position,
        int total,
        boolean hidden,
        SubmissionStatus status,
        String input,
        String expectedOutput,
        String actualOutput,
        List<CodeError> errors
) {

    /** Statuses whose Failing Case is the user's to look at; the rest have none. */
    private static final Set<SubmissionStatus> CASE_FAILURES = Set.of(
            SubmissionStatus.WRONG_ANSWER,
            SubmissionStatus.RUNTIME_ERROR,
            SubmissionStatus.TIME_LIMIT_EXCEEDED);

    /**
     * The Failing Case of a submission with this overall status and these results in case order,
     * or empty when it has none: Accepted, still pending, failed to compile, or failed on our side
     * (INTERNAL_ERROR, including an Abandoned submission).
     */
    public static Optional<FailingCase> of(SubmissionStatus overall, List<SubmissionResult> results,
                                           Program program) {
        if (!CASE_FAILURES.contains(overall)) {
            return Optional.empty();
        }
        for (int i = 0; i < results.size(); i++) {
            SubmissionResult r = results.get(i);
            if (r.getStatus() == SubmissionStatus.ACCEPTED) {
                continue;
            }
            if (!CASE_FAILURES.contains(r.getStatus())) {
                return Optional.empty();
            }
            TestCase tc = r.getTestCase();
            return Optional.of(new FailingCase(
                    tc.getId(), i + 1, results.size(), !tc.isSample(), r.getStatus(),
                    tc.getInput(), tc.getExpectedOutput(), r.getActualOutput(),
                    program.diagnostics(r.getCompileOutput(), r.getStderr())));
        }
        return Optional.empty();
    }
}
