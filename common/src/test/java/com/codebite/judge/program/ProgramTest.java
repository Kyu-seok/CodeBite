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
