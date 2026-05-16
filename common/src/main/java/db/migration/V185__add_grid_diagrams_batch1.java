package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Stage 4 of the diagram roadmap, grid half: hand-author 2D-grid diagrams
 * for matrix / island / grid-DP / grid-backtracking problems.
 *
 * Same Example-1 injection mechanic as V183/V184 — uses
 * V183.injectDiagram. Slugs are the current canonical names after
 * V134/V148/V151 renames; the underlying grid structure of the LC-style
 * examples doesn't change with theme renames, so the directives carry over.
 *
 * Where the problem transforms its input (rotate, set-zeros), the directive
 * uses `after:` to render the input → output pair. For counting / search /
 * pathfinding problems the diagram shows the input grid only (with optional
 * highlighted cells when there's an unambiguous "answer" to point at).
 */
public class V185__add_grid_diagrams_batch1 extends BaseJavaMigration {

    private static final Map<String, String> DIAGRAMS = new LinkedHashMap<>();
    static {
        // Rotate matrix 90° clockwise — classic before/after pair.
        DIAGRAMS.put("rotate-pet-cafe-map",
                "cells: [[1,2,3],[4,5,6],[7,8,9]]"
                        + "\nafter: [[7,4,1],[8,5,2],[9,6,3]]");

        // Spiral order — highlight the first ring so the traversal direction
        // reads at a glance. Output is a list (not a grid), so no `after`.
        DIAGRAMS.put("spiral-shelf-walk",
                "cells: [[1,2,3],[4,5,6],[7,8,9]]"
                        + "\nhighlight: [[0,0],[0,1],[0,2],[1,2],[2,2],[2,1],[2,0],[1,0]]");

        // Set zeros — every row and col touching a 0 gets zeroed.
        DIAGRAMS.put("zero-out-rows-cols",
                "cells: [[1,1,1],[1,0,1],[1,1,1]]"
                        + "\nafter: [[1,0,1],[0,0,0],[1,0,1]]");

        // Number-of-islands — example with two islands; highlight the second.
        DIAGRAMS.put("count-desk-clusters",
                "cells: [[\"1\",\"1\",\"0\",\"0\"],"
                        + "[\"1\",\"1\",\"0\",\"0\"],"
                        + "[\"0\",\"0\",\"1\",\"0\"],"
                        + "[\"0\",\"0\",\"0\",\"1\"]]"
                        + "\nhighlight: [[2,2],[3,3]]");

        // Surrounded regions — Os on the border survive; interior Os flip to X.
        DIAGRAMS.put("capture-enclosed-tiles",
                "cells: [[\"X\",\"X\",\"X\",\"X\"],"
                        + "[\"X\",\"O\",\"O\",\"X\"],"
                        + "[\"X\",\"X\",\"O\",\"X\"],"
                        + "[\"X\",\"O\",\"X\",\"X\"]]"
                        + "\nafter: [[\"X\",\"X\",\"X\",\"X\"],"
                        + "[\"X\",\"X\",\"X\",\"X\"],"
                        + "[\"X\",\"X\",\"X\",\"X\"],"
                        + "[\"X\",\"O\",\"X\",\"X\"]]");

        // Walls and gates — INF rooms get filled with shortest distance to a
        // gate (0). -1 = wall. Use string "INF" so values still fit cells.
        DIAGRAMS.put("walls-and-gates",
                "cells: [[\"INF\",-1,0,\"INF\"],"
                        + "[\"INF\",\"INF\",\"INF\",-1],"
                        + "[\"INF\",-1,\"INF\",-1],"
                        + "[0,-1,\"INF\",\"INF\"]]"
                        + "\nafter: [[3,-1,0,1],"
                        + "[2,2,1,-1],"
                        + "[1,-1,2,-1],"
                        + "[0,-1,3,4]]");

        // Pacific-Atlantic — heightmap; result is the cells that drain to
        // both oceans (highlighted).
        DIAGRAMS.put("dual-waterbowl-flow",
                "cells: [[1,2,2,3,5],"
                        + "[3,2,3,4,4],"
                        + "[2,4,5,3,1],"
                        + "[6,7,1,4,5],"
                        + "[5,1,1,2,4]]"
                        + "\nhighlight: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]");

        // Rotting-oranges — multi-source BFS from any 2; each minute the
        // rot spreads to adjacent 1s.
        DIAGRAMS.put("rotting-donuts",
                "cells: [[2,1,1],[1,1,0],[0,1,1]]"
                        + "\nhighlight: [[0,0]]");

        // Shortest path in binary grid — 1=blocked, 0=passable. Highlight a
        // valid shortest path (length 4) from top-left to bottom-right.
        DIAGRAMS.put("shortest-dungeon-path",
                "cells: [[0,0,0],[1,1,0],[1,1,0]]"
                        + "\nhighlight: [[0,0],[0,1],[0,2],[1,2],[2,2]]");

        // Unique paths — empty 3×3 grid; the diagram just shows the shape.
        // Highlighting one path would mislead (there are many).
        DIAGRAMS.put("count-dungeon-paths",
                "cells: [[0,0,0],[0,0,0],[0,0,0]]");

        // Swim in rising water — heightmap; highlight a viable low-elevation
        // path from corner to corner.
        DIAGRAMS.put("rising-water-path",
                "cells: [[0,2],[1,3]]"
                        + "\nhighlight: [[0,0],[1,0],[1,1]]");

        // Word search — highlight the path spelling \"ABCCED\".
        DIAGRAMS.put("word-search",
                "cells: [[\"A\",\"B\",\"C\",\"E\"],"
                        + "[\"S\",\"F\",\"C\",\"S\"],"
                        + "[\"A\",\"D\",\"E\",\"E\"]]"
                        + "\nhighlight: [[0,0],[0,1],[0,2],[1,2],[2,2],[2,1]]");

        // Word search II — same shape but smaller; highlight \"oath\".
        DIAGRAMS.put("word-search-ii",
                "cells: [[\"o\",\"a\",\"a\",\"n\"],"
                        + "[\"e\",\"t\",\"a\",\"e\"],"
                        + "[\"i\",\"h\",\"k\",\"r\"],"
                        + "[\"i\",\"f\",\"l\",\"v\"]]"
                        + "\nhighlight: [[0,0],[1,1],[2,1],[0,1]]");
    }

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Map.Entry<String, String> e : DIAGRAMS.entrySet()) {
            String diagram = "```diagram-grid\n" + e.getValue() + "\n```";
            insertAfterExample1(ctx, e.getKey(), diagram, /*ko*/ false);
            insertAfterExample1(ctx, e.getKey(), diagram, /*ko*/ true);
        }
    }

    private void insertAfterExample1(Context ctx, String slug, String diagram, boolean ko)
            throws Exception {
        String selectSql = ko
                ? "SELECT pt.id, pt.description FROM problem_translations pt "
                        + "JOIN problems p ON pt.problem_id = p.id "
                        + "WHERE p.slug = ? AND pt.locale = 'ko'"
                : "SELECT id, description FROM problems WHERE slug = ?";
        String updateSql = ko
                ? "UPDATE problem_translations SET description = ? WHERE id = ?"
                : "UPDATE problems SET description = ? WHERE id = ?";
        String example1Marker = ko ? "**예시 1:**" : "**Example 1:**";

        try (PreparedStatement ps = ctx.getConnection().prepareStatement(selectSql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return;
                long id = rs.getLong(1);
                String desc = rs.getString(2);
                if (desc == null || desc.isEmpty()) return;
                if (desc.contains("```diagram-grid")) return; // already has one

                String updated = V183__add_tree_diagrams_batch1.injectDiagram(
                        desc, example1Marker, diagram);
                if (updated.equals(desc)) return; // anchor not found

                try (PreparedStatement ups = ctx.getConnection().prepareStatement(updateSql)) {
                    ups.setString(1, updated);
                    ups.setLong(2, id);
                    ups.executeUpdate();
                }
            }
        }
    }
}
