package com.codebite.submission.entity;

import com.codebite.judge.Language;
import com.codebite.judge.grader.CaseVerdict;
import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.submission.event.SubmissionResultEvent;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SubmissionTest {

    private static User user(long id, Role role) {
        User user = new User();
        user.setId(id);
        user.setRole(role);
        return user;
    }

    private static Problem problem(long id) {
        Problem problem = new Problem();
        problem.setId(id);
        return problem;
    }

    private static TestCase testCase(long id) {
        TestCase testCase = new TestCase();
        testCase.setId(id);
        return testCase;
    }

    private static Submission pending() {
        Submission submission = Submission.pending(user(77L, Role.USER), problem(10L), "java", "code");
        submission.setId(1L);
        return submission;
    }

    private static CaseVerdict accepted(String stdout, Integer runtimeMs, Integer memoryKb) {
        return new CaseVerdict(SubmissionStatus.ACCEPTED, true, stdout, null, null, runtimeMs, memoryKb);
    }

    private static CaseVerdict wrongAnswer(String stdout, Integer runtimeMs, Integer memoryKb) {
        return new CaseVerdict(SubmissionStatus.WRONG_ANSWER, true, stdout, "warn", null, runtimeMs, memoryKb);
    }

    @Test
    void pendingStartsPendingWithTheGivenFields() {
        Submission submission = Submission.pending(user(77L, Role.USER), problem(10L), "java", "code");

        assertTrue(submission.isPending());
        assertEquals(SubmissionStatus.PENDING, submission.getStatus());
        assertEquals("java", submission.getLanguage());
        assertEquals("code", submission.getSourceCode());
        assertEquals(77L, submission.getUser().getId());
        assertEquals(10L, submission.getProblem().getId());
        assertFalse(submission.isAdminSubmission());
        assertTrue(submission.getResults().isEmpty());
    }

    @Test
    void pendingFlagsAnAdminsSubmission() {
        assertTrue(Submission.pending(user(1L, Role.ADMIN), problem(10L), "java", "code").isAdminSubmission());
    }

    @Test
    void gradeTakesTheVerdictsOverallAndMaximaAndAddsOneResultPerCaseInOrder() {
        Submission submission = pending();
        TestCase tc1 = testCase(1L);
        TestCase tc2 = testCase(2L);

        SubmissionResultEvent event = submission.grade(
                Verdict.of(List.of(accepted("3", 12, 4000), wrongAnswer("wrong", 30, 2000))),
                List.of(tc1, tc2));

        assertEquals(SubmissionStatus.WRONG_ANSWER, submission.getStatus());
        assertFalse(submission.isPending());
        assertEquals(30, submission.getRuntimeMs());
        assertEquals(4000, submission.getMemoryKb());

        List<SubmissionResult> rows = submission.getResults();
        assertEquals(2, rows.size());
        assertSame(submission, rows.get(0).getSubmission());
        assertSame(tc1, rows.get(0).getTestCase());
        assertEquals(SubmissionStatus.ACCEPTED, rows.get(0).getStatus());
        assertEquals("3", rows.get(0).getActualOutput());
        assertEquals(12, rows.get(0).getRuntimeMs());
        assertEquals(4000, rows.get(0).getMemoryKb());
        assertSame(tc2, rows.get(1).getTestCase());
        assertEquals(SubmissionStatus.WRONG_ANSWER, rows.get(1).getStatus());
        assertEquals("wrong", rows.get(1).getActualOutput());
        assertEquals("warn", rows.get(1).getStderr());

        assertEquals(SubmissionStatus.WRONG_ANSWER, event.status());
        assertEquals(30, event.runtimeMs());
        assertEquals(4000, event.memoryKb());
    }

    /** The first failing case decides, whatever comes after it (docs/adr/0005). */
    @Test
    void gradeKeepsTheFirstFailureWhenALaterCasePasses() {
        Submission submission = pending();

        submission.grade(
                Verdict.of(List.of(wrongAnswer("x", 1, 1), accepted("y", 1, 1))),
                List.of(testCase(1L), testCase(2L)));

        assertEquals(SubmissionStatus.WRONG_ANSWER, submission.getStatus());
    }

    @Test
    void gradeIgnoresCasesWithoutAFigureWhenFoldingMaxima() {
        Submission submission = pending();

        submission.grade(
                Verdict.of(List.of(accepted("a", null, null), accepted("b", 7, 300))),
                List.of(testCase(1L), testCase(2L)));

        assertEquals(7, submission.getRuntimeMs());
        assertEquals(300, submission.getMemoryKb());
    }

    @Test
    void gradeWithNoCasesIsAcceptedWithNoFigures() {
        Submission submission = pending();

        submission.grade(Verdict.empty(), List.of());

        assertEquals(SubmissionStatus.ACCEPTED, submission.getStatus());
        assertNull(submission.getRuntimeMs());
        assertNull(submission.getMemoryKb());
        assertTrue(submission.getResults().isEmpty());
    }

    @Test
    void gradeRefusesAVerdictThatDoesNotMatchTheTestCases() {
        Submission submission = pending();
        Verdict verdict = Verdict.of(List.of(accepted("a", 1, 1)));
        List<TestCase> twoCases = List.of(testCase(1L), testCase(2L));

        assertThrows(IllegalArgumentException.class, () -> submission.grade(verdict, twoCases));
        assertTrue(submission.isPending());
    }

    @Test
    void theEventCarriesTheRowsEightFields() {
        Submission submission = Submission.pending(user(77L, Role.ADMIN), problem(10L), "python", "code");
        submission.setId(5L);

        SubmissionResultEvent event = submission.grade(
                Verdict.of(List.of(accepted("ok", 12, 9000))), List.of(testCase(1L)));

        assertEquals(new SubmissionResultEvent(
                5L, 77L, 10L, SubmissionStatus.ACCEPTED, 12, 9000, "python", true), event);
    }

    @Test
    void failIsInternalErrorWithoutFiguresOrResults() {
        Submission submission = pending();

        SubmissionResultEvent event = submission.fail();

        assertEquals(SubmissionStatus.INTERNAL_ERROR, submission.getStatus());
        assertNull(submission.getRuntimeMs());
        assertNull(submission.getMemoryKb());
        assertTrue(submission.getResults().isEmpty());
        assertEquals(new SubmissionResultEvent(
                1L, 77L, 10L, SubmissionStatus.INTERNAL_ERROR, null, null, "java", false), event);
    }

    @Test
    void abandonIsInternalErrorWithoutFiguresOrResults() {
        Submission submission = pending();

        SubmissionResultEvent event = submission.abandon();

        assertEquals(SubmissionStatus.INTERNAL_ERROR, submission.getStatus());
        assertTrue(submission.getResults().isEmpty());
        assertEquals(SubmissionStatus.INTERNAL_ERROR, event.status());
        assertEquals(1L, event.submissionId());
    }

    @Test
    void terminalTransitionsRefuseARowThatIsNoLongerPending() {
        Submission graded = pending();
        graded.grade(Verdict.empty(), List.of());
        Verdict again = Verdict.empty();

        assertThrows(IllegalStateException.class, graded::fail);
        assertThrows(IllegalStateException.class, graded::abandon);
        assertThrows(IllegalStateException.class, () -> graded.grade(again, List.of()));
        assertEquals(SubmissionStatus.ACCEPTED, graded.getStatus());
    }

    @Test
    void language_isTheStoredCodeAsALanguage_andAnUnknownCodeIsIllegalState() {
        assertSame(Language.JAVA, pending().language());

        Submission stored = pending();
        stored.setLanguage("c");
        assertThrows(IllegalStateException.class, stored::language);
    }
}
