package com.codebite.problem;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every statement against what a user is judged on, in both languages: Example N shows sample N's
 * input and expected output, and every array or string the constraints index or measure is a
 * parameter of the Starter Code. The two lists hold the problems that break this today. They only
 * shrink: an entry that now passes, or names no problem (a Restatement renamed it), is a failure.
 * A Restatement fixes the problem and removes its entry.
 */
class StatementsMatchTestCasesTest {

    private static final MigratedDatabase DATABASE = new MigratedDatabase("statements-match-test-cases");

    /** Example N isn't sample N, or not in the words the sample has. */
    private static final Set<String> EXAMPLES_DIFFER_FROM_SAMPLES = Set.of(
            "binary-tree-level-order", "capture-enclosed-tiles", "fizz-buzz",
            "graph-valid-tree", "group-anagrams", "kth-top-score-stream",
            "largest-rectangle-histogram", "lca-binary-tree", "lca-bst",
            "longest-palindromic-substring", "lru-cache", "n-queens",
            "peak-score-streak", "populating-next-pointers", "reverse-linked-list",
            "sort-colors", "sum-root-to-leaf", "trapping-rain-water",
            "valid-anagram", "valid-sudoku", "walls-and-gates",
            "word-ladder", "word-search", "word-search-ii");

    /**
     * Not a defect: the Example shows the answer a user returns and the Driver prints a check of it
     * (VALID, or the count and the array on two lines), so the output can't match. A new entry is
     * a decision that a Driver works this way.
     */
    private static final Set<String> DRIVER_PRINTS_ANOTHER_FORM = Set.of(
            "dedupe-textbook-shelf", "order-group-tasks", "space-cookie-bakes");

    private static final Set<String> CONSTRAINTS_NAME_NO_PARAMETER = Set.of(
            "graph-valid-tree", "group-anagrams", "largest-rectangle-histogram",
            "longest-palindromic-substring", "peak-score-streak", "sort-colors",
            "trapping-rain-water", "valid-anagram", "valid-sudoku",
            "walls-and-gates", "word-ladder", "word-search-ii");

    private static final Pattern EXAMPLE = Pattern.compile("\\*\\*(?:Example|예시) (\\d+):\\*\\*");
    private static final Pattern INPUT_AND_OUTPUT = Pattern.compile(
            "(?:Input|입력):?\\s(.*?)(?:Output|출력):?\\s(.*?)(?:\\n```|(?:Explanation|설명):|$)", Pattern.DOTALL);
    private static final Pattern CODE_SPAN = Pattern.compile("`([^`]*)`");
    private static final Pattern MEASURED_NAME = Pattern.compile("(?<![\\w.])([A-Za-z_]\\w*)(?:\\.length|\\[)");
    private static final Pattern WORD = Pattern.compile("\\w+");

    private record Statement(String slug, String locale, String description, String constraints) {
        String name() {
            return slug + " (" + locale + ")";
        }
    }

    private record Sample(String input, String output) {
    }

    private static List<Statement> statements;

    @BeforeAll
    static void migrate() throws SQLException {
        DATABASE.migrate();
        statements = DATABASE.query("""
                        SELECT slug, 'en', description, constraints FROM problems
                        UNION ALL
                        SELECT p.slug, t.locale, t.description, t.constraints
                        FROM problem_translations t JOIN problems p ON p.id = t.problem_id WHERE t.locale = 'ko'
                        ORDER BY 1, 2""",
                row -> new Statement(row.getString(1), row.getString(2),
                        MigratedDatabase.postgresText(row.getString(3)),
                        MigratedDatabase.postgresText(row.getString(4))));
    }

    @Test
    void everyExampleShowsItsSample() throws SQLException {
        Set<String> listed = new TreeSet<>(EXAMPLES_DIFFER_FROM_SAMPLES);
        listed.addAll(DRIVER_PRINTS_ANOTHER_FORM);
        Set<String> breaking = new TreeSet<>();
        List<String> messages = new ArrayList<>();
        for (Statement statement : statements) {
            List<String> mismatches = exampleMismatches(statement);
            if (mismatches.isEmpty()) continue;
            breaking.add(statement.slug());
            if (!listed.contains(statement.slug())) {
                messages.add(statement.name() + ": " + mismatches);
            }
        }
        assertOnlyListed(listed, breaking, messages);
    }

    @Test
    void constraintsNameOnlyParameters() throws IOException {
        Set<String> breaking = new TreeSet<>();
        List<String> messages = new ArrayList<>();
        for (Statement statement : statements) {
            List<String> unknown = namesOutsideStarterCode(statement);
            if (unknown.isEmpty()) continue;
            breaking.add(statement.slug());
            if (!CONSTRAINTS_NAME_NO_PARAMETER.contains(statement.slug())) {
                messages.add(statement.name() + ": " + unknown + " is no parameter of the Starter Code");
            }
        }
        assertOnlyListed(CONSTRAINTS_NAME_NO_PARAMETER, breaking, messages);
    }

    private static void assertOnlyListed(Set<String> listed, Set<String> breaking, List<String> messages) {
        Set<String> stale = new TreeSet<>(listed);
        stale.removeAll(breaking);
        if (!stale.isEmpty()) messages.add("listed but passing or renamed, so remove them: " + stale);
        assertTrue(messages.isEmpty(), String.join("\n", messages)
                + "\nbreaking now (" + breaking.size() + "): " + breaking);
    }

    /** One line per Example whose text isn't its sample's; an Example past the samples has no sample to show. */
    private static List<String> exampleMismatches(Statement statement) throws SQLException {
        List<Sample> samples = DATABASE.query("""
                        SELECT t.input, t.expected_output
                        FROM test_cases t JOIN problems p ON p.id = t.problem_id
                        WHERE p.slug = ? AND t.is_sample ORDER BY t.order_index, t.id""",
                row -> new Sample(MigratedDatabase.postgresText(row.getString(1)),
                        MigratedDatabase.postgresText(row.getString(2))),
                statement.slug());
        List<String> mismatches = new ArrayList<>();
        Matcher marker = EXAMPLE.matcher(statement.description());
        List<int[]> starts = new ArrayList<>();
        while (marker.find()) starts.add(new int[] {Integer.parseInt(marker.group(1)), marker.end()});
        for (int i = 0; i < starts.size(); i++) {
            int number = starts.get(i)[0];
            if (number > samples.size() || number < 1) continue;
            int end = i + 1 < starts.size() ? starts.get(i + 1)[1] : statement.description().length();
            String text = statement.description().substring(starts.get(i)[1], end);
            Matcher parts = INPUT_AND_OUTPUT.matcher(text);
            if (!parts.find()) {
                mismatches.add("Example " + number + " has no Input and Output");
                continue;
            }
            Sample sample = samples.get(number - 1);
            for (String line : sample.input().split("\\n")) {
                if (!line.isBlank() && !shows(parts.group(1), line)) {
                    mismatches.add("Example " + number + " input lacks " + line);
                }
            }
            if (!shows(parts.group(2), sample.output())) {
                mismatches.add("Example " + number + " output lacks " + sample.output());
            }
        }
        return mismatches;
    }

    /** Whether the Example's text holds this value whole, whatever its spacing and quotes. */
    private static boolean shows(String exampleText, String value) {
        String wanted = plain(value);
        return Pattern.compile("(?<![\\w-])" + Pattern.quote(wanted) + "(?!\\w)").matcher(plain(exampleText)).find();
    }

    private static String plain(String text) {
        return text.replaceAll("[\\s\"']", "");
    }

    private static List<String> namesOutsideStarterCode(Statement statement) throws IOException {
        if (statement.constraints() == null) return List.of();
        String path = "starters/" + statement.slug() + "/python.py";
        Set<String> words = new TreeSet<>();
        try (InputStream starter = StatementsMatchTestCasesTest.class.getClassLoader().getResourceAsStream(path)) {
            if (starter == null) return List.of();
            Matcher word = WORD.matcher(new String(starter.readAllBytes(), StandardCharsets.UTF_8));
            while (word.find()) words.add(word.group());
        }
        Set<String> unknown = new TreeSet<>();
        Matcher span = CODE_SPAN.matcher(statement.constraints());
        while (span.find()) {
            Matcher name = MEASURED_NAME.matcher(span.group(1));
            while (name.find()) {
                if (!words.contains(name.group(1))) unknown.add(name.group(1));
            }
        }
        return List.copyOf(unknown);
    }
}
