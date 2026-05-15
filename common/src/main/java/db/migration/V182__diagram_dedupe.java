package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Defensive cleanup: if a problem description (en) or translation (ko) ended
 * up with more than one `diagram-tree` fenced block, keep only the first.
 *
 * Background: during the V177–V180 debug iterations some local dev DBs
 * gained an extra `diagram-tree` block. V181's REPLACE upgraded all copies
 * in place, leaving doubled rendering. The clean migration state from
 * V137→V181 only ever produces one block per description, but we run this
 * idempotent dedupe so any divergence self-heals on next bootRun.
 *
 * Pure Java rather than SQL because H2 doesn't accept Postgres' `'g'` flag
 * on REGEXP_REPLACE and a portable substring REPLACE can't do "keep only
 * the first occurrence."
 */
public class V182__diagram_dedupe extends BaseJavaMigration {

    @Override
    public void migrate(Context context) throws Exception {
        dedupeColumn(context,
                "SELECT id, description FROM problems WHERE description LIKE '%```diagram-tree%'",
                "UPDATE problems SET description = ? WHERE id = ?");
        dedupeColumn(context,
                "SELECT id, description FROM problem_translations WHERE description LIKE '%```diagram-tree%'",
                "UPDATE problem_translations SET description = ? WHERE id = ?");
    }

    private void dedupeColumn(Context ctx, String selectSql, String updateSql) throws Exception {
        try (Statement s = ctx.getConnection().createStatement();
             ResultSet rs = s.executeQuery(selectSql)) {
            while (rs.next()) {
                long id = rs.getLong(1);
                String desc = rs.getString(2);
                String fixed = keepOnlyFirstDiagramTree(desc);
                if (!fixed.equals(desc)) {
                    try (PreparedStatement ps = ctx.getConnection().prepareStatement(updateSql)) {
                        ps.setString(1, fixed);
                        ps.setLong(2, id);
                        ps.executeUpdate();
                    }
                }
            }
        }
    }

    /**
     * Walk the description, keep the first `diagram-tree` block, drop the rest.
     * Strips up to two trailing newlines after each removed block so the result
     * doesn't accumulate blank lines.
     *
     * Static + no DB deps so unit-testable directly.
     */
    public static String keepOnlyFirstDiagramTree(String desc) {
        if (desc == null) return null;
        final String startMarker = "```diagram-tree";
        final String endMarker = "```";

        int firstStart = desc.indexOf(startMarker);
        if (firstStart < 0) return desc;
        int firstEnd = desc.indexOf(endMarker, firstStart + startMarker.length());
        if (firstEnd < 0) return desc;  // malformed — leave alone
        int firstBlockEnd = firstEnd + endMarker.length();

        StringBuilder out = new StringBuilder(desc.length());
        out.append(desc, 0, firstBlockEnd);

        int i = firstBlockEnd;
        while (true) {
            int nextStart = desc.indexOf(startMarker, i);
            if (nextStart < 0) {
                out.append(desc, i, desc.length());
                break;
            }
            // Keep everything between the kept block (or previous removal) and this duplicate.
            out.append(desc, i, nextStart);
            int nextEnd = desc.indexOf(endMarker, nextStart + startMarker.length());
            if (nextEnd < 0) {
                // malformed trailing block — keep verbatim rather than truncate
                out.append(desc, nextStart, desc.length());
                break;
            }
            i = nextEnd + endMarker.length();
            // Swallow up to two trailing newlines so we don't leave gaping blank lines.
            if (i < desc.length() && desc.charAt(i) == '\n') i++;
            if (i < desc.length() && desc.charAt(i) == '\n') i++;
        }
        return out.toString();
    }
}
