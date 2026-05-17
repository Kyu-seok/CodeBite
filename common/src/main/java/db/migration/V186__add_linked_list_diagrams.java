package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Stage 4 follow-up: hand-author linked-list diagrams for the *complex*
 * pointer-arrangement problems where text notation (1→2→3) is genuinely
 * insufficient — cycles, reversal, in-place restructuring.
 *
 * Skipped:
 * - merge-k-lists, merge-sorted-lists: multiple input lists; the current
 *   LinkedListDiagram renders a single chain.
 * - copy-random-list: needs a second arrow per node (the random pointer),
 *   not yet in the directive spec.
 * - add-two-numbers: two input lists; rendering one would mislead.
 * - remove-from-end: text suffices.
 *
 * Same Example-1 injection mechanic as V183/V184/V185.
 */
public class V186__add_linked_list_diagrams extends BaseJavaMigration {

    // Slugs are the *current* canonical names after V122/V134/V151 renames.
    // The underlying linked-list problem is the same; only the theme changed.
    private static final Map<String, String> DIAGRAMS = new LinkedHashMap<>();
    static {
        // Reverse Linked List — classic before/after pair.
        DIAGRAMS.put("reverse-linked-list",
                "nodes: [1,2,3,4,5]"
                        + "\nafter: [5,4,3,2,1]");

        // Linked List Cycle — the canonical opacity of text-only notation.
        // The tail's arrow loops back to index 1.
        DIAGRAMS.put("detect-portal-loop",
                "nodes: [3,2,0,4]"
                        + "\ncycle_to: 1");

        // Reverse Nodes in k-Group (k=3) — highlight the window that's about
        // to flip, then show the result on the after side.
        DIAGRAMS.put("flip-chunks-of-k",
                "nodes: [1,2,3,4,5]"
                        + "\nhighlight: [0,1,2]"
                        + "\nafter: [3,2,1,4,5]");

        // Reorder List — interleave from both ends; visualizing the result
        // makes the L0 → Ln → L1 → Ln-1 pattern obvious.
        DIAGRAMS.put("interleave-clip-chain",
                "nodes: [1,2,3,4,5]"
                        + "\nafter: [1,5,2,4,3]");

        // Swap Pairs — adjacent swap; before/after shows the local nature
        // of the transformation.
        DIAGRAMS.put("swap-print-pairs",
                "nodes: [1,2,3,4]"
                        + "\nafter: [2,1,4,3]");
    }

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Map.Entry<String, String> e : DIAGRAMS.entrySet()) {
            String diagram = "```diagram-linked-list\n" + e.getValue() + "\n```";
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
                if (desc.contains("```diagram-linked-list")) return; // already has one

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
