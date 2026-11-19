package db.migration;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * Every problem that takes or returns a tree as a list says how a Level-Order Array is written
 * (GLOSSARY.md, #351), in one sentence the same on every page. A problem that already said it in
 * its own words has that line replaced; the others get the sentence as the prose's last paragraph,
 * before Example 1 (populating-next-pointers, whose output has a format of its own, says "the
 * input tree"). It fails when an old line or the Example 1 marker isn't there exactly once,
 * so a statement edited since can't silently go without it.
 *
 * Also the helpers V591 and V592 use to rewrite the English description and the Korean
 * translation together.
 */
public class V590__explain_level_order_arrays extends BaseJavaMigration {

    public static final String EN = "Trees are written level by level, left to right, with `null` for a "
            + "missing child (trailing `null`s left out).";
    public static final String KO = "트리는 위층부터 왼쪽에서 오른쪽으로 적으며, 없는 자식은 `null`로 적습니다"
            + "(끝에 남는 `null`은 생략합니다).";

    private static final List<String> INSERTED = List.of(
            "balanced-hamster-tree", "best-skill-tree-path", "binary-tree-level-order", "count-top-heroes",
            "deepest-skill-chain", "find-submap", "flatten-agenda-tree", "lca-binary-tree", "lca-bst",
            "list-skill-build-paths", "longest-folder-path", "mirror-menu-tree", "nth-lowest-score",
            "right-side-skill-view", "same-skill-trees", "sum-root-to-leaf",
            "valid-score-bst", "zigzag-yearbook-order");

    @Override
    public void migrate(Context ctx) throws Exception {
        Connection db = ctx.getConnection();
        for (String slug : INSERTED) {
            rewrite(db, slug, "en", insertBeforeExample1(read(db, slug, "en"), "**Example 1:**", EN, slug));
            rewrite(db, slug, "ko", insertBeforeExample1(read(db, slug, "ko"), "**예시 1:**", KO, slug));
        }
        // Its output is its own `#` format, explained just above, so the sentence names the input.
        rewrite(db, "populating-next-pointers", "en", insertBeforeExample1(read(db, "populating-next-pointers", "en"),
                "**Example 1:**", "The input tree is written" + EN.substring("Trees are written".length()),
                "populating-next-pointers"));
        rewrite(db, "populating-next-pointers", "ko", insertBeforeExample1(read(db, "populating-next-pointers", "ko"),
                "**예시 1:**", "입력 " + KO, "populating-next-pointers"));
        replace(db, new Replacement("rebuild-tree-from-traversals",
                "The output writes the tree level by level, left to right, with `null` for a missing child "
                        + "(trailing `null`s left out).", EN,
                "출력은 트리를 위층부터 왼쪽에서 오른쪽으로 적으며, 없는 자식은 `null`로 적습니다"
                        + "(끝에 남는 `null`은 생략합니다).", KO));
        replace(db, new Replacement("binary-tree-codec",
                "The examples show trees in level order, with `null` for a missing child.", EN,
                "예시의 트리는 레벨 순서로 적고, 없는 자식은 `null`로 표시합니다.", KO));
    }

    /** One problem's line, replaced in both languages. */
    public record Replacement(String slug, String enOld, String enNew, String koOld, String koNew) {}

    public static void replace(Connection db, Replacement r) throws Exception {
        rewrite(db, r.slug(), "en", replaceOnce(read(db, r.slug(), "en"), r.enOld(), r.enNew(), r.slug()));
        rewrite(db, r.slug(), "ko", replaceOnce(read(db, r.slug(), "ko"), r.koOld(), r.koNew(), r.slug()));
    }

    /** {@code text} with its one {@code old} replaced; fails when there is none or several. */
    public static String replaceOnce(String text, String old, String replacement, String slug) {
        int at = text.indexOf(old);
        if (at < 0 || text.indexOf(old, at + 1) >= 0) {
            throw new IllegalStateException(slug + ": expected exactly one \"" + old + "\"");
        }
        return text.substring(0, at) + replacement + text.substring(at + old.length());
    }

    /** {@code text} with {@code paragraph} as a paragraph of its own just before the marker. */
    public static String insertBeforeExample1(String text, String marker, String paragraph, String slug) {
        int at = text.indexOf(marker);
        if (at < 0 || text.indexOf(marker, at + 1) >= 0) {
            throw new IllegalStateException(slug + ": expected exactly one \"" + marker + "\"");
        }
        return text.substring(0, at) + paragraph + "\n\n" + text.substring(at);
    }

    static String read(Connection db, String slug, String locale) throws Exception {
        String sql = locale.equals("en")
                ? "SELECT description FROM problems WHERE slug = ?"
                : "SELECT t.description FROM problem_translations t JOIN problems p ON p.id = t.problem_id "
                        + "WHERE p.slug = ? AND t.locale = 'ko'";
        try (PreparedStatement ps = db.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new IllegalStateException(slug + ": no " + locale + " description");
                return rs.getString(1);
            }
        }
    }

    static void rewrite(Connection db, String slug, String locale, String description) throws Exception {
        String sql = locale.equals("en")
                ? "UPDATE problems SET description = ? WHERE slug = ?"
                : "UPDATE problem_translations SET description = ? WHERE locale = 'ko' "
                        + "AND problem_id = (SELECT id FROM problems WHERE slug = ?)";
        try (PreparedStatement ps = db.prepareStatement(sql)) {
            ps.setString(1, description);
            ps.setString(2, slug);
            ps.executeUpdate();
        }
    }
}
