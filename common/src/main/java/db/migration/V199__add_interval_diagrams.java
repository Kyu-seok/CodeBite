package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * Interval Diagrams: one bar per interval, under the examples of the
 * seven problems whose input is a list of [start, end] pairs, in the English
 * description and the Korean translation, through V183.injectDiagram.
 *
 * - can-attend-bookings: Example 1 highlights the clashing pair [18,20] and
 *   [19,21], the only highlight here (anywhere else it would give the answer
 *   away); Example 2 shows bookings that only touch, which is allowed.
 * - cover-aquarium-zones: Example 1, without the pellets, which are output
 *   and not unique.
 * - drop-conflicting-classes: Example 1 only (one class inside another).
 *   Example 3's [1,5] and [6,10] have a gap rather than touching, so a
 *   Diagram there would not show the touching rule.
 * - merge-reservation-slots: Examples 1 and 2 with the merged output as
 *   `after`; Example 2's [1,3] and [3,8] touch and still merge.
 * - peak-table-demand: Example 1, each visit on its own row, since the
 *   number of packed rows is the answer.
 * - shortest-table-booking: Example 1 with the probes as `points`.
 * - slot-a-meeting: Example 1 with newSlot as `added` and the output as
 *   `after`.
 */
public class V199__add_interval_diagrams extends BaseJavaMigration {

    private record Diagram(String slug, int example, String body) {}

    private static final List<Diagram> DIAGRAMS = List.of(
            new Diagram("can-attend-bookings", 1,
                    "intervals: [[18,20],[19,21],[22,23]]\nhighlight: [0,1]"),
            new Diagram("can-attend-bookings", 2,
                    "intervals: [[18,20],[20,22],[22,23]]"),
            new Diagram("cover-aquarium-zones", 1,
                    "intervals: [[5,11],[3,9],[8,14],[12,18],[20,25]]"),
            new Diagram("drop-conflicting-classes", 1,
                    "intervals: [[10,20],[12,18],[22,30]]"),
            new Diagram("merge-reservation-slots", 1,
                    "intervals: [[2,5],[4,7],[9,11],[14,16]]\nafter: [[2,7],[9,11],[14,16]]"),
            new Diagram("merge-reservation-slots", 2,
                    "intervals: [[1,3],[3,8],[10,12]]\nafter: [[1,8],[10,12]]"),
            new Diagram("peak-table-demand", 1,
                    "intervals: [[60,180],[90,150],[120,240],[200,300]]"),
            new Diagram("shortest-table-booking", 1,
                    "intervals: [[2,5],[4,7],[1,9],[6,10]]\npoints: [3,6,9,11]"),
            new Diagram("slot-a-meeting", 1,
                    "intervals: [[1,4],[7,10]]\nadded: [3,6]\nafter: [[1,6],[7,10]]"));

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Diagram d : DIAGRAMS) {
            String block = "```diagram-intervals\n" + d.body() + "\n```";
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
