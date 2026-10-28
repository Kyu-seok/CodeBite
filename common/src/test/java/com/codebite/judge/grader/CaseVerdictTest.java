package com.codebite.judge.grader;

import com.codebite.judge.dto.JudgeResponse;
import com.codebite.submission.entity.SubmissionStatus;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class CaseVerdictTest {

    private static JudgeResponse finished(String stdout) {
        return new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), stdout, null, null, "0.01", 9400);
    }

    private static JudgeResponse status(int id, String stderr, String compileOutput) {
        return new JudgeResponse(null, new JudgeResponse.Status(id, "x"), null, stderr, compileOutput, null, null);
    }

    // --- with an expected output ---

    @Test
    void status3_outputMatches_accepted() {
        CaseVerdict verdict = CaseVerdict.of(finished("[0,1]\n"), "[0,1]");

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.judged()).isTrue();
        assertThat(verdict.fails()).isFalse();
    }

    @Test
    void status3_outputDiffers_wrongAnswer() {
        CaseVerdict verdict = CaseVerdict.of(finished("[1,2]\n"), "[0,1]");

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.WRONG_ANSWER);
        assertThat(verdict.fails()).isTrue();
    }

    @Test
    void status3_trimsBothSidesBeforeComparing() {
        CaseVerdict verdict = CaseVerdict.of(finished("  [0,1]  \n"), "  [0,1]  ");

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.stdout()).isEqualTo("[0,1]");
    }

    @Test
    void status3_nullStdout_wrongAnswer() {
        CaseVerdict verdict = CaseVerdict.of(finished(null), "[0,1]");

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.WRONG_ANSWER);
        assertThat(verdict.stdout()).isNull();
    }

    @Test
    void status5_timeLimitExceeded() {
        assertThat(CaseVerdict.of(status(5, null, null), "expected").status())
                .isEqualTo(SubmissionStatus.TIME_LIMIT_EXCEEDED);
    }

    @Test
    void status6_compilationError_keepsCompileOutput() {
        CaseVerdict verdict = CaseVerdict.of(status(6, null, "error msg"), "expected");

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.COMPILATION_ERROR);
        assertThat(verdict.compileOutput()).isEqualTo("error msg");
    }

    @Test
    void status7to12_runtimeError_keepsStderr() {
        for (int statusId = 7; statusId <= 12; statusId++) {
            CaseVerdict verdict = CaseVerdict.of(status(statusId, "SIGSEGV", null), "expected");

            assertThat(verdict.status()).isEqualTo(SubmissionStatus.RUNTIME_ERROR);
            assertThat(verdict.stderr()).isEqualTo("SIGSEGV");
        }
    }

    @Test
    void status13plus_internalError() {
        assertThat(CaseVerdict.of(status(13, null, null), "expected").status())
                .isEqualTo(SubmissionStatus.INTERNAL_ERROR);
    }

    @Test
    void missingStatus_internalError() {
        JudgeResponse noStatus = new JudgeResponse(null, null, null, null, null, null, null);

        CaseVerdict verdict = CaseVerdict.of(noStatus, "expected");

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.INTERNAL_ERROR);
        assertThat(verdict.judged()).isTrue();
    }

    // --- without an expected output (an Unjudged Case) ---

    @Test
    void status3_noExpected_acceptedButUnjudged() {
        CaseVerdict verdict = CaseVerdict.of(finished("anything\n"), null);

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.judged()).isFalse();
        assertThat(verdict.fails()).isFalse();
        assertThat(verdict.stdout()).isEqualTo("anything");
    }

    @Test
    void status3_blankExpected_treatedAsNoExpected() {
        CaseVerdict verdict = CaseVerdict.of(finished("anything\n"), "   ");

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.judged()).isFalse();
    }

    @Test
    void status11_noExpected_runtimeErrorIsStillJudged() {
        CaseVerdict verdict = CaseVerdict.of(status(11, "NZEC", null), null);

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.RUNTIME_ERROR);
        assertThat(verdict.judged()).isTrue();
        assertThat(verdict.fails()).isTrue();
    }

    @Test
    void status6_noExpected_compilationErrorIsStillJudged() {
        CaseVerdict verdict = CaseVerdict.of(status(6, null, "boom"), null);

        assertThat(verdict.status()).isEqualTo(SubmissionStatus.COMPILATION_ERROR);
        assertThat(verdict.fails()).isTrue();
    }

    // --- figures ---

    @Test
    void runtimeIsSecondsTimesThousand_memoryPassedThrough() {
        CaseVerdict verdict = CaseVerdict.of(
                new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), "", null, null, "0.123", 2048), "");

        assertThat(verdict.runtimeMs()).isEqualTo(123);
        assertThat(verdict.memoryKb()).isEqualTo(2048);
    }

    @Test
    void missingOrUnparsableTime_nullRuntime() {
        assertThat(CaseVerdict.of(status(5, null, null), "x").runtimeMs()).isNull();
        assertThat(CaseVerdict.of(
                new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), "", null, null, "n/a", null), "")
                .runtimeMs()).isNull();
    }
}
