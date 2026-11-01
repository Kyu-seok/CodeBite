package com.codebite.problem.guarantee;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every problem's Test Cases, as the migrations leave them, against its {@link ProblemGuarantee}:
 * each input is one the statement allows, and its expected output is the only output the statement
 * accepts. A problem without a Guarantee is skipped; each Test Case Correction adds one.
 *
 * <p>Runs the migrations on its own H2 database: the shared test database is emptied by other tests.
 */
class ProblemGuaranteesTest {

    private static final String URL =
            "jdbc:h2:mem:problem-guarantees;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";

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
        Flyway.configure().dataSource(URL, "sa", "").locations("classpath:db/migration").load().migrate();
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
        Set<String> slugs = new TreeSet<>(column("SELECT slug FROM problems"));
        List<String> orphans = GUARANTEES.stream().map(ProblemGuarantee::slug).filter(s -> !slugs.contains(s)).toList();
        assertTrue(orphans.isEmpty(), "Guarantees for no problem's Slug (renamed by a Restatement?): " + orphans);
    }

    /** Cases are graded in order_index order, so two at one position run in no fixed order. */
    @Test
    void noTwoCasesOfAProblemShareAPosition() throws SQLException {
        List<String> clashes = column("""
                SELECT p.slug || ' order_index ' || t.order_index
                FROM test_cases t JOIN problems p ON p.id = t.problem_id
                GROUP BY p.slug, t.order_index HAVING COUNT(*) > 1
                ORDER BY 1""");
        assertTrue(clashes.isEmpty(), "Positions held by more than one Test Case: " + clashes);
    }

    private static List<Case> cases(String slug) throws SQLException {
        List<Case> cases = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(URL, "sa", "");
             PreparedStatement statement = connection.prepareStatement("""
                     SELECT t.order_index, t.is_sample, t.input, t.expected_output
                     FROM test_cases t JOIN problems p ON p.id = t.problem_id
                     WHERE p.slug = ? ORDER BY t.order_index, t.id""")) {
            statement.setString(1, slug);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    cases.add(new Case(rows.getInt(1), rows.getBoolean(2),
                            postgresEscapes(rows.getString(3)), postgresEscapes(rows.getString(4))));
                }
            }
        }
        return cases;
    }

    /**
     * The text PostgreSQL stores for an {@code E'...'} literal, which H2 keeps unescaped: most
     * migrations write a multi-line input as {@code E'[1,3]\n10'}, which reaches H2 as one line.
     */
    static String postgresEscapes(String text) {
        if (text.indexOf('\\') < 0) return text;
        StringBuilder out = new StringBuilder(text.length());
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c != '\\' || i + 1 == text.length()) {
                out.append(c);
                continue;
            }
            char next = text.charAt(++i);
            switch (next) {
                case 'n' -> out.append('\n');
                case 't' -> out.append('\t');
                case 'r' -> out.append('\r');
                default -> out.append(next);
            }
        }
        return out.toString();
    }

    private static List<String> column(String sql) throws SQLException {
        List<String> result = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(URL, "sa", "");
             Statement statement = connection.createStatement();
             ResultSet rows = statement.executeQuery(sql)) {
            while (rows.next()) result.add(rows.getString(1));
        }
        return result;
    }
}
