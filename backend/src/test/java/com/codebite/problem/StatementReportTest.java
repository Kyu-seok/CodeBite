package com.codebite.problem;

import com.codebite.problem.StatementReport.Finding;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;

class StatementReportTest {

    private static final List<Finding> FINDINGS = List.of(
            new Finding("fizz-buzz", "fizz-buzz (en)", List.of("Example 1 input isn't 3")),
            new Finding("fizz-buzz", "fizz-buzz (ko)", List.of("Example 1 input isn't 3", "Example 2 output isn't Fizz")),
            new Finding("two-sum", "two-sum (en)", List.of("no Example")));
    private static final Set<String> BREAKING = Set.of("fizz-buzz", "two-sum");
    private static final Set<String> LISTED = Set.of("fizz-buzz");

    @Test
    void oneBlockPerProblemAndLanguageWithListedOnesMarked() {
        assertEquals("""
                examples: 2 problems break the check, 1 listed. A problem absent here passes.

                fizz-buzz (en) [listed]
                  Example 1 input isn't 3

                fizz-buzz (ko) [listed]
                  Example 1 input isn't 3
                  Example 2 output isn't Fizz

                two-sum (en)
                  no Example
                """, StatementReport.render("examples", LISTED, BREAKING, FINDINGS));
    }

    @Test
    void aListedProblemThatPassesIsNotCountedAsListed() {
        String report = StatementReport.render("examples", Set.of("fizz-buzz", "stale-one"), BREAKING, FINDINGS);
        assertEquals("examples: 2 problems break the check, 1 listed. A problem absent here passes.",
                report.lines().findFirst().orElseThrow());
    }

    @Test
    void nothingBreakingIsAReportToo() {
        assertEquals("constraints: 0 problems break the check, 0 listed. A problem absent here passes.\n",
                StatementReport.render("constraints", Set.of(), Set.of(), List.of()));
    }

    @Test
    void theReportIsWrittenUnderTheCheckName(@TempDir Path directory) throws IOException {
        Path written = StatementReport.write(directory.resolve("statements"), "examples", LISTED, BREAKING, FINDINGS);
        assertEquals(directory.resolve("statements").resolve("examples.txt"), written);
        assertEquals(StatementReport.render("examples", LISTED, BREAKING, FINDINGS), Files.readString(written));
    }

    @Test
    void aPassingCheckStillWritesItsReport(@TempDir Path directory) throws IOException {
        Path written = StatementReport.write(directory, "constraints", Set.of(), Set.of(), List.of());
        assertEquals(StatementReport.render("constraints", Set.of(), Set.of(), List.of()), Files.readString(written));
    }
}
