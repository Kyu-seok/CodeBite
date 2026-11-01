package com.codebite.problem.guarantee;

import com.codebite.problem.MigratedDatabase;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestFactory;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every problem's Test Cases, as the migrations leave them, against its {@link ProblemGuarantee}:
 * each input is one the statement allows, and its expected output is the only output the statement
 * accepts. A problem without a Guarantee is skipped; each Test Case Correction adds one.
 */
class ProblemGuaranteesTest {

    private static final MigratedDatabase DATABASE = new MigratedDatabase("problem-guarantees");

    /** One per problem whose Test Cases have been checked against its statement. */
    static final List<ProblemGuarantee> GUARANTEES = List.of(
            new TwoMenuSumGuarantee());

    private record Case(int position, boolean sample, String input, String expectedOutput) {
        String name() {
            return (sample ? "sample " : "hidden ") + "case at order_index " + position;
        }
    }

    @BeforeAll
    static void migrate() {
        DATABASE.migrate();
    }

    @TestFactory
    Stream<DynamicTest> everyCaseKeepsItsProblemsGuarantee() {
        return GUARANTEES.stream().map(guarantee -> DynamicTest.dynamicTest(guarantee.slug(), () -> {
            List<Case> cases = cases(guarantee.slug());
            assertFalse(cases.isEmpty(), guarantee.slug() + " has no Test Cases (a Restatement that "
                    + "renamed the Slug but not its Guarantee?)");
            List<String> broken = new ArrayList<>();
            for (Case c : cases) {
                CaseInput input = CaseInput.of(c.input());
                List<String> violations;
                try {
                    violations = guarantee.inputViolations(input);
                } catch (RuntimeException e) {
                    broken.add(c.name() + ": input unreadable (" + e + "): " + c.input().replace("\n", "\\n"));
                    continue;
                }
                if (!violations.isEmpty()) {
                    broken.add(c.name() + ": input breaks the statement: " + violations);
                    continue;
                }
                Set<String> correct = guarantee.correctOutputs(input);
                String expected = c.expectedOutput().strip();
                if (!correct.equals(Set.of(expected))) {
                    broken.add(c.name() + ": expected " + expected + " but the statement accepts " + correct);
                }
            }
            assertTrue(broken.isEmpty(), guarantee.slug() + " needs a Test Case Correction:\n  "
                    + String.join("\n  ", broken));
        }));
    }

    @Test
    void everyGuaranteeNamesAProblem() throws SQLException {
        Set<String> slugs = Set.copyOf(DATABASE.strings("SELECT slug FROM problems"));
        List<String> orphans = GUARANTEES.stream().map(ProblemGuarantee::slug).filter(s -> !slugs.contains(s)).toList();
        assertTrue(orphans.isEmpty(), "Guarantees for no problem's Slug (renamed by a Restatement?): " + orphans);
    }

    private static List<Case> cases(String slug) throws SQLException {
        return DATABASE.query("""
                        SELECT t.order_index, t.is_sample, t.input, t.expected_output
                        FROM test_cases t JOIN problems p ON p.id = t.problem_id
                        WHERE p.slug = ? ORDER BY t.order_index, t.id""",
                row -> new Case(row.getInt(1), row.getBoolean(2),
                        MigratedDatabase.postgresText(row.getString(3)),
                        MigratedDatabase.postgresText(row.getString(4))),
                slug);
    }
}
