package com.codebite.problem;

import org.junit.jupiter.api.Test;

import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Cases are graded in order_index order, and a Failing Case is named by its position, so no two
 * cases of a problem may share one: a third sample added at 3 on top of the first hidden case
 * left the two in no fixed order (V201).
 */
class TestCasePositionsTest {

    @Test
    void noTwoCasesOfAProblemShareAPosition() throws SQLException {
        List<String> clashes = new MigratedDatabase("test-case-positions").migrate().strings("""
                SELECT p.slug || ' order_index ' || t.order_index
                FROM test_cases t JOIN problems p ON p.id = t.problem_id
                GROUP BY p.slug, t.order_index HAVING COUNT(*) > 1
                ORDER BY 1""");
        assertTrue(clashes.isEmpty(), "Positions held by more than one Test Case: " + clashes);
    }
}
