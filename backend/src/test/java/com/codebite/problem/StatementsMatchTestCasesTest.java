package com.codebite.problem;

import com.codebite.judge.Language;
import com.codebite.judge.program.ProblemAssets;
import com.codebite.problem.StatementReport.Finding;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every statement against what a user is judged on, in both languages: it has an Example, Example N
 * shows sample N's input and expected output, and every array or string the constraints index or
 * measure is a parameter of the Python Starter Code. EXAMPLES_DIFFER_FROM_SAMPLES and
 * CONSTRAINTS_NAME_NO_PARAMETER hold the problems that break this today. They only shrink: an entry
 * that now passes, or names no problem (a Restatement renamed it), is a failure. A Restatement
 * fixes the problem and removes its entry.
 *
 * <p>A failure names only the unlisted problems. Every run also writes each check's mismatch lines,
 * listed problems marked {@code [listed]}, to {@code backend/build/reports/statements/examples.txt}
 * and {@code constraints.txt} ({@link StatementReport}): read those to see why a listed problem is
 * listed, instead of emptying its set.
 */
class StatementsMatchTestCasesTest {

    private static final MigratedDatabase DATABASE = new MigratedDatabase("statements-match-test-cases");
    private static final ProblemAssets ASSETS = new ProblemAssets();

    /** Example N isn't sample N, or the statement has no Example with an Input and Output to compare. */
    private static final Set<String> EXAMPLES_DIFFER_FROM_SAMPLES = Set.of(
            "binary-tree-level-order", "capture-enclosed-tiles", "chat-log-codec",
            "chat-ring-buffer", "fizz-buzz", "graph-valid-tree",
            "group-anagrams", "kth-top-score-stream", "largest-rectangle-histogram",
            "lca-binary-tree", "lca-bst", "longest-palindromic-substring",
            "lru-cache", "n-queens", "peak-score-streak",
            "populating-next-pointers", "queue-from-stacks", "random-pick-bag",
            "reverse-linked-list", "running-median-timer", "sort-colors",
            "sum-root-to-leaf", "timestamp-value-store", "trapping-rain-water",
            "valid-sudoku", "versioned-cells",
            "walls-and-gates", "wildcard-lexicon", "word-ladder",
            "word-search", "word-search-ii");

    /**
     * Not a defect, and for outputs only: the Example shows the answer a user returns and the Driver
     * prints a check of it (VALID, or the count and the array on two lines). A new entry is a
     * decision that a Driver works this way.
     */
    private static final Set<String> DRIVER_PRINTS_ANOTHER_FORM = Set.of(
            "dedupe-textbook-shelf", "order-group-tasks", "space-cookie-bakes");

    private static final Set<String> CONSTRAINTS_NAME_NO_PARAMETER = Set.of();

    private static final Pattern MARKER = Pattern.compile("\\*\\*(?:Example|예시)(?: (\\d+))?:\\*\\*");
    private static final Pattern INPUT_AND_OUTPUT = Pattern.compile(
            "(?:Input|입력):?(?=\\s)(.*?)(?:Output|출력):?(?=\\s)(.*?)(?:\\n```|Explanation|설명|\\z)", Pattern.DOTALL);
    private static final Pattern NAME_PREFIX = Pattern.compile("^[A-Za-z_]\\w*\\s*=(?!=)\\s*");
    private static final Pattern CODE_SPAN = Pattern.compile("`([^`]*)`");
    private static final Pattern MEASURED_NAME = Pattern.compile("(?<![\\w.])([A-Za-z_]\\w*)(?:\\.length|\\[)");
    private static final Pattern PYTHON_DEF = Pattern.compile("def \\w+\\(([^)]*)\\)");
    private static final Pattern TYPE_ARGUMENTS = Pattern.compile("\\[[^\\[\\]]*\\]");

    private record Statement(String slug, String locale, String description, String constraints) {
        String name() {
            return slug + " (" + locale + ")";
        }
    }

    private record Sample(String input, String output) {
    }

    /** One Example's number and its Input and Output text; both null when it has no such lines. */
    private record Example(int number, String input, String output) {
    }

    private static List<Statement> statements;
    private static final Map<String, List<Sample>> SAMPLES = new HashMap<>();

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
        DATABASE.query("""
                        SELECT p.slug, t.input, t.expected_output
                        FROM test_cases t JOIN problems p ON p.id = t.problem_id
                        WHERE t.is_sample ORDER BY p.slug, t.order_index, t.id""",
                row -> SAMPLES.computeIfAbsent(row.getString(1), slug -> new ArrayList<>())
                        .add(new Sample(MigratedDatabase.postgresText(row.getString(2)),
                                MigratedDatabase.postgresText(row.getString(3)))));
    }

    // --- every problem ---------------------------------------------------------------------------

    @Test
    void everyExampleShowsItsSample() {
        assertListed("examples", EXAMPLES_DIFFER_FROM_SAMPLES, statement -> mismatches(statement.description(), samplesOf(statement),
                !DRIVER_PRINTS_ANOTHER_FORM.contains(statement.slug())));
    }

    @Test
    void everyDriverFormExemptionIsStillNeeded() {
        Set<String> differing = new TreeSet<>();
        for (Statement statement : statements) {
            boolean withOutput = !mismatches(statement.description(), samplesOf(statement), true).isEmpty();
            boolean withoutOutput = !mismatches(statement.description(), samplesOf(statement), false).isEmpty();
            if (withOutput && !withoutOutput) differing.add(statement.slug());
        }
        Set<String> stale = new TreeSet<>(DRIVER_PRINTS_ANOTHER_FORM);
        stale.removeAll(differing);
        assertTrue(stale.isEmpty(), "exempt, but their outputs match or their inputs don't: " + stale);
    }

    @Test
    void constraintsNameOnlyParameters() {
        assertListed("constraints", CONSTRAINTS_NAME_NO_PARAMETER, statement -> {
            String starter = ASSETS.starters(statement.slug()).get(Language.PYTHON);
            if (starter == null) return List.of("no Python Starter Code");
            return namesOutsideParameters(statement.constraints(), starter);
        });
    }

    private static List<Sample> samplesOf(Statement statement) {
        return SAMPLES.getOrDefault(statement.slug(), List.of());
    }

    /** Fails on an unlisted breaking problem or a stale entry; writes {@code <name>.txt} either way. */
    private static void assertListed(String name, Set<String> listed, Function<Statement, List<String>> check) {
        Set<String> breaking = new TreeSet<>();
        List<String> messages = new ArrayList<>();
        List<Finding> findings = new ArrayList<>();
        for (Statement statement : statements) {
            List<String> problems = check.apply(statement);
            if (problems.isEmpty()) continue;
            breaking.add(statement.slug());
            findings.add(new Finding(statement.slug(), statement.name(), problems));
            if (!listed.contains(statement.slug())) messages.add(statement.name() + ": " + problems);
        }
        report(name, listed, breaking, findings);
        stale(listed, breaking).ifPresent(messages::add);
        assertTrue(messages.isEmpty(), String.join("\n", messages)
                + "\nbreaking now (" + breaking.size() + "): " + breaking);
    }

    private static void report(String name, Set<String> listed, Set<String> breaking, List<Finding> findings) {
        try {
            StatementReport.write(StatementReport.DIRECTORY, name, listed, breaking, findings);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    private static Optional<String> stale(Set<String> listed, Set<String> breaking) {
        Set<String> gone = new TreeSet<>(listed);
        gone.removeAll(breaking);
        return gone.isEmpty()
                ? Optional.empty()
                : Optional.of("listed but passing or renamed, so remove them: " + gone);
    }

    // --- the checks ------------------------------------------------------------------------------

    /** One line per way the description differs; an Example past the samples has no sample to show. */
    private static List<String> mismatches(String description, List<Sample> samples, boolean withOutput) {
        List<Example> examples = examples(description);
        if (examples.isEmpty()) return List.of("no Example");
        List<String> mismatches = new ArrayList<>();
        for (Example example : examples) {
            if (example.number() < 1 || example.number() > samples.size()) continue;
            Sample sample = samples.get(example.number() - 1);
            if (example.input() == null) {
                mismatches.add("Example " + example.number() + " has no Input and Output");
                continue;
            }
            if (!values(example.input()).equals(sampleValues(sample.input()))) {
                mismatches.add("Example " + example.number() + " input isn't " + sample.input());
            }
            if (withOutput && !values(example.output()).equals(sampleValues(sample.output()))) {
                mismatches.add("Example " + example.number() + " output isn't " + sample.output());
            }
        }
        return mismatches;
    }

    /** An unnumbered Example is the first. */
    private static List<Example> examples(String description) {
        List<Example> examples = new ArrayList<>();
        Matcher marker = MARKER.matcher(description);
        boolean found = marker.find();
        while (found) {
            int number = marker.group(1) == null ? 1 : Integer.parseInt(marker.group(1));
            int start = marker.end();
            found = marker.find();
            String text = description.substring(start, found ? marker.start() : description.length());
            Matcher parts = INPUT_AND_OUTPUT.matcher(text);
            examples.add(parts.find()
                    ? new Example(number, parts.group(1), parts.group(2))
                    : new Example(number, null, null));
        }
        return examples;
    }

    /** A sample's lines, each one value, as the Driver reads them; empty output is one empty value. */
    private static List<String> sampleValues(String text) {
        List<String> values = new ArrayList<>();
        for (String line : text.stripTrailing().split("\n", -1)) values.add(normal(line));
        return values;
    }

    /** The values an Example's text lists, split at commas, lines and " / " outside brackets and quotes. */
    private static List<String> values(String text) {
        List<String> values = new ArrayList<>();
        StringBuilder value = new StringBuilder();
        int depth = 0;
        boolean quoted = false;
        for (char c : text.toCharArray()) {
            if (c == '"') quoted = !quoted;
            if (!quoted && "[{(".indexOf(c) >= 0) depth++;
            if (!quoted && "]})".indexOf(c) >= 0) depth--;
            if (!quoted && depth == 0 && ",\n/".indexOf(c) >= 0) {
                addValue(values, value);
            } else {
                value.append(c);
            }
        }
        addValue(values, value);
        return values;
    }

    private static void addValue(List<String> values, StringBuilder value) {
        String text = NAME_PREFIX.matcher(value.toString().strip()).replaceFirst("");
        if (!text.isEmpty()) values.add(normal(text));
        value.setLength(0);
    }

    /** Without the spacing outside quotes and without the quotes around one whole string. */
    private static String normal(String text) {
        String stripped = text.strip();
        if (stripped.length() >= 2 && stripped.startsWith("\"") && stripped.endsWith("\"")
                && stripped.indexOf('"', 1) == stripped.length() - 1) {
            return stripped.substring(1, stripped.length() - 1);
        }
        if (!stripped.startsWith("[") && !stripped.startsWith("{")) return stripped;
        StringBuilder out = new StringBuilder();
        boolean quoted = false;
        for (char c : stripped.toCharArray()) {
            if (c == '"') quoted = !quoted;
            if (quoted || !Character.isWhitespace(c)) out.append(c);
        }
        return out.toString();
    }

    private static List<String> namesOutsideParameters(String constraints, String pythonStarter) {
        if (constraints == null) return List.of();
        Set<String> parameters = pythonParameters(pythonStarter);
        Set<String> unknown = new TreeSet<>();
        Matcher span = CODE_SPAN.matcher(constraints);
        while (span.find()) {
            Matcher name = MEASURED_NAME.matcher(span.group(1));
            while (name.find()) {
                if (!parameters.contains(name.group(1))) unknown.add(name.group(1));
            }
        }
        return List.copyOf(unknown);
    }

    /** Every method's parameters: the constructor's and each method's, for a design problem. */
    private static Set<String> pythonParameters(String starter) {
        Set<String> parameters = new TreeSet<>();
        Matcher def = PYTHON_DEF.matcher(starter);
        while (def.find()) {
            String list = def.group(1);
            for (String previous = ""; !previous.equals(list); ) {
                previous = list;
                list = TYPE_ARGUMENTS.matcher(list).replaceAll("");
            }
            for (String parameter : list.split(",")) {
                String name = parameter.split("[:=]")[0].strip();
                if (!name.isEmpty() && !name.equals("self")) parameters.add(name);
            }
        }
        return parameters;
    }

    // --- what the checks catch -------------------------------------------------------------------

    private static final String ONE_ARGUMENT = "Input: nums = [1, 2]\nOutput: [2, 1]\n```";
    private static final String TWO_ARGUMENTS = "Input: nums = [1,2,3], k = 3\nOutput: 6\n```";

    private static String described(String example) {
        return "Statement.\n\n**Example 1:**\n```\n" + example.replace("\\n", "\n");
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', value = {
            "wrong input           | [1,3]        | [2,1]",
            "wrong output          | [1,2]        | [1,2]",
            "output inside a list  | [1,2]        | 2",
            "input inside a list   | 1            | [2,1]",
    })
    void aWrongExampleIsCaught(String way, String input, String output) {
        assertFalse(mismatches(described(ONE_ARGUMENT), List.of(new Sample(input, output)), true).isEmpty(), way);
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', value = {
            "argument order swapped | 3\\n[1,2,3]     | 6",
            "argument missing       | [1,2,3]         | 6",
            "argument extra         | [1,2,3]\\n3\\n4 | 6",
            "one value of a list    | 2\\n3           | 6",
            "output's decimals      | [1,2,3]\\n3     | 6.5",
    })
    void aWrongExampleWithArgumentsIsCaught(String way, String input, String output) {
        Sample sample = new Sample(input.replace("\\n", "\n"), output);
        assertFalse(mismatches(described(TWO_ARGUMENTS), List.of(sample), true).isEmpty(), way);
    }

    @Test
    void anEmptyExpectedOutputMatchesOnlyAnEmptyOutput() {
        Sample empty = new Sample("[1,2]", "");
        assertFalse(mismatches(described(ONE_ARGUMENT), List.of(empty), true).isEmpty());
        String shown = described("Input: nums = [1,2]\nOutput: \"\"\n```");
        assertEquals(List.of(), mismatches(shown, List.of(empty), true));
    }

    @Test
    void spacesInsideAStringAreKept() {
        String shown = described("Input: s = \"a b\"\nOutput: 1\n```");
        assertFalse(mismatches(shown, List.of(new Sample("ab", "1")), true).isEmpty());
        assertEquals(List.of(), mismatches(shown, List.of(new Sample("a b", "1")), true));
    }

    @Test
    void anExampleWithoutInputAndOutputIsCaught() {
        assertFalse(mismatches(described("Just prose.\n```"), List.of(new Sample("1", "1")), true).isEmpty());
    }

    @Test
    void aStatementWithoutAnExampleIsCaught() {
        assertEquals(List.of("no Example"), mismatches("Only prose.", List.of(new Sample("1", "1")), true));
    }

    @Test
    void theNextExampleStaysOutOfThisOne() {
        String two = "**Example 1:**\nInput: 1\nOutput: 2\n\n**Example 2:**\nInput: 3\nOutput: 4\n";
        assertEquals(List.of(), mismatches(two, List.of(new Sample("1", "2"), new Sample("3", "4")), true));
    }

    @Test
    void aMatchingExamplePassesWhateverItsSpacingAndNames() {
        assertEquals(List.of(), mismatches(described(ONE_ARGUMENT), List.of(new Sample("[1,2]", "[2,1]")), true));
        assertEquals(List.of(), mismatches(described(TWO_ARGUMENTS), List.of(new Sample("[1,2,3]\n3", "6")), true));
        assertEquals(List.of(), mismatches(
                "**Example:**\n```\nInput: s = \"hi\", t = \"yo\"\nOutput: answer = true\n```",
                List.of(new Sample("hi\nyo", "true")), true));
    }

    @Test
    void anExemptOutputStillHasItsInputChecked() {
        assertEquals(List.of(), mismatches(described(ONE_ARGUMENT), List.of(new Sample("[1,2]", "VALID")), false));
        assertFalse(mismatches(described(ONE_ARGUMENT), List.of(new Sample("[9]", "VALID")), false).isEmpty());
    }

    @Test
    void aConstraintOnANonParameterIsCaught() {
        String starter = "class Solution:\n    def solve(self, nums: List[List[int]], k: Dict[str, int] = None) -> int:\n"
                + "        # helper is only a comment\n        pass\n";
        assertEquals(List.of(), namesOutsideParameters("- `1 <= nums.length`\n- `k[i]`", starter));
        assertEquals(List.of("barrels"), namesOutsideParameters("- `1 <= barrels.length`", starter));
        assertEquals(List.of("solve"), namesOutsideParameters("- `solve.length`", starter));
        assertEquals(List.of("helper"), namesOutsideParameters("- `helper[i]`", starter));
    }

    @Test
    void aStaleListEntryIsCaught() {
        assertEquals("listed but passing or renamed, so remove them: [power-set]",
                stale(Set.of("power-set", "fizz-buzz"), Set.of("fizz-buzz")).orElseThrow());
        assertTrue(stale(Set.of("fizz-buzz"), Set.of("fizz-buzz", "lca-bst")).isEmpty());
    }
}
