package com.codebite.judge.program;

import com.codebite.judge.Language;
import com.codebite.judge.dto.CodeError;
import com.codebite.submission.event.SubmissionEvent;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class ProgramTest {

    /** {@code two-line}: Java puts the user's code on line 2; Python on line 4, after its Library. */
    private static final ProblemAssets ASSETS = new ProblemAssets("classpath:problem-assets/valid/");

    @Test
    void diagnostics_mapCombinedLinesOntoTheUserBuffer() {
        Program program = ASSETS.assemble("two-line", Language.JAVA, "a\nint x = 1\nc");

        List<CodeError> errors = program.diagnostics("Main.java:3: error: ';' expected\n1 error", null);

        assertThat(errors).hasSize(1);
        assertThat(errors.get(0).line()).isEqualTo(2);
        assertThat(errors.get(0).inUserCode()).isTrue();
        assertThat(errors.get(0).message()).contains("';' expected");
    }

    @Test
    void diagnostics_countTheLibrarySplicedInAboveTheUserCode() {
        Program program = ASSETS.assemble("two-line", Language.PYTHON, "x = 1\ny = 1 / 0");

        List<CodeError> errors = program.diagnostics(null, """
                Traceback (most recent call last):
                  File "script.py", line 5, in <module>
                ZeroDivisionError: division by zero
                """);

        assertThat(errors).extracting(CodeError::line).containsExactly(2);
    }

    @Test
    void diagnostics_collapseDriverErrorsIntoTheTemplateBanner() {
        Program program = ASSETS.assemble("two-line", Language.JAVA, "a");

        List<CodeError> errors = program.diagnostics("Main.java:1: error: broken driver\n1 error", null);

        assertThat(errors).singleElement().satisfies(e -> {
            assertThat(e.line()).isNull();
            assertThat(e.inUserCode()).isFalse();
        });
    }

    // --- A real Java Driver: only its imports above the user's code, its Library below (#412) ---

    private static final ProblemAssets DRIVERS = new ProblemAssets();

    /** Opens with an import; line 4 lacks its semicolon and line 5 dereferences null. */
    private static final String ADD_SCORE_LISTS = """
            import java.util.stream.*;
            class Solution {
                public ListNode addScoreLists(ListNode l1, ListNode l2) {
                    int carry = 0
                    return l1.next.next.next.next;
                }
            }""";

    @Test
    void diagnostics_onARealJavaDriver_aCompileErrorNamesTheUsersOwnLine() {
        Program program = DRIVERS.assemble("add-score-lists", Language.JAVA, ADD_SCORE_LISTS);

        List<CodeError> errors = program.diagnostics("Main.java:6: error: ';' expected\n1 error", null);

        assertThat(errors).extracting(CodeError::line).containsExactly(4);
    }

    @Test
    void diagnostics_onARealJavaDriver_aRuntimeErrorNamesTheUsersOwnLine() {
        Program program = DRIVERS.assemble("add-score-lists", Language.JAVA, ADD_SCORE_LISTS);

        List<CodeError> errors = program.diagnostics(null, """
                Exception in thread "main" java.lang.NullPointerException
                \tat Solution.addScoreLists(Main.java:7)
                \tat Main.main(Main.java:56)
                """);

        // The user's frame on its own line; the Main frame, below the user's code, on the last.
        assertThat(errors).extracting(CodeError::line).containsExactly(5, 7);
        assertThat(errors).allSatisfy(e -> {
            assertThat(e.inUserCode()).isTrue();
            assertThat(e.message()).isEqualTo("java.lang.NullPointerException");
        });
    }

    @Test
    void diagnostics_onARealJavaDriver_aFrameInsideTheLibraryIsReportedAsAMainFrameIs() {
        Program program = DRIVERS.assemble("add-score-lists", Language.JAVA, ADD_SCORE_LISTS);

        List<CodeError> errors = program.diagnostics(null, """
                Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
                \tat ListNode.toJsonArray(Main.java:40)
                \tat Main.main(Main.java:56)
                """);

        // Neither frame is the user's: both land on the last line of their code, with the message.
        assertThat(errors).extracting(CodeError::line).containsExactly(7, 7);
        assertThat(errors).allSatisfy(e ->
                assertThat(e.message()).isEqualTo("java.lang.OutOfMemoryError: Java heap space"));
    }

    @Test
    void diagnostics_areEmptyWhenJudge0ReportsNothing() {
        assertThat(ASSETS.assemble("two-line", Language.JAVA, "a").diagnostics(null, null)).isEmpty();
    }

    @Test
    void fromEvent_keepsTheEventsSourceAndJudge0Id_andHasNoDiagnostics() {
        Program program = Program.fromEvent(new SubmissionEvent(1L, "Main.java", 71, 2L, false, "python"));

        assertThat(program.source()).isEqualTo("Main.java");
        assertThat(program.language()).isEqualTo(Language.PYTHON);
        assertThat(program.judge0Id()).isEqualTo(71);
        assertThat(program.diagnostics(null, "  File \"script.py\", line 1\nError: x")).isEmpty();
    }

    @Test
    void fromEvent_rejectsAnUnknownLanguage() {
        assertThatThrownBy(() -> Program.fromEvent(new SubmissionEvent(1L, "src", 50, 2L, false, "c")))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void programsAreEqualWhenJudge0WouldBeSentTheSameThing() {
        assertThat(ASSETS.assemble("two-line", Language.JAVA, "a"))
                .isEqualTo(ASSETS.assemble("two-line", Language.JAVA, "a"))
                .isNotEqualTo(ASSETS.assemble("two-line", Language.JAVA, "b"));
    }
}
