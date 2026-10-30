package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * Diagrams for both Valid Sudoku examples, in the English description and
 * the Korean translation. Each goes under its example's code block, through
 * V183.injectDiagram; the one-line `Input:` stays as the exact input.
 *
 * The board uses the grid keys added with it: `boxes: 3` for the 3×3
 * sub-boxes and `blank: "."` for empty cells. Example 2 differs from
 * Example 1 only in its top-left cell, so it highlights the two 8s that
 * clash in the first column.
 */
public class V197__add_valid_sudoku_diagrams extends BaseJavaMigration {

    private record Diagram(String slug, int example, String body) {}

    private static final String ROWS_2_TO_9 =
            "[\"6\",\".\",\".\",\"1\",\"9\",\"5\",\".\",\".\",\".\"],"
                    + "[\".\",\"9\",\"8\",\".\",\".\",\".\",\".\",\"6\",\".\"],"
                    + "[\"8\",\".\",\".\",\".\",\"6\",\".\",\".\",\".\",\"3\"],"
                    + "[\"4\",\".\",\".\",\"8\",\".\",\"3\",\".\",\".\",\"1\"],"
                    + "[\"7\",\".\",\".\",\".\",\"2\",\".\",\".\",\".\",\"6\"],"
                    + "[\".\",\"6\",\".\",\".\",\".\",\".\",\"2\",\"8\",\".\"],"
                    + "[\".\",\".\",\".\",\"4\",\"1\",\"9\",\".\",\".\",\"5\"],"
                    + "[\".\",\".\",\".\",\".\",\"8\",\".\",\".\",\"7\",\"9\"]";

    private static final List<Diagram> DIAGRAMS = List.of(
            new Diagram("valid-sudoku", 1,
                    "cells: [[\"5\",\"3\",\".\",\".\",\"7\",\".\",\".\",\".\",\".\"]," + ROWS_2_TO_9 + "]"
                            + "\nboxes: 3"
                            + "\nblank: \".\""),
            new Diagram("valid-sudoku", 2,
                    "cells: [[\"8\",\"3\",\".\",\".\",\"7\",\".\",\".\",\".\",\".\"]," + ROWS_2_TO_9 + "]"
                            + "\nboxes: 3"
                            + "\nblank: \".\""
                            + "\nhighlight: [[0,0],[3,0]]"));

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Diagram d : DIAGRAMS) {
            String block = "```diagram-grid\n" + d.body() + "\n```";
            insertAfterExample(ctx, d.slug(), "**Example " + d.example() + ":**", block, false);
            insertAfterExample(ctx, d.slug(), "**예시 " + d.example() + ":**", block, true);
        }
    }

    private void insertAfterExample(Context ctx, String slug, String marker, String block, boolean ko)
            throws Exception {
        String selectSql = ko
                ? "SELECT pt.id, pt.description FROM problem_translations pt "
                        + "JOIN problems p ON pt.problem_id = p.id "
                        + "WHERE p.slug = ? AND pt.locale = 'ko'"
                : "SELECT id, description FROM problems WHERE slug = ?";
        String updateSql = ko
                ? "UPDATE problem_translations SET description = ? WHERE id = ?"
                : "UPDATE problems SET description = ? WHERE id = ?";

        try (PreparedStatement ps = ctx.getConnection().prepareStatement(selectSql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalStateException("No " + (ko ? "ko" : "en") + " description for " + slug);
                }
                long id = rs.getLong(1);
                String desc = rs.getString(2);
                String updated = V183__add_tree_diagrams_batch1.injectDiagram(desc, marker, block);
                if (updated.equals(desc)) {
                    throw new IllegalStateException(marker + " not found in the " + (ko ? "ko" : "en")
                            + " description of " + slug);
                }
                try (PreparedStatement ups = ctx.getConnection().prepareStatement(updateSql)) {
                    ups.setString(1, updated);
                    ups.setLong(2, id);
                    ups.executeUpdate();
                }
            }
        }
    }
}
