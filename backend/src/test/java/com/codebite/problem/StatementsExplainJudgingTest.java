package com.codebite.problem;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every statement explains the judging rules its Python Driver and Starter Code imply, in the
 * standard sentences of #351 (GLOSSARY.md), in English and Korean:
 *
 * <ul>
 *   <li>a Level-Order Array, when the Driver builds or prints a tree from a list
 *       ({@code _build_tree}, {@code _tree_to_array});</li>
 *   <li>an Any-Order Result, when the Driver sorts the result ("both" when it also sorts each
 *       item, {@code [sorted(}); and only then, so no statement claims a sort the Driver skips;</li>
 *   <li>an In-Place Method, when a {@code Solution} method returns {@code None}.</li>
 * </ul>
 *
 * The sentences themselves are in V590, V591 and V592; a new problem copies them.
 */
class StatementsExplainJudgingTest {

    private static final MigratedDatabase DATABASE = new MigratedDatabase("statements-explain-judging");

    /** The Driver sorts something that is not the result. */
    private static final Set<String> SORTS_NOT_THE_RESULT = Set.of("snapshot-town-map");

    static final String TREE_EN = "level by level, left to right, with `null` for a missing child "
            + "(trailing `null`s left out).";
    static final String TREE_KO = "위층부터 왼쪽에서 오른쪽으로 적으며, 없는 자식은 `null`로 적습니다"
            + "(끝에 남는 `null`은 생략합니다).";
    static final String SORTS_EN = "in any order: the grader sorts them before comparing.";
    static final String SORTS_KO = "채점기가 비교 전에 정렬합니다.";
    static final String SORTS_BOTH_EN = "in any order: the grader sorts both before comparing.";
    static final String SORTS_BOTH_KO = "채점기가 비교 전에 둘 다 정렬합니다.";
    private static final Pattern IN_PLACE_EN = Pattern.compile("returns nothing, and the grader reads [^.]* after the call");
    private static final Pattern IN_PLACE_KO = Pattern.compile("아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 `");
    private static final Pattern RETURNS_NONE = Pattern.compile("def \\w+\\(self[^)]*\\)\\s*->\\s*None");

    private record Statement(String en, String ko) {}

    private static Map<String, Statement> statements;

    @BeforeAll
    static void migrate() throws SQLException {
        DATABASE.migrate();
        statements = new TreeMap<>();
        DATABASE.query("SELECT p.slug, p.description, t.description FROM problems p "
                        + "LEFT JOIN problem_translations t ON t.problem_id = p.id AND t.locale = 'ko'",
                row -> statements.put(row.getString(1), new Statement(
                        MigratedDatabase.postgresText(row.getString(2)),
                        MigratedDatabase.postgresText(row.getString(3) == null ? "" : row.getString(3)))));
        assertFalse(statements.isEmpty(), "No problems after the migrations");
    }

    @Test
    void everyTreeAsAListIsExplained() throws IOException {
        List<String> missing = new ArrayList<>();
        for (var e : statements.entrySet()) {
            String driver = driverCalls(e.getKey());
            if (driver == null || !(driver.contains("def _build_tree") || driver.contains("def _tree_to_array"))) continue;
            require(missing, e.getKey(), e.getValue(), TREE_EN, TREE_KO);
        }
        assertTrue(missing.isEmpty(), "Level-Order Array sentence missing (copy it from V590): " + missing);
    }

    @Test
    void everySortedResultIsExplainedAndNoOtherIs() throws IOException {
        List<String> wrong = new ArrayList<>();
        for (var e : statements.entrySet()) {
            String slug = e.getKey();
            String driver = driverCalls(slug);
            boolean sorts = driver != null && !SORTS_NOT_THE_RESULT.contains(slug)
                    && (driver.contains("sorted(") || driver.contains(".sort("));
            boolean both = sorts && driver.contains("[sorted(");
            Statement s = e.getValue();
            if (both) require(wrong, slug, s, SORTS_BOTH_EN, SORTS_BOTH_KO);
            else if (sorts) require(wrong, slug, s, SORTS_EN, SORTS_KO);
            boolean claimsSort = s.en().contains("the grader sorts") || s.ko().contains("채점기가 비교 전에");
            if (!sorts && claimsSort) wrong.add(slug + ": says the grader sorts, but its Driver doesn't");
            if (sorts && !both && (s.en().contains(SORTS_BOTH_EN) || s.ko().contains(SORTS_BOTH_KO))) {
                wrong.add(slug + ": says the grader sorts both, but its Driver sorts only the outer list");
            }
        }
        assertTrue(wrong.isEmpty(), "Any-Order Result sentence wrong or missing (copy it from V591): " + wrong);
    }

    @Test
    void everyInPlaceMethodIsExplained() throws IOException {
        List<String> missing = new ArrayList<>();
        for (var e : statements.entrySet()) {
            String starter = resource("starters/" + e.getKey() + "/python.py");
            if (starter == null || !starter.contains("class Solution") || !RETURNS_NONE.matcher(starter).find()) continue;
            Statement s = e.getValue();
            if (!IN_PLACE_EN.matcher(s.en()).find()) missing.add(e.getKey() + " (en)");
            if (!IN_PLACE_KO.matcher(s.ko()).find()) missing.add(e.getKey() + " (ko)");
        }
        assertTrue(missing.isEmpty(), "In-Place Method sentence missing (copy it from V592): " + missing);
    }

    private static void require(List<String> missing, String slug, Statement s, String en, String ko) {
        if (!s.en().contains(en)) missing.add(slug + " (en)");
        if (!s.ko().contains(ko)) missing.add(slug + " (ko)");
    }

    /** The Python Driver from {@code {USER_CODE}} on, where it calls the user's code and prints. */
    private static String driverCalls(String slug) throws IOException {
        String driver = resource("drivers/" + slug + "/python.py");
        if (driver == null) return null;
        int at = driver.indexOf("{USER_CODE}");
        return at < 0 ? driver : driver.substring(at);
    }

    private static String resource(String path) throws IOException {
        try (InputStream in = StatementsExplainJudgingTest.class.getClassLoader().getResourceAsStream(path)) {
            return in == null ? null : new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
