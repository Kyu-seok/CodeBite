package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * Redraws the Diagrams V184, V185 and V186 drafted from the classic LeetCode examples, which no
 * longer matched the examples above them, in the English description and the Korean translation.
 * DiagramsMatchExamplesTest keeps them matching.
 *
 * Four move to Example 2, where the picture says more: spiral-shelf-walk (Example 1 is 2x2),
 * zero-out-rows-cols (Example 1 has no zero), shortest-dungeon-path (Example 1 has no wall) and
 * rising-water-path (Example 1 has no route worth tracing). rotate-pet-cafe-map also gains
 * Example 2: a 4x4 grid has no fixed centre, and two rings turn separately.
 *
 * word-ladder keeps V194's path and gains the two edges it left out (dot-lot and dog-log are one
 * letter apart too). merge-duplicate-contacts shortens its emails to fit the node circles, and shows the second Maya
 * apart from the first, which is that example's point.
 */
public class V203__diagrams_match_their_examples extends BaseJavaMigration {

    /** Replaces oldBody, wherever it sits, with newBody under the example; a null oldBody only adds. */
    private record Redraw(String slug, String kind, int example, String oldBody, String newBody) {}

    private static final List<Redraw> REDRAWS = List.of(
            new Redraw("rotate-pet-cafe-map", "grid", 1,
                    "cells: [[1,2,3],[4,5,6],[7,8,9]]" + "\n"
                            + "after: [[7,4,1],[8,5,2],[9,6,3]]",
                    "cells: [[2,4,6],[8,1,3],[5,7,9]]" + "\n"
                            + "after: [[5,8,2],[7,1,4],[9,3,6]]"),
            new Redraw("spiral-shelf-walk", "grid", 2,
                    "cells: [[1,2,3],[4,5,6],[7,8,9]]" + "\n"
                            + "highlight: [[0,0],[0,1],[0,2],[1,2],[2,2],[2,1],[2,0],[1,0]]",
                    "cells: [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]" + "\n"
                            + "highlight: [[0,0],[0,1],[0,2],[1,2],[2,2],[3,2],[3,1],[3,0],[2,0],[1,0]]"),
            new Redraw("zero-out-rows-cols", "grid", 2,
                    "cells: [[1,1,1],[1,0,1],[1,1,1]]" + "\n"
                            + "after: [[1,0,1],[0,0,0],[1,0,1]]",
                    "cells: [[4,6,8],[2,0,5],[7,9,3]]" + "\n"
                            + "after: [[4,0,8],[0,0,0],[7,0,3]]"),
            new Redraw("count-desk-clusters", "grid", 1,
                    "cells: [[\"1\",\"1\",\"0\",\"0\"],[\"1\",\"1\",\"0\",\"0\"],[\"0\",\"0\",\"1\",\"0\"],[\"0\",\"0\",\"0\",\"1\"]]" + "\n"
                            + "highlight: [[2,2],[3,3]]",
                    "cells: [[\"0\",\"1\",\"1\",\"0\",\"0\",\"1\"],[\"1\",\"1\",\"0\",\"0\",\"0\",\"1\"],[\"0\",\"0\",\"0\",\"1\",\"0\",\"0\"],[\"1\",\"0\",\"0\",\"1\",\"1\",\"0\"],[\"1\",\"0\",\"0\",\"0\",\"0\",\"1\"]]" + "\n"
                            + "highlight: [[0,1],[0,2],[1,0],[1,1]]"),
            new Redraw("capture-enclosed-tiles", "grid", 1,
                    "cells: [[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"O\",\"O\",\"X\"],[\"X\",\"X\",\"O\",\"X\"],[\"X\",\"O\",\"X\",\"X\"]]" + "\n"
                            + "after: [[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"O\",\"X\",\"X\"]]",
                    "cells: [[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"O\",\"X\",\"X\"],[\"X\",\"X\",\"O\",\"X\"],[\"X\",\"X\",\"X\",\"O\"]]" + "\n"
                            + "after: [[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"X\",\"X\",\"X\"],[\"X\",\"X\",\"X\",\"O\"]]"),
            new Redraw("dual-waterbowl-flow", "grid", 1,
                    "cells: [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]" + "\n"
                            + "highlight: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]",
                    "cells: [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]" + "\n"
                            + "highlight: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]"),
            new Redraw("rotting-donuts", "grid", 1,
                    "cells: [[2,1,1],[1,1,0],[0,1,1]]" + "\n"
                            + "highlight: [[0,0]]",
                    "cells: [[2,1,1],[1,0,1],[1,1,1]]" + "\n"
                            + "highlight: [[0,0]]"),
            new Redraw("shortest-dungeon-path", "grid", 2,
                    "cells: [[0,0,0],[1,1,0],[1,1,0]]" + "\n"
                            + "highlight: [[0,0],[0,1],[0,2],[1,2],[2,2]]",
                    "cells: [[0,1,0],[0,0,0],[1,0,0]]" + "\n"
                            + "highlight: [[0,0],[1,1],[2,2]]"),
            new Redraw("count-dungeon-paths", "grid", 1,
                    "cells: [[0,0,0],[0,0,0],[0,0,0]]",
                    "cells: [[\".\",\".\",\".\",\".\",\".\"],[\".\",\".\",\".\",\".\",\".\"],[\".\",\".\",\".\",\".\",\".\"],[\".\",\".\",\".\",\".\",\".\"]]" + "\n"
                            + "blank: \".\""),
            new Redraw("rising-water-path", "grid", 2,
                    "cells: [[0,2],[1,3]]" + "\n"
                            + "highlight: [[0,0],[1,0],[1,1]]",
                    "cells: [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]" + "\n"
                            + "highlight: [[0,0],[1,0],[2,0],[3,0],[3,1],[3,2],[3,3]]"),
            new Redraw("snapshot-town-map", "graph", 1,
                    "edges: [[2,3],[1,4],[1,5],[2,5],[3,4]]" + "\n"
                            + "directed: true",
                    "edges: [[1,2],[1,3],[2,4],[3,5],[4,5]]" + "\n"
                            + "directed: false"),
            new Redraw("merge-duplicate-contacts", "graph", 1,
                    "edges: [[\"Maya\",\"e1\"],[\"Maya\",\"e2\"],[\"Maya\",\"e3\"],[\"Leo\",\"e4\"]]" + "\n"
                            + "directed: false",
                    "edges: [[\"dp\",\"lens\"],[\"lens\",\"cam\"]]" + "\n"
                            + "nodes: [\"dp\",\"lens\",\"cam\",\"leo\",\"solo\"]" + "\n"
                            + "directed: false"),
            new Redraw("open-all-rooms", "graph", 1,
                    "edges: [[0,2],[0,1],[1,4],[2,3],[3,0],[3,4]]" + "\n"
                            + "directed: true",
                    "edges: [[0,2],[0,1],[1,4],[2,3],[4,3],[4,0]]" + "\n"
                            + "directed: true"),
            new Redraw("graph-valid-tree", "graph", 1,
                    "edges: [[0,1],[0,2],[1,3],[1,4],[2,5]]" + "\n"
                            + "directed: true",
                    "edges: [[0,1],[0,2],[0,3],[1,4]]" + "\n"
                            + "directed: false"),
            new Redraw("word-ladder", "graph", 1,
                    "edges: [[\"hit\",\"hot\"],[\"hot\",\"dot\"],[\"hot\",\"lot\"],[\"dot\",\"dog\"],[\"lot\",\"log\"],[\"dog\",\"cog\"],[\"log\",\"cog\"]]" + "\n"
                            + "directed: false" + "\n"
                            + "highlight_path: [\"hit\",\"hot\",\"dot\",\"dog\",\"cog\"]",
                    "edges: [[\"hit\",\"hot\"],[\"hot\",\"dot\"],[\"hot\",\"lot\"],[\"dot\",\"lot\"],[\"dot\",\"dog\"],[\"lot\",\"log\"],[\"dog\",\"log\"],[\"dog\",\"cog\"],[\"log\",\"cog\"]]" + "\n"
                            + "directed: false" + "\n"
                            + "highlight_path: [\"hit\",\"hot\",\"dot\",\"dog\",\"cog\"]"),
            new Redraw("redundant-friendship", "graph", 1,
                    "edges: [[1,2],[2,3],[1,3]]" + "\n"
                            + "directed: false" + "\n"
                            + "highlight_path: [1,3]",
                    "edges: [[1,2],[1,3],[2,3]]" + "\n"
                            + "directed: false" + "\n"
                            + "highlight_path: [2,3]"),
            new Redraw("detect-portal-loop", "linked-list", 1,
                    "nodes: [3,2,0,4]" + "\n"
                            + "cycle_to: 1",
                    "nodes: [8,5,2,6,9]" + "\n"
                            + "cycle_to: 2"),
            new Redraw("flip-chunks-of-k", "linked-list", 1,
                    "nodes: [1,2,3,4,5]" + "\n"
                            + "highlight: [0,1,2]" + "\n"
                            + "after: [3,2,1,4,5]",
                    "nodes: [10,20,30,40,50,60,70]" + "\n"
                            + "highlight: [0,1,2]" + "\n"
                            + "after: [30,20,10,60,50,40,70]"),
            new Redraw("interleave-clip-chain", "linked-list", 1,
                    "nodes: [1,2,3,4,5]" + "\n"
                            + "after: [1,5,2,4,3]",
                    "nodes: [10,20,30,40,50,60]" + "\n"
                            + "after: [10,60,20,50,30,40]"),
            new Redraw("swap-print-pairs", "linked-list", 1,
                    "nodes: [1,2,3,4]" + "\n"
                            + "after: [2,1,4,3]",
                    "nodes: [11,22,33,44]" + "\n"
                            + "after: [22,11,44,33]"),
            new Redraw("rotate-pet-cafe-map", "grid", 2,
                    null,
                    "cells: [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]" + "\n"
                            + "after: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]"));

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Redraw r : REDRAWS) {
            redraw(ctx, r, "**Example " + r.example() + ":**", false);
            redraw(ctx, r, "**예시 " + r.example() + ":**", true);
        }
    }

    private void redraw(Context ctx, Redraw r, String marker, boolean ko) throws Exception {
        String selectSql = ko
                ? "SELECT pt.id, pt.description FROM problem_translations pt "
                        + "JOIN problems p ON pt.problem_id = p.id "
                        + "WHERE p.slug = ? AND pt.locale = 'ko'"
                : "SELECT id, description FROM problems WHERE slug = ?";
        String updateSql = ko
                ? "UPDATE problem_translations SET description = ? WHERE id = ?"
                : "UPDATE problems SET description = ? WHERE id = ?";
        String where = " in the " + (ko ? "ko" : "en") + " description of " + r.slug();

        try (PreparedStatement ps = ctx.getConnection().prepareStatement(selectSql)) {
            ps.setString(1, r.slug());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new IllegalStateException("No description" + where);
                long id = rs.getLong(1);
                String desc = rs.getString(2);

                if (r.oldBody() != null) {
                    String oldBlock = "\n\n" + block(r.kind(), r.oldBody());
                    if (!desc.contains(oldBlock)) {
                        throw new IllegalStateException("Expected Diagram not found" + where + ":" + oldBlock);
                    }
                    desc = desc.replace(oldBlock, "");
                }
                String updated = V183__add_tree_diagrams_batch1.injectDiagram(
                        desc, marker, block(r.kind(), r.newBody()));
                if (updated.equals(desc)) throw new IllegalStateException(marker + " not found" + where);

                try (PreparedStatement ups = ctx.getConnection().prepareStatement(updateSql)) {
                    ups.setString(1, updated);
                    ups.setLong(2, id);
                    ups.executeUpdate();
                }
            }
        }
    }

    private static String block(String kind, String body) {
        return "```diagram-" + kind + "\n" + body + "\n```";
    }
}
