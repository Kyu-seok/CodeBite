package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Stage 4 of the diagram roadmap: hand-author graph diagrams for the
 * non-grid graph-tagged problems. Mirrors V183's tree pattern (find Example 1's
 * closing fence, insert the directive after it; same Korean marker handling).
 *
 * Directives are deliberately small (≤ 10 nodes) so the circular layout in
 * GraphDiagram.tsx stays readable. Grid-based problems that *also* carry the
 * graphs tag (number-of-islands, surrounded-regions, etc.) are intentionally
 * skipped here — they go to GridDiagram once Stage 4 grids ship.
 */
public class V184__add_graph_diagrams_batch1 extends BaseJavaMigration {

    // Slugs are the *current* canonical names after V134/V148/V151 renames.
    // Edge bodies were drafted from the original LeetCode-style examples;
    // theme-renames don't change the underlying graph structure, so the same
    // directives apply.
    private static final Map<String, String> DIAGRAMS = new LinkedHashMap<>();
    static {
        // Graph clone — directed adjacency from the example.
        DIAGRAMS.put("snapshot-town-map",
                "edges: [[2,3],[1,4],[1,5],[2,5],[3,4]]\ndirected: true");

        // Account merge — undirected. Labels shortened so they fit the 36px
        // node circles; structure (one big cluster + one outlier) is the point.
        DIAGRAMS.put("merge-duplicate-contacts",
                "edges: [[\"Maya\",\"e1\"],[\"Maya\",\"e2\"],[\"Maya\",\"e3\"],[\"Leo\",\"e4\"]]"
                        + "\ndirected: false");

        // Connected components, n=6 — node 5 is isolated, so list it
        // explicitly so the layout shows the empty component too.
        DIAGRAMS.put("count-voice-parties",
                "edges: [[0,1],[2,3],[3,4]]\nnodes: [0,1,2,3,4,5]\ndirected: false");

        // Topological sort — directed prerequisite edges.
        DIAGRAMS.put("order-group-tasks",
                "edges: [[2,0],[1,0]]\ndirected: true");

        // DAG cycle check (this example is acyclic).
        DIAGRAMS.put("verify-task-order",
                "edges: [[1,0],[2,0],[3,1]]\ndirected: true");

        // Weighted-equation solver — string-labeled directed graph.
        // Highlight the chain that resolves the query.
        DIAGRAMS.put("cafe-price-ratios",
                "edges: [[\"milk\",\"bread\"],[\"bread\",\"eggs\"]]"
                        + "\ndirected: true"
                        + "\nhighlight_path: [\"milk\",\"bread\",\"eggs\"]");

        // Reachability — directed adjacency.
        DIAGRAMS.put("open-all-rooms",
                "edges: [[0,2],[0,1],[1,4],[2,3],[3,0],[3,4]]\ndirected: true");

        // Bipartite 2-coloring — undirected. Original had a duplicate (2,3)/
        // (3,2); deduped since direction doesn't matter.
        DIAGRAMS.put("two-shift-baristas",
                "edges: [[0,1],[1,2],[2,3]]\ndirected: false");

        // Tree validation / cycle detection — directed for clarity, so the
        // edges read as parent→child.
        DIAGRAMS.put("graph-valid-tree",
                "edges: [[0,1],[0,2],[1,3],[1,4],[2,5]]\ndirected: true");

        // Word ladder — string nodes; highlight the BFS path.
        DIAGRAMS.put("word-ladder",
                "edges: [[\"pet\",\"pit\"],[\"pit\",\"pot\"]]"
                        + "\ndirected: true"
                        + "\nhighlight_path: [\"pet\",\"pit\",\"pot\"]");

        // Eulerian path — directed flight legs; highlight the chosen route.
        DIAGRAMS.put("dog-street-walk",
                "edges: [[\"ELM\",\"HUB\"],[\"HUB\",\"BIR\"],[\"BIR\",\"ELM\"],[\"HUB\",\"CED\"]]"
                        + "\ndirected: true"
                        + "\nhighlight_path: [\"HUB\",\"BIR\",\"ELM\",\"HUB\",\"CED\"]");

        // Bounded-hop shortest path — strip weights (only structure renders);
        // highlight_path is a node sequence, not edge pairs.
        DIAGRAMS.put("cheapest-courier-route",
                "edges: [[0,1],[1,2],[0,2],[2,3],[3,4],[1,3]]"
                        + "\ndirected: true"
                        + "\nhighlight_path: [0,1,3,4]");

        // Cycle detection in undirected graph — highlight the redundant edge.
        DIAGRAMS.put("redundant-friendship",
                "edges: [[1,2],[2,3],[1,3]]"
                        + "\ndirected: false"
                        + "\nhighlight_path: [1,3]");

        // MST — show the complete candidate graph. The MST itself isn't
        // necessarily a path, so no highlight_path here.
        DIAGRAMS.put("connect-water-bowls",
                "edges: [[0,1],[0,2],[0,3],[1,2],[1,3],[2,3]]\ndirected: false");

        // Dijkstra — strip weights; highlight the shortest path as a node
        // sequence.
        DIAGRAMS.put("guild-chat-relay",
                "edges: [[1,2],[1,3],[3,2],[2,4],[3,4]]"
                        + "\ndirected: true"
                        + "\nhighlight_path: [1,3,2,4]");
    }

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Map.Entry<String, String> e : DIAGRAMS.entrySet()) {
            String diagram = "```diagram-graph\n" + e.getValue() + "\n```";
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
                if (desc.contains("```diagram-graph")) return; // already has one

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
