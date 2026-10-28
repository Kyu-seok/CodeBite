package com.codebite.judge.grader;

import com.codebite.common.exception.JudgeExecutionException;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.service.JudgeService;
import com.codebite.submission.entity.SubmissionStatus;
import org.junit.jupiter.api.Test;

import java.util.List;

import static com.codebite.judge.grader.ScriptedJudgeClient.accepted;
import static com.codebite.judge.grader.ScriptedJudgeClient.compilationError;
import static com.codebite.judge.grader.ScriptedJudgeClient.runtimeError;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class GraderTest {

    private static final Program PROGRAM = new Program("class Solution {}", 62);

    private final ScriptedJudgeClient client = new ScriptedJudgeClient();
    private final Grader grader = new Grader(new JudgeService(client, 1, 1000));

    // --- grade: one batch, every case ---

    @Test
    void grade_allPass_accepted_oneCasePerInputInOrder() {
        client.respond("1 2", accepted("3\n")).respond("3 4", accepted("7\n"));

        Verdict verdict = grader.grade(PROGRAM, List.of(new TestInput("1 2", "3"), new TestInput("3 4", "7")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.cases()).extracting(CaseVerdict::stdout).containsExactly("3", "7");
        assertThat(verdict.cases()).allMatch(CaseVerdict::judged);
    }

    @Test
    void grade_submitsOneBatchWithTheProgramAndEveryStdin() {
        client.respond("a", accepted("1")).respond("b", accepted("2")).respond("c", accepted("3"));

        grader.grade(PROGRAM, List.of(new TestInput("a", "1"), new TestInput("b", "2"), new TestInput("c", "3")));

        assertThat(client.submitBatchCalls()).isEqualTo(1);
        assertThat(client.submitCalls()).isZero();
        assertThat(client.submitted()).extracting(JudgeRequest::stdin).containsExactly("a", "b", "c");
        assertThat(client.submitted()).allMatch(r -> r.sourceCode().equals("class Solution {}") && r.languageId() == 62);
    }

    @Test
    void grade_firstFailingCaseWins_everyCaseStillGraded() {
        client.respond("1", accepted("ok\n"))
                .respond("2", accepted("wrong\n"))
                .respond("3", runtimeError("NZEC"));

        Verdict verdict = grader.grade(PROGRAM, List.of(
                new TestInput("1", "ok"), new TestInput("2", "right"), new TestInput("3", "x")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.WRONG_ANSWER);
        assertThat(verdict.cases()).extracting(CaseVerdict::status).containsExactly(
                SubmissionStatus.ACCEPTED, SubmissionStatus.WRONG_ANSWER, SubmissionStatus.RUNTIME_ERROR);
    }

    @Test
    void grade_unjudgedCaseDoesNotPoisonOverall() {
        client.respond("ping", accepted("pong\n")).respond("1", accepted("1\n"));

        Verdict verdict = grader.grade(PROGRAM, List.of(new TestInput("ping", null), new TestInput("1", "1")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.cases().get(0).judged()).isFalse();
        assertThat(verdict.cases().get(0).stdout()).isEqualTo("pong");
    }

    @Test
    void grade_unjudgedCaseThatCrashesStillFails() {
        client.respond("crash", runtimeError("NZEC"));

        Verdict verdict = grader.grade(PROGRAM, List.of(new TestInput("crash", null)));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.RUNTIME_ERROR);
        assertThat(verdict.cases().get(0).judged()).isTrue();
        assertThat(verdict.cases().get(0).stderr()).isEqualTo("NZEC");
    }

    @Test
    void grade_emptyExpectedOutputIsJudged_outputFailsIt() {
        client.respond("1", accepted("no valid order\n")).respond("2", accepted(""));

        Verdict verdict = grader.grade(PROGRAM, List.of(new TestInput("1", ""), new TestInput("2", "")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.WRONG_ANSWER);
        assertThat(verdict.cases()).extracting(CaseVerdict::status)
                .containsExactly(SubmissionStatus.WRONG_ANSWER, SubmissionStatus.ACCEPTED);
        assertThat(verdict.cases()).allMatch(CaseVerdict::judged);
    }

    @Test
    void grade_maxRuntimeAndMemoryAcrossCases() {
        client.respond("1", accepted("1", "0.010", 1000))
                .respond("2", accepted("2", "0.250", 3000))
                .respond("3", compilationError("boom"));

        Verdict verdict = grader.grade(PROGRAM, List.of(
                new TestInput("1", "1"), new TestInput("2", "2"), new TestInput("3", "3")));

        assertThat(verdict.maxRuntimeMs()).isEqualTo(250);
        assertThat(verdict.maxMemoryKb()).isEqualTo(3000);
        assertThat(verdict.cases().get(2).compileOutput()).isEqualTo("boom");
    }

    @Test
    void grade_emptyList_acceptedWithoutCallingJudge0() {
        Verdict verdict = grader.grade(PROGRAM, List.of());

        assertThat(verdict).isEqualTo(Verdict.empty());
        assertThat(client.submitBatchCalls()).isZero();
    }

    @Test
    void grade_judgeExecutionExceptionPropagates() {
        client.respond("1", accepted("1"))
                .failSubmissionsWith(new JudgeExecutionException("Judge0 down", null));

        assertThatThrownBy(() -> grader.grade(PROGRAM, List.of(new TestInput("1", "1"))))
                .isInstanceOf(JudgeExecutionException.class)
                .hasMessageContaining("Judge0 down");
    }

    // --- gradeUntilFailure: sequential, stops at the first failing judged case ---

    @Test
    void gradeUntilFailure_allPass_runsEveryCaseOneAtATime() {
        client.respond("1", accepted("1\n")).respond("2", accepted("2\n"));

        Verdict verdict = grader.gradeUntilFailure(PROGRAM, List.of(new TestInput("1", "1"), new TestInput("2", "2")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.cases()).hasSize(2);
        assertThat(client.submitCalls()).isEqualTo(2);
        assertThat(client.submitBatchCalls()).isZero();
    }

    @Test
    void gradeUntilFailure_stopsAfterFirstFailure_casesArePrefix() {
        client.respond("1", accepted("1\n"))
                .respond("2", accepted("nope\n"))
                .respond("3", accepted("3\n"));

        Verdict verdict = grader.gradeUntilFailure(PROGRAM, List.of(
                new TestInput("1", "1"), new TestInput("2", "2"), new TestInput("3", "3")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.WRONG_ANSWER);
        assertThat(verdict.cases()).extracting(CaseVerdict::status)
                .containsExactly(SubmissionStatus.ACCEPTED, SubmissionStatus.WRONG_ANSWER);
        assertThat(client.submitCalls()).isEqualTo(2);
        assertThat(client.submitted()).extracting(JudgeRequest::stdin).containsExactly("1", "2");
    }

    @Test
    void gradeUntilFailure_compilationErrorOnFirstCase_stopsAtOnce() {
        client.respond("1", compilationError("error: ';' expected")).respond("2", accepted("2"));

        Verdict verdict = grader.gradeUntilFailure(PROGRAM, List.of(new TestInput("1", "1"), new TestInput("2", "2")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.COMPILATION_ERROR);
        assertThat(verdict.cases()).hasSize(1);
        assertThat(verdict.cases().get(0).compileOutput()).isEqualTo("error: ';' expected");
        assertThat(client.submitCalls()).isEqualTo(1);
    }

    @Test
    void gradeUntilFailure_unjudgedCaseDoesNotStopTheRun() {
        client.respond("free", accepted("whatever\n")).respond("2", accepted("2\n"));

        Verdict verdict = grader.gradeUntilFailure(PROGRAM, List.of(new TestInput("free", null), new TestInput("2", "2")));

        assertThat(verdict.overall()).isEqualTo(SubmissionStatus.ACCEPTED);
        assertThat(verdict.cases()).hasSize(2);
        assertThat(client.submitCalls()).isEqualTo(2);
    }

    @Test
    void gradeUntilFailure_emptyList_acceptedWithoutCallingJudge0() {
        Verdict verdict = grader.gradeUntilFailure(PROGRAM, List.of());

        assertThat(verdict).isEqualTo(Verdict.empty());
        assertThat(client.submitCalls()).isZero();
    }

    @Test
    void gradeUntilFailure_judgeExecutionExceptionPropagates() {
        client.respond("1", accepted("1"))
                .failSubmissionsWith(new JudgeExecutionException("Judge0 down", null));

        assertThatThrownBy(() -> grader.gradeUntilFailure(PROGRAM, List.of(new TestInput("1", "1"))))
                .isInstanceOf(JudgeExecutionException.class);
    }
}
