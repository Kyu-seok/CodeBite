package com.codebite.problem;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every Diagram draws the example it sits under (GLOSSARY.md): its main value is the example's
 * first array, and its `after` the example's output. A Diagram that can't be a copy has a rule
 * below saying how it comes from the example, so a new exception is a decision and not an accident.
 * Every Diagram is also well formed: its lines parse as the frontend parses them, and its
 * highlights and `cycle_to` exist in what it draws. Whether a highlight is part of the answer,
 * and `added`, `points` and a copied graph's `directed`, are for a person to check.
 */
class DiagramsMatchExamplesTest {

    private static final ObjectMapper JSON = new ObjectMapper();

    private static final Pattern EXAMPLE = Pattern.compile("\\*\\*(?:Example|예시) (\\d+):\\*\\*");
    private static final Pattern DIAGRAM =
            Pattern.compile("```diagram-([a-z-]+)\\n(.*?)\\n```", Pattern.DOTALL);
    private static final Pattern BODY_KEY = Pattern.compile("(?m)^([a-z_]+):");
    private static final Pattern OUTPUT_LINE = Pattern.compile("(?m)^(?:Output|출력):\\s*(.*)$");

    /** A Diagram body's values by key, with their whitespace removed. */
    private record Body(Map<String, String> values) {
        static Body parse(String text) {
            Map<String, String> values = new LinkedHashMap<>();
            Matcher keys = BODY_KEY.matcher(text);
            String key = null;
            int valueStart = 0;
            while (keys.find()) {
                if (key != null) values.put(key, withoutSpace(text.substring(valueStart, keys.start())));
                key = keys.group(1);
                valueStart = keys.end();
            }
            if (key != null) values.put(key, withoutSpace(text.substring(valueStart)));
            return new Body(values);
        }

        String main() {
            for (String key : List.of("edges", "cells", "nodes", "intervals")) {
                if (values.containsKey(key)) return values.get(key);
            }
            return null;
        }

        String after() {
            return values.get("after");
        }

        boolean directed() {
            return "true".equals(values.get("directed"));
        }
    }

    /** An example's number and the two parts of its code block that a Diagram can be drawn from. */
    private record Example(int number, String input, String output) {
        static Example parse(int number, String codeBlock) {
            Matcher line = OUTPUT_LINE.matcher(codeBlock);
            return line.find()
                    ? new Example(number, codeBlock.substring(0, line.start()), withoutSpace(line.group(1)))
                    : new Example(number, codeBlock, "");
        }
    }

    private record Edge(String from, String to) {
        Edge unordered() {
            return from.compareTo(to) <= 0 ? this : new Edge(to, from);
        }
    }

    /** What's wrong with a Diagram against its example, or null. */
    @FunctionalInterface
    private interface Rule {
        String mismatch(Example example, Body body) throws Exception;
    }

    private static final Rule COPIED = (example, body) -> {
        String drawn = body.main();
        String first = withoutSpace(arrays(example.input()).get(0));
        if (!first.equals(drawn)) return "drew " + drawn + ", the example's first array is " + first;
        return afterIs(example.output(), body);
    };

    private static final Map<String, Rule> RULES = Map.ofEntries(
            // Adjacency lists; these spots are numbered from 1.
            Map.entry("snapshot-town-map", derivedEdges(false, lists -> adjacency(lists, 1))),
            Map.entry("two-shift-baristas", derivedEdges(false, lists -> adjacency(lists, 0))),
            Map.entry("open-all-rooms", derivedEdges(true, lists -> adjacency(lists, 0))),
            // Weighted links; the picture leaves out the weights.
            Map.entry("cheapest-courier-route", derivedEdges(true, DiagramsMatchExamplesTest::edges)),
            Map.entry("guild-chat-relay", derivedEdges(true, DiagramsMatchExamplesTest::edges)),
            // Points, any two of which a hose can join.
            Map.entry("connect-water-bowls", derivedEdges(false, points -> everyPair(points.size()))),
            // Emails shortened to fit the node circles; the second Maya stands alone.
            Map.entry("merge-duplicate-contacts", pinned(1, """
                    edges: [["dp","lens"],["lens","cam"]]
                    nodes: ["dp","lens","cam","leo","solo"]
                    directed: false""")),
            // Words one letter apart, from beginWord and wordList.
            Map.entry("word-ladder", pinned(1, """
                    edges: [["hit","hot"],["hot","dot"],["hot","lot"],["dot","lot"],["dot","dog"],["lot","log"],["dog","log"],["dog","cog"],["log","cog"]]
                    directed: false
                    highlight_path: ["hit","hot","dot","dog","cog"]""")),
            // Player 5 is in no relay, so the Diagram names every player.
            Map.entry("count-voice-parties", pinned(1, """
                    edges: [[0,1],[2,3],[3,4]]
                    nodes: [0,1,2,3,4,5]
                    directed: false""")),
            // The input is a size: rows = 4, cols = 5.
            Map.entry("count-dungeon-paths", pinned(1, """
                    cells: [[".",".",".",".","."],[".",".",".",".","."],[".",".",".",".","."],[".",".",".",".","."]]
                    blank: "."
                    """)),
            // The input is only n, and the output's boards are rows of text.
            Map.entry("n-queens", DiagramsMatchExamplesTest::isABoardOfTheOutput),
            // The input is two traversals of the tree the output writes out.
            Map.entry("rebuild-boss-tree", (example, body) -> example.output().equals(body.main()) ? null
                    : "drew " + body.main() + ", the output is " + example.output()),
            // Two inputs drawn as a pair: `after` is the example's second array.
            Map.entry("same-skill-trees", DiagramsMatchExamplesTest::afterIsTheSecondArray),
            Map.entry("find-submap", DiagramsMatchExamplesTest::afterIsTheSecondArray),
            // INF stands for 2147483647.
            Map.entry("walls-and-gates", (example, body) -> {
                String drawn = body.main().replace("\"INF\"", "2147483647");
                String first = withoutSpace(arrays(example.input()).get(0));
                if (!first.equals(drawn)) return "drew " + drawn + ", the example's first array is " + first;
                return afterIs(example.output(), body);
            }));

    private static MigratedDatabase database;

    @BeforeAll
    static void migrate() {
        database = new MigratedDatabase("diagrams_match_examples").migrate();
    }

    @Test
    void everyDiagramDrawsTheExampleItSitsUnder() throws Exception {
        List<String> mismatches = new ArrayList<>();
        Map<String, String> english = descriptions("SELECT slug, description FROM problems");
        Map<String, String> korean = descriptions("SELECT p.slug, pt.description FROM problem_translations pt "
                + "JOIN problems p ON pt.problem_id = p.id WHERE pt.locale = 'ko'");
        for (var entry : english.entrySet()) check(entry.getKey(), "en", entry.getValue(), mismatches);
        for (var entry : korean.entrySet()) check(entry.getKey(), "ko", entry.getValue(), mismatches);
        assertTrue(mismatches.isEmpty(), String.join("\n", mismatches));
    }

    @Test
    void aDerivedGraphAcceptsItsEdgesWrittenEitherWayRound() throws Exception {
        assertNull(mismatchOf("snapshot-town-map", 1, "Input: adjList = [[2],[1]]",
                "edges: [[2,1]]\ndirected: false"));
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', value = {
            // Pinned, but under the wrong example.
            "count-dungeon-paths | 2 | Input: rows = 2, cols = 6 | cells: [[\".\",\".\",\".\",\".\",\".\"],[\".\",\".\",\".\",\".\",\".\"],[\".\",\".\",\".\",\".\",\".\"],[\".\",\".\",\".\",\".\",\".\"]]\\nblank: \".\"",
            // `after` the same as the input.
            "rotate-pixel-art | 1 | Input: image = [[1,2],[3,4]]\\nOutput: [[3,1],[4,2]] | cells: [[1,2],[3,4]]\\nafter: [[1,2],[3,4]]",
            // `after` only in the explanation.
            "rotate-pixel-art | 1 | Input: image = [[1,2],[3,4]]\\nOutput: [[3,1],[4,2]]\\nExplanation: not [9,9] | cells: [[1,2],[3,4]]\\nafter: [9,9]",
            // A graph's isolated node left out.
            "merge-duplicate-contacts | 1 | Input: accounts = [] | edges: [[\"dp\",\"lens\"],[\"lens\",\"cam\"]]\\nnodes: [\"dp\",\"lens\",\"cam\",\"leo\"]\\ndirected: false",
            // One row of the grid.
            "rotting-donuts | 1 | Input: ward = [[1,2],[3,4]] | cells: [[1,2]]",
            // A later parameter rather than the first.
            "lca-bst | 1 | Input: root = [1,2], other = [3] | nodes: [3]",
            // Numbers for strings.
            "count-desk-clusters | 1 | Input: board = [[\"1\",\"0\"]] | cells: [[1,0]]",
            // Part of the output's tree.
            "rebuild-boss-tree | 1 | Input: preorder = [1,2,3], inorder = [2,1,3]\\nOutput: [1,2,3] | nodes: [1,2]",
            // A board spliced from two solutions.
            "n-queens | 1 | Input: n = 2\\nOutput: [[\"Q.\",\".Q\"],[\".Q\",\"Q.\"]] | cells: [[\"Q\",\".\"],[\"Q\",\".\"]]",
            // A derived graph drawn directed.
            "snapshot-town-map | 1 | Input: adjList = [[2],[1]] | edges: [[1,2]]\\ndirected: true",
    })
    void aWrongDiagramIsCaught(String slug, int number, String codeBlock, String body) throws Exception {
        assertNotNull(mismatchOf(slug, number, codeBlock.replace("\\n", "\n"), body.replace("\\n", "\n")));
    }

    @Test
    void everyDiagramIsWellFormed() throws Exception {
        List<String> problems = new ArrayList<>();
        Map<String, String> all = new LinkedHashMap<>();
        descriptions("SELECT slug, description FROM problems").forEach((slug, text) -> all.put(slug + " (en)", text));
        descriptions("SELECT p.slug, pt.description FROM problem_translations pt "
                + "JOIN problems p ON pt.problem_id = p.id WHERE pt.locale = 'ko'")
                .forEach((slug, text) -> all.put(slug + " (ko)", text));
        for (var entry : all.entrySet()) {
            Matcher diagrams = DIAGRAM.matcher(entry.getValue());
            while (diagrams.find()) {
                String problem = malformation(diagrams.group(1), diagrams.group(2));
                if (problem != null) problems.add(entry.getKey() + ": " + problem);
            }
        }
        assertTrue(problems.isEmpty(), String.join("\n", problems));
    }

    @ParameterizedTest(name = "{0}: {1}")
    @CsvSource(delimiter = '|', value = {
            "grid | cells: [[1,2],[3,4]]\\nhighlight: [[2,0]]",
            "grid | cells: [[1,2],[3,4]]\\nhighlight: [[0,2]]",
            "grid | cells: [[1,2],[3]]",
            "grid | cells: [[1,2]",
            "tree | nodes: [1,null,3]\\nhighlight: [3]",
            "tree | nodes: [1,null,3]\\nhighlight: [1]",
            "linked-list | nodes: [1,2]\\nhighlight: [2]",
            "linked-list | nodes: [1,2]\\ncycle_to: 2",
            "graph | edges: [[1,2],[2,3]]\\nhighlight_path: [1,3]",
            "graph | edges: [[1,2]]\\ndirected: true\\nhighlight_path: [2,1]",
            "intervals | intervals: [[1,2]]\\nhighlight: [1]",
            "grid | not a directive",
    })
    void aMalformedDiagramIsCaught(String kind, String body) throws Exception {
        assertNotNull(malformation(kind, body.replace("\\n", "\n")));
    }

    @ParameterizedTest(name = "{0}: {1}")
    @CsvSource(delimiter = '|', value = {
            "grid | cells: [[1,2],[3,4]]\\nhighlight: [[1,1]]",
            "tree | nodes: [1,null,3]\\nhighlight: [2]",
            "linked-list | nodes: [1,2]\\nhighlight: [1]\\ncycle_to: 0",
            "graph | edges: [[1,2],[2,3]]\\nhighlight_path: [3,2,1]",
            "graph | edges: [[1,2]]\\ndirected: true\\nhighlight_path: [1,2]",
            "intervals | intervals: [[1,2]]\\nhighlight: [0]",
    })
    void aWellFormedDiagramPasses(String kind, String body) throws Exception {
        assertNull(malformation(kind, body.replace("\\n", "\n")));
    }

    /** What's structurally wrong with a Diagram body, or null. Lines parse as parseDirective.ts parses them. */
    private static String malformation(String kind, String body) {
        Map<String, JsonNode> values = new LinkedHashMap<>();
        for (String line : body.split("\n")) {
            String trimmed = line.trim();
            if (trimmed.isEmpty() || trimmed.startsWith("#")) continue;
            int colon = trimmed.indexOf(':');
            if (colon < 0) return "not a key and value: " + trimmed;
            try {
                values.put(trimmed.substring(0, colon).trim(), JSON.readTree(trimmed.substring(colon + 1)));
            } catch (Exception e) {
                return "can't parse: " + trimmed;
            }
        }
        return switch (kind) {
            case "grid" -> gridMalformation(values);
            case "tree", "linked-list" -> listMalformation(values, "nodes");
            case "intervals" -> listMalformation(values, "intervals");
            case "graph" -> pathMalformation(values);
            default -> "unknown kind " + kind;
        };
    }

    private static String gridMalformation(Map<String, JsonNode> values) {
        JsonNode cells = values.get("cells");
        if (cells == null || !cells.isArray() || cells.isEmpty()) return "no cells";
        int width = cells.get(0).size();
        for (JsonNode row : cells) {
            if (row.size() != width) return "rows of different lengths";
        }
        for (JsonNode cell : values.getOrDefault("highlight", JSON.createArrayNode())) {
            int row = cell.get(0).asInt();
            int column = cell.get(1).asInt();
            if (row < 0 || row >= cells.size() || column < 0 || column >= width) return "highlight outside the grid: " + cell;
        }
        return null;
    }

    private static String listMalformation(Map<String, JsonNode> values, String key) {
        JsonNode items = values.get(key);
        if (items == null || !items.isArray()) return "no " + key;
        for (JsonNode index : values.getOrDefault("highlight", JSON.createArrayNode())) {
            JsonNode item = items.get(index.asInt());
            if (item == null || item.isNull()) return "highlight on nothing: " + index;
        }
        JsonNode cycleTo = values.get("cycle_to");
        if (cycleTo != null && items.get(cycleTo.asInt()) == null) return "cycle_to outside the list: " + cycleTo;
        return null;
    }

    private static String pathMalformation(Map<String, JsonNode> values) {
        JsonNode pairs = values.get("edges");
        if (pairs == null || !pairs.isArray()) return "no edges";
        boolean directed = values.containsKey("directed") && values.get("directed").asBoolean();
        Set<Edge> edges = directed ? edges(pairs) : unordered(edges(pairs));
        JsonNode path = values.getOrDefault("highlight_path", JSON.createArrayNode());
        for (int i = 0; i + 1 < path.size(); i++) {
            Edge step = new Edge(path.get(i).asText(), path.get(i + 1).asText());
            if (!edges.contains(directed ? step : step.unordered())) return "highlight_path uses no edge: " + step;
        }
        return null;
    }

    private static Map<String, String> descriptions(String sql) throws Exception {
        Map<String, String> bySlug = new LinkedHashMap<>();
        for (Map.Entry<String, String> row : database.query(
                sql, r -> Map.entry(r.getString(1), String.valueOf(r.getString(2))))) {
            bySlug.put(row.getKey(), row.getValue());
        }
        return bySlug;
    }

    private static void check(String slug, String locale, String description, List<String> mismatches)
            throws Exception {
        List<Integer> starts = new ArrayList<>();
        List<Integer> numbers = new ArrayList<>();
        Matcher examples = EXAMPLE.matcher(description);
        while (examples.find()) {
            starts.add(examples.start());
            numbers.add(Integer.parseInt(examples.group(1)));
        }

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
            String mismatch = mismatchOf(slug, numbers.get(section), parts[1], diagrams.group(2));
            if (mismatch != null) mismatches.add(where + mismatch);
        }
    }

    private static String mismatchOf(String slug, int number, String codeBlock, String body) throws Exception {
        return RULES.getOrDefault(slug, COPIED).mismatch(Example.parse(number, codeBlock), Body.parse(body));
    }

    private static String afterIs(String expected, Body body) {
        String after = body.after();
        return after == null || after.equals(expected) ? null : "after " + after + ", the output is " + expected;
    }

    private static Rule pinned(int number, String body) {
        Body expected = Body.parse(body);
        return (example, drawn) -> {
            if (example.number() != number) return "pinned to example " + number + ", under " + example.number();
            return expected.values().equals(drawn.values()) ? null
                    : "drew " + drawn.values() + ", pinned " + expected.values();
        };
    }

    private static Rule derivedEdges(boolean directed, Function<JsonNode, Set<Edge>> fromFirstArray) {
        return (example, body) -> {
            if (body.directed() != directed) return "directed should be " + directed;
            Set<Edge> expected = fromFirstArray.apply(JSON.readTree(arrays(example.input()).get(0)));
            Set<Edge> drawn = edges(JSON.readTree(body.main()));
            if (!directed) {
                expected = unordered(expected);
                drawn = unordered(drawn);
            }
            return expected.equals(drawn) ? null : "drew " + drawn + ", the input means " + expected;
        };
    }

    private static String isABoardOfTheOutput(Example example, Body body) throws Exception {
        List<String> rows = new ArrayList<>();
        for (JsonNode row : JSON.readTree(body.main())) {
            StringBuilder text = new StringBuilder();
            row.forEach(cell -> text.append(cell.asText()));
            rows.add(text.toString());
        }
        for (JsonNode board : JSON.readTree(example.output())) {
            List<String> boardRows = new ArrayList<>();
            board.forEach(row -> boardRows.add(row.asText()));
            if (boardRows.equals(rows)) return null;
        }
        return "drew " + rows + ", not a board of " + example.output();
    }

    private static String afterIsTheSecondArray(Example example, Body body) {
        List<String> arrays = arrays(example.input());
        String first = withoutSpace(arrays.get(0));
        String second = withoutSpace(arrays.get(1));
        return first.equals(body.main()) && second.equals(body.after()) ? null
                : "drew " + body.main() + " and " + body.after() + ", the inputs are " + first + " and " + second;
    }

    private static String withoutSpace(String text) {
        return text.replaceAll("\\s", "");
    }

    /** The input's top-level arrays, in order. */
    private static List<String> arrays(String input) {
        List<String> found = new ArrayList<>();
        int depth = 0;
        int start = 0;
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            if (c == '[' && depth++ == 0) start = i;
            if (c == ']' && --depth == 0) found.add(input.substring(start, i + 1));
        }
        return found.isEmpty() ? List.of("") : found;
    }

    private static Set<Edge> adjacency(JsonNode lists, int firstNumber) {
        Set<Edge> edges = new HashSet<>();
        for (int from = 0; from < lists.size(); from++) {
            for (JsonNode to : lists.get(from)) edges.add(new Edge(String.valueOf(from + firstNumber), to.asText()));
        }
        return edges;
    }

    /** Each entry's first two values as an edge; a weighted link's third is left out. */
    private static Set<Edge> edges(JsonNode pairs) {
        Set<Edge> edges = new HashSet<>();
        for (JsonNode pair : pairs) edges.add(new Edge(pair.get(0).asText(), pair.get(1).asText()));
        return edges;
    }

    private static Set<Edge> everyPair(int count) {
        Set<Edge> edges = new HashSet<>();
        for (int a = 0; a < count; a++) {
            for (int b = a + 1; b < count; b++) edges.add(new Edge(String.valueOf(a), String.valueOf(b)));
        }
        return edges;
    }

    private static Set<Edge> unordered(Set<Edge> edges) {
        return edges.stream().map(Edge::unordered).collect(Collectors.toSet());
    }
}
