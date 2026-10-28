package com.codebite.judge.grader;

import com.codebite.submission.entity.SubmissionStatus;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class VerdictTest {

    private static CaseVerdict accepted(Integer runtimeMs, Integer memoryKb) {
        return new CaseVerdict(SubmissionStatus.ACCEPTED, true, "ok", null, null, runtimeMs, memoryKb);
    }

    private static CaseVerdict failed(SubmissionStatus status) {
        return new CaseVerdict(status, true, null, null, null, null, null);
    }

    private static CaseVerdict unjudged(SubmissionStatus status) {
        return new CaseVerdict(status, false, "out", null, null, null, null);
    }

    @Test
    void empty_isAccepted() {
        assertThat(Verdict.empty().overall()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(Verdict.empty().cases()).isEmpty();
        assertThat(Verdict.of(List.of())).isEqualTo(Verdict.empty());
    }

    @Test
    void allAccepted_isAccepted() {
        Verdict verdict = Verdict.of(List.of(accepted(1, 1), accepted(2, 2)));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.cases()).hasSize(2);
    }

    @Test
    void firstFailingCaseInOrderDecidesOverall() {
        Verdict verdict = Verdict.of(List.of(
                accepted(1, 1),
                failed(SubmissionStatus.WRONG_ANSWER),
                failed(SubmissionStatus.RUNTIME_ERROR)));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.WRONG_ANSWER);
    }

    @Test
    void keepsEveryCaseInInputOrder() {
        List<CaseVerdict> cases = List.of(failed(SubmissionStatus.WRONG_ANSWER), accepted(1, 1));

        assertThat(Verdict.of(cases).cases()).containsExactlyElementsOf(cases);
    }

    @Test
    void unjudgedCaseNeverDecidesOverall() {
        // An unjudged case is only ever ACCEPTED in practice; a non-ACCEPTED one still may not fail.
        Verdict verdict = Verdict.of(List.of(unjudged(SubmissionStatus.ACCEPTED), unjudged(SubmissionStatus.WRONG_ANSWER)));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.ACCEPTED);
    }

    @Test
    void maxRuntimeAndMemory_ignoreNulls() {
        Verdict verdict = Verdict.of(List.of(accepted(10, null), accepted(null, 500), accepted(30, 200)));

        assertThat(verdict.maxRuntimeMs()).isEqualTo(30);
        assertThat(verdict.maxMemoryKb()).isEqualTo(500);
    }

    @Test
    void maxRuntimeAndMemory_nullWhenNoCaseHasOne() {
        Verdict verdict = Verdict.of(List.of(failed(SubmissionStatus.COMPILATION_ERROR)));

        assertThat(verdict.maxRuntimeMs()).isNull();
        assertThat(verdict.maxMemoryKb()).isNull();
    }
}
