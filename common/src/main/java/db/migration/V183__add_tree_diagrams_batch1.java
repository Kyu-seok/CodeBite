package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Stage 2 of the diagram roadmap: hand-author tree diagrams for the
 * remaining tree-tagged problems (mirror-menu-tree shipped as Stage 1).
 *
 * Java migration rather than SQL because the insertion logic is the same
 * for every problem (find Example 1's closing fence, insert the directive
 * after it) — just the directive body varies. Same logic also handles
 * Korean translations whose Example 1 marker is "**예시 1:**" rather than
 * "**Example 1:**".
 */
public class V183__add_tree_diagrams_batch1 extends BaseJavaMigration {

    /**
     * slug → directive body (without the surrounding ```diagram-tree fences).
     * Multi-line bodies use \n.
     *
     * Selection criteria (per docs/PROBLEM_DIAGRAMS_ROADMAP.md):
     * - Skip trie-only problems (username-trie, wildcard-lexicon).
     * - Skip word-search-ii (grid problem despite the trie tag).
     * - Use `after` only when the output is a structural transformation;
     *   for scalar/list outputs, just visualize the input.
     */
    private static final Map<String, String> DIAGRAMS = new LinkedHashMap<>();
    static {
        // Output is groupings of values, not a transformed tree.
        DIAGRAMS.put("binary-tree-level-order",
                "nodes: [3, 9, 20, null, null, 15, 7]");

        // Scalar output (depth).
        DIAGRAMS.put("deepest-skill-chain",
                "nodes: [8, 5, 12, null, null, 9, 17]");

        // Two trees (p, q) — render side-by-side; the arrow reads as "same as?".
        DIAGRAMS.put("same-skill-trees",
                "nodes: [8, 4, 12]\nafter: [8, 4, 12]");

        // Two trees (root, subRoot) — same side-by-side treatment.
        DIAGRAMS.put("find-submap",
                "nodes: [9, 6, 7, 2, 4]\nafter: [6, 2, 4]");

        // Bool output, but the BST property is what the diagram demonstrates.
        DIAGRAMS.put("valid-score-bst",
                "nodes: [50, 30, 70, 20, 40, 60, 80]");

        // Highlight the two query nodes (p=2 at idx 1, q=8 at idx 2).
        DIAGRAMS.put("lca-bst",
                "nodes: [6, 2, 8, 0, 4, 7, 9, null, null, 3, 5]\nhighlight: [1, 2]");

        // Scalar output (the kth value).
        DIAGRAMS.put("nth-lowest-score",
                "nodes: [8, 4, 12, 2, 6, 10, 14]");

        // Show the constructed tree (the output) rather than the two input arrays.
        DIAGRAMS.put("rebuild-boss-tree",
                "nodes: [10, 5, 20, 3, 7, 15]");

        // Highlight the rightmost node at each level (idx 0, 2, 6).
        DIAGRAMS.put("right-side-skill-view",
                "nodes: [7, 8, 9, null, 6, null, 3]\nhighlight: [0, 2, 6]");

        // Scalar output (longest path length).
        DIAGRAMS.put("longest-folder-path",
                "nodes: [7, 3, 8, 1, 4, null, 9]");

        // Scalar output (best path sum).
        DIAGRAMS.put("best-skill-tree-path",
                "nodes: [4, 5, 6]");

        // Highlight the two query nodes (p=5 at idx 1, q=1 at idx 2).
        DIAGRAMS.put("lca-binary-tree",
                "nodes: [3, 5, 1, 6, 2, 0, 8, null, null, 7, 4]\nhighlight: [1, 2]");

        // Round-trip — input == output, so single tree.
        DIAGRAMS.put("binary-tree-codec",
                "nodes: [1, 2, 3, null, null, 4, 5]");

        // Scalar output (count of "good" nodes).
        DIAGRAMS.put("count-top-heroes",
                "nodes: [4, 2, 6, 5, 1, null, 7]");

        // Bool output; balance is a structural property best seen visually.
        DIAGRAMS.put("balanced-hamster-tree",
                "nodes: [5, 2, 8, 1, null, null, 11]");

        // Output is groupings; show the input tree.
        DIAGRAMS.put("zigzag-yearbook-order",
                "nodes: [5, 3, 7, 2, 9, 6, 8]");

        // Output is path lists; show the input tree.
        DIAGRAMS.put("list-skill-build-paths",
                "nodes: [10, 6, 9, 3, null, 4, 5, null, null, 8, 2]");

        // Output is next-pointer wiring (hard to render); show the input tree.
        DIAGRAMS.put("populating-next-pointers",
                "nodes: [1, 2, 3, 4, 5, 6, 7]");

        // Scalar output (sum of root-to-leaf numbers).
        DIAGRAMS.put("sum-root-to-leaf",
                "nodes: [1, 2, 3]");

        // Output is a right-leaning chain (visually awkward); just show input.
        DIAGRAMS.put("flatten-agenda-tree",
                "nodes: [7, 3, 9, 1, 4, null, 12]");
    }

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Map.Entry<String, String> e : DIAGRAMS.entrySet()) {
            String diagram = "```diagram-tree\n" + e.getValue() + "\n```";
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
                if (desc.contains("```diagram-tree")) return; // already has one

                String updated = injectDiagram(desc, example1Marker, diagram);
                if (updated.equals(desc)) return; // anchor not found

                try (PreparedStatement ups = ctx.getConnection().prepareStatement(updateSql)) {
                    ups.setString(1, updated);
                    ups.setLong(2, id);
                    ups.executeUpdate();
                }
            }
        }
    }

    /**
     * Find Example 1's opening ``` fence, then its closing ``` fence, and
     * insert the diagram block on a new paragraph after the close.
     *
     * Static + no DB deps so unit-testable.
     */
    public static String injectDiagram(String desc, String example1Marker, String diagram) {
        int markerPos = desc.indexOf(example1Marker);
        if (markerPos < 0) return desc;
        int openFence = desc.indexOf("```", markerPos);
        if (openFence < 0) return desc;
        int closeFence = desc.indexOf("```", openFence + 3);
        if (closeFence < 0) return desc;
        int insertAt = closeFence + 3;
        return desc.substring(0, insertAt) + "\n\n" + diagram + desc.substring(insertAt);
    }
}
