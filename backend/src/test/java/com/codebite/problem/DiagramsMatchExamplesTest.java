package com.codebite.problem;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every Diagram draws the example it sits under (GLOSSARY.md): its main value is copied from the
 * example's input, and `after` from the input or output. Where a Diagram can't be a copy, an entry
 * below says how it comes from the example, so a new exception is a decision and not an accident.
 */
class DiagramsMatchExamplesTest {

    private static final ObjectMapper JSON = new ObjectMapper();

    private static final Pattern EXAMPLE = Pattern.compile("\\*\\*(?:Example|예시) \\d+:\\*\\*");
    private static final Pattern DIAGRAM =
            Pattern.compile("```diagram-[a-z-]+\\n(.*?)\\n```", Pattern.DOTALL);
    private static final Pattern MAIN_KEY = Pattern.compile("(?m)^(cells|nodes|intervals):\\s*(.*)$");
    private static final Pattern EDGES = Pattern.compile("(?m)^edges:\\s*(.*)$");
    private static final Pattern AFTER = Pattern.compile("(?m)^after:\\s*(.*)$");
    private static final Pattern OUTPUT_LABEL = Pattern.compile("(?m)^(?:Output|출력):");

    /** Graphs drawn from an input that isn't an edge list: the example's first array → the edges it means. */
    private static final Map<String, Function<JsonNode, Set<String>>> DERIVED_EDGES = Map.of(
            // Adjacency lists; these spots are numbered from 1.
            "snapshot-town-map", input -> undirected(adjacency(input, 1)),
            "two-shift-baristas", input -> undirected(adjacency(input, 0)),
            "open-all-rooms", input -> adjacency(input, 0),
            // Weighted links; the picture leaves out the weights.
            "cheapest-courier-route", DiagramsMatchExamplesTest::withoutWeights,
            "guild-chat-relay", DiagramsMatchExamplesTest::withoutWeights,
            // Points, any two of which a hose can join.
            "connect-water-bowls", input -> everyPair(input.size()));

    /** Exceptions pinned as a value, since nothing simple computes them from the example. */
    private static final Map<String, String> PINNED = Map.of(
            // Emails shortened to fit the node circles.
            "merge-duplicate-contacts", "[[dp,lens],[lens,cam]]",
            // Words one letter apart, from beginWord and wordList.
            "word-ladder", "[[hit,hot],[hot,dot],[hot,lot],[dot,lot],[dot,dog],[lot,log],[dog,log],[dog,cog],[log,cog]]",
            // The input is a size: rows = 4, cols = 5.
            "count-dungeon-paths", "[[.,.,.,.,.],[.,.,.,.,.],[.,.,.,.,.],[.,.,.,.,.]]");

    /**
     * Drawn from the output, written there another way: n-queens's input is only n, and its boards
     * are rows of text; rebuild-boss-tree's input is two traversals, and its output the tree.
     */
    private static final Set<String> DRAWS_THE_OUTPUT = Set.of("n-queens", "rebuild-boss-tree");

    private static MigratedDatabase database;

    @BeforeAll
    static void migrate() {
        database = new MigratedDatabase("diagrams_match_examples").migrate();
    }

    @Test
    void everyDiagramDrawsTheExampleItSitsUnder() throws Exception {
        List<String> mismatches = new ArrayList<>();
        for (String[] row : database.query(
                "SELECT slug, description FROM problems",
                r -> new String[]{r.getString(1), r.getString(2)})) {
            check(row[0], "en", row[1], mismatches);
        }
        for (String[] row : database.query(
                "SELECT p.slug, pt.description FROM problem_translations pt "
                        + "JOIN problems p ON pt.problem_id = p.id WHERE pt.locale = 'ko'",
                r -> new String[]{r.getString(1), r.getString(2)})) {
            check(row[0], "ko", row[1], mismatches);
        }
        assertTrue(mismatches.isEmpty(), String.join("\n", mismatches));
    }

    private static void check(String slug, String locale, String description, List<String> mismatches)
            throws Exception {
        if (description == null) return;
        Matcher examples = EXAMPLE.matcher(description);
        List<Integer> starts = new ArrayList<>();
        while (examples.find()) starts.add(examples.start());

        Matcher diagrams = DIAGRAM.matcher(description);
        while (diagrams.find()) {
            String where = slug + " (" + locale + "): ";
            int section = -1;
            for (int i = 0; i < starts.size() && starts.get(i) < diagrams.start(); i++) section = i;
            if (section < 0) {
                mismatches.add(where + "a Diagram before any example");
                continue;
            }
            String[] parts = description.substring(starts.get(section), diagrams.start()).split("```");
            if (parts.length < 2) {
                mismatches.add(where + "a Diagram under an example with no code block");
                continue;
            }
            String problem = checkDiagram(slug, diagrams.group(1), parts[1]);
            if (problem != null) mismatches.add(where + problem);
        }
    }

    /** What's wrong with one Diagram body against its example's code block, or null. */
    private static String checkDiagram(String slug, String body, String example) throws Exception {
        Matcher label = OUTPUT_LABEL.matcher(example);
        int split = label.find() ? label.start() : example.length();
        String input = comparable(example.substring(0, split)).replace("2147483647", "INF");
        String output = comparable(example.substring(split)).replace("2147483647", "INF");

        Matcher edges = EDGES.matcher(body);
        Matcher main = MAIN_KEY.matcher(body);
        String value = edges.find() ? comparable(edges.group(1))
                : main.find() ? comparable(main.group(2)) : null;
        if (value == null) return "a Diagram with no main value: " + body;

        if (PINNED.containsKey(slug)) {
            return PINNED.get(slug).equals(value) ? null : "drew " + value + ", pinned " + PINNED.get(slug);
        }
        if (DERIVED_EDGES.containsKey(slug)) {
            Set<String> expected = DERIVED_EDGES.get(slug).apply(firstArray(example.substring(0, split)));
            Set<String> drawn = withoutWeights(JSON.readTree(value));
            return expected.equals(drawn) ? null : "drew " + drawn + ", the input means " + expected;
        }
        if (DRAWS_THE_OUTPUT.contains(slug)) {
            return ignoringPunctuation(output).contains(ignoringPunctuation(value)) ? null
                    : value + " is not in the example's output: " + output;
        }
        if (!input.contains(value)) return value + " is not in the example: " + input;

        Matcher after = AFTER.matcher(body);
        if (after.find()) {
            String afterValue = comparable(after.group(1));
            if (!input.contains(afterValue) && !output.contains(afterValue)) {
                return "after " + afterValue + " is not in the example: " + input + " → " + output;
            }
        }
        return null;
    }

    private static String comparable(String text) {
        return text.replaceAll("\\s", "").replace("\"", "").replace("'", "");
    }

    private static String ignoringPunctuation(String text) {
        return text.replaceAll("[\\[\\],]", "");
    }

    private static JsonNode firstArray(String input) throws Exception {
        int depth = 0;
        int start = input.indexOf('[');
        for (int i = start; i < input.length(); i++) {
            if (input.charAt(i) == '[') depth++;
            if (input.charAt(i) == ']' && --depth == 0) return JSON.readTree(input.substring(start, i + 1));
        }
        throw new IllegalArgumentException("No array in " + input);
    }

    private static Set<String> adjacency(JsonNode lists, int firstNumber) {
        Set<String> edges = new HashSet<>();
        for (int from = 0; from < lists.size(); from++) {
            for (JsonNode to : lists.get(from)) edges.add((from + firstNumber) + "-" + to.asText());
        }
        return edges;
    }

    private static Set<String> undirected(Set<String> edges) {
        Set<String> result = new HashSet<>();
        for (String edge : edges) result.add(unordered(edge));
        return result;
    }

    private static String unordered(String edge) {
        String[] ends = edge.split("-");
        return Integer.parseInt(ends[0]) < Integer.parseInt(ends[1]) ? edge : ends[1] + "-" + ends[0];
    }

    private static Set<String> withoutWeights(JsonNode links) {
        Set<String> edges = new HashSet<>();
        for (JsonNode link : links) edges.add(link.get(0).asText() + "-" + link.get(1).asText());
        return edges;
    }

    private static Set<String> everyPair(int count) {
        Set<String> edges = new HashSet<>();
        for (int a = 0; a < count; a++) {
            for (int b = a + 1; b < count; b++) edges.add(a + "-" + b);
        }
        return edges;
    }
}
