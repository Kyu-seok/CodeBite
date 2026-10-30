package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * The Stage 5 bulk pass (#109): Diagrams for the grid problems V185 left
 * without one, and N-Queens' output boards. Every tree and graph problem
 * already has its Diagram from V183/V184. Each goes under Example 1, in
 * the English description and the Korean translation, through
 * V183.injectDiagram.
 *
 * - find-menu-calorie, find-menu-price: highlight where the target sits.
 * - biggest-clear-floor: highlight the 3×3 clear square.
 * - longest-level-up-path: highlight the path the explanation names.
 * - min-wait-drive: no highlight, since two routes tie at 9 and the
 *   explanation fits either.
 * - n-queens: the input is only n = 4, so the Diagrams are the two output
 *   boards, queens on empty squares.
 */
public class V198__add_grid_diagrams_batch2 extends BaseJavaMigration {

    /** One example's Diagrams; several bodies draw several grids, in order. */
    private record Diagram(String slug, int example, String... bodies) {}

    private static final List<Diagram> DIAGRAMS = List.of(
            new Diagram("find-menu-calorie", 1,
                    "cells: [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]]"
                            + "\nhighlight: [[3,2]]"),
            new Diagram("find-menu-price", 1,
                    "cells: [[2,4,8,13],[15,19,22,28],[31,37,44,52]]"
                            + "\nhighlight: [[1,2]]"),
            new Diagram("biggest-clear-floor", 1,
                    "cells: [[\"1\",\"1\",\"0\",\"1\"],[\"1\",\"1\",\"1\",\"1\"],"
                            + "[\"0\",\"1\",\"1\",\"1\"],[\"1\",\"1\",\"1\",\"1\"]]"
                            + "\nhighlight: [[1,1],[1,2],[1,3],[2,1],[2,2],[2,3],[3,1],[3,2],[3,3]]"),
            new Diagram("longest-level-up-path", 1,
                    "cells: [[2,5,8],[3,4,7],[1,6,9]]"
                            + "\nhighlight: [[2,0],[1,0],[1,1],[1,2],[2,2]]"),
            new Diagram("min-wait-drive", 1,
                    "cells: [[2,1,4],[5,3,2],[1,2,1]]"),
            new Diagram("n-queens", 1,
                    "cells: [[\".\",\"Q\",\".\",\".\"],[\".\",\".\",\".\",\"Q\"],"
                            + "[\"Q\",\".\",\".\",\".\"],[\".\",\".\",\"Q\",\".\"]]"
                            + "\nblank: \".\"",
                    "cells: [[\".\",\".\",\"Q\",\".\"],[\"Q\",\".\",\".\",\".\"],"
                            + "[\".\",\".\",\".\",\"Q\"],[\".\",\"Q\",\".\",\".\"]]"
                            + "\nblank: \".\""));

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Diagram d : DIAGRAMS) {
            StringBuilder blocks = new StringBuilder();
            for (String body : d.bodies()) {
                if (blocks.length() > 0) blocks.append("\n\n");
                blocks.append("```diagram-grid\n").append(body).append("\n```");
            }
            insertAfterExample(ctx, d.slug(), "**Example " + d.example() + ":**", blocks.toString(), false);
            insertAfterExample(ctx, d.slug(), "**예시 " + d.example() + ":**", blocks.toString(), true);
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
