package com.codebite.problem;

import com.codebite.problem.service.Walkthroughs;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.UnaryOperator;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every Walkthrough (GLOSSARY.md, ADR 0011) shows the samples it claims to: its problem exists
 * under the Slug it is filed under; it is a well-formed {@code walkthrough/1} document (the public
 * walkthrough skill's {@code references/format.md}: known view types, marks inside the data they
 * name, moves whose addresses exist in that frame by the kit's address table, unique map keys and set members, set probes that hit only members, spans inside their array, map slots a
 * non-negative integer, a map probe with a key that it hits only when held, intervals that start no later than they end, queue marks and tags on its positions, a grid's boxes a whole number and its shade on its cells, map entry labels as Text and chip marks on their list, the answer on the last frame only); its sample runs are, in order, exactly the problem's
 * sample Test Cases by {@code sampleInput} and {@code expected}, compared trimmed as the Grader
 * compares; each run ends on its {@code expected}; and any run marked {@code extra} comes after
 * the sample runs; run N is labelled "Example N" exactly when the description shows {@code **Example N:**} ("Case N"
 * otherwise, in Korean too); every caption is one or two sentences in each language (#258); and every frame keeps #273's two rules (a change has a move into it, and {@code vars} repeats nothing drawn on the data; see the tests below). Correcting, adding or reordering a sample without regenerating the Walkthrough
 * (its tracer is {@code scripts/walkthroughs/<slug>.py}) fails here.
 */
class WalkthroughsMatchSamplesTest {

    private static final ObjectMapper JSON = new ObjectMapper();
    private static final MigratedDatabase DATABASE = new MigratedDatabase("walkthroughs-match-samples");
    private static final Walkthroughs WALKTHROUGHS = new Walkthroughs();
    private static final WalkthroughAddresses ADDRESSES = WalkthroughAddresses.kit();

    private static final List<String> VIEW_TYPES = List.of("grid", "array", "map", "set", "output", "queue", "intervals", "graph", "table", "vars");
    private static final List<String> MARKS = List.of("lit", "good", "bad", "path", "dim");

    /**
     * Where a sentence ends, in English or Korean: a full stop, question mark or exclamation mark with more text after
     * the space that follows it. A decimal point has no space after it, and "e.g." and "i.e." end none.
     */
    private static final Pattern SENTENCE_END = Pattern.compile("(?<!\\be\\.g)(?<!\\bi\\.e)[.?!](?=\\s+\\S)");
    private static final int MAX_CAPTION_SENTENCES = 2;

    /** A sample Test Case's input and expected output, as PostgreSQL stores them. */
    record Sample(String input, String expected) {
    }

    private static final Map<String, List<Sample>> SAMPLES = new HashMap<>();

    /** Each problem's description by language ("en", "ko"), for the run labels. */
    private static final Map<String, Map<String, String>> DESCRIPTIONS = new HashMap<>();

    /** The word a run's label starts with, by language: for a sample its description shows as an Example, and for one it doesn't. */
    private static final Map<String, String> EXAMPLE_WORD = Map.of("en", "Example", "ko", "예시");
    private static final Map<String, String> CASE_WORD = Map.of("en", "Case", "ko", "케이스");

    @BeforeAll
    static void migrate() throws SQLException {
        DATABASE.migrate();
        DATABASE.query("SELECT slug FROM problems", row -> SAMPLES.put(row.getString(1), new ArrayList<>()));
        DATABASE.query("""
                        SELECT p.slug, t.input, t.expected_output
                        FROM test_cases t JOIN problems p ON p.id = t.problem_id
                        WHERE t.is_sample ORDER BY p.slug, t.order_index, t.id""",
                row -> SAMPLES.get(row.getString(1)).add(new Sample(
                        MigratedDatabase.postgresText(row.getString(2)),
                        MigratedDatabase.postgresText(row.getString(3)))));
        DATABASE.query("SELECT slug, description FROM problems", row -> DESCRIPTIONS
                .computeIfAbsent(row.getString(1), k -> new HashMap<>()).put("en", MigratedDatabase.postgresText(row.getString(2))));
        DATABASE.query("""
                        SELECT p.slug, t.description FROM problem_translations t JOIN problems p ON p.id = t.problem_id
                        WHERE t.locale = 'ko'""", row -> DESCRIPTIONS
                .computeIfAbsent(row.getString(1), k -> new HashMap<>()).put("ko", MigratedDatabase.postgresText(row.getString(2))));
    }

    @Test
    void everyWalkthroughShowsItsProblemsSamples() throws Exception {
        assertFalse(WALKTHROUGHS.slugs().isEmpty(), "No Walkthroughs under walkthroughs/");
        List<String> mismatches = new ArrayList<>();
        for (String slug : WALKTHROUGHS.slugs()) {
            JsonNode walkthrough = JSON.readTree(WALKTHROUGHS.of(slug).orElseThrow());
            mismatches.addAll(mismatches(slug, walkthrough, SAMPLES.get(slug)));
        }
        assertTrue(mismatches.isEmpty(), "Walkthroughs that disagree with their problem's samples "
                + "(regenerate with scripts/walkthroughs/<slug>.py):\n" + String.join("\n", mismatches));
    }

    @Test
    void everyRunIsLabelledByItsExample() throws Exception {
        List<String> mismatches = new ArrayList<>();
        for (String slug : WALKTHROUGHS.slugs()) {
            mismatches.addAll(labelMismatches(slug, JSON.readTree(WALKTHROUGHS.of(slug).orElseThrow()), DESCRIPTIONS.get(slug)));
        }
        assertTrue(mismatches.isEmpty(), "Walkthrough runs labelled against their problem's Examples (rerun "
                + "scripts/walkthroughs/<slug>.py, .claude/skills/add-walkthrough/SKILL.md):\n" + String.join("\n", mismatches));
    }

    /** Descriptions of three samples where the first two are Examples, in English and Korean. */
    private static final Map<String, String> TWO_EXAMPLES = Map.of(
            "en", "Count them.\n\n**Example 1:**\n```\nInput: in 1\n```\n\n**Example 2:**\n```\nInput: in 2\n```",
            "ko", "세어 보세요.\n\n**예시 1:**\n```\nInput: in 1\n```\n\n**예시 2:**\n```\nInput: in 2\n```");

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "Case label for an Example              | run 2 (Case 2): en label is \"Case 2\", not \"Example 2\": the description has **Example 2:**",
            "Korean Case label for an Example       | run 2 (Example 2): ko label is \"케이스 2\", not \"예시 2\": the description has **예시 2:**",
            "Example label for a non-Example        | run 3 (Example 3): en label is \"Example 3\", not \"Case 3\": the description has no **Example 3:**",
            "Korean Example label for a non-Example | run 3 (Case 3): ko label is \"예시 3\", not \"케이스 3\": the description has no **예시 3:**",
            "label numbered past its run            | run 1 (Example 2): en label is \"Example 2\", not \"Example 1\"",
            "free label on a sample run             | run 3 (All fresh): en label is \"All fresh\", not \"Case 3\"",
            "Korean free label on a sample run      | run 3 (Case 3): ko label is \"모두 신선\", not \"케이스 3\"",
            "no label                               | run 2 (?): en label is missing, not \"Example 2\"",
    })
    void aRunLabelledAgainstItsExampleIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = labelledFixture();
        ArrayNode runs = (ArrayNode) walkthrough.get("runs");
        switch (breakage) {
            case "Case label for an Example" -> label(runs.get(1), "Case 2", "케이스 2");
            case "Korean Case label for an Example" -> label(runs.get(1), "Example 2", "케이스 2");
            case "Example label for a non-Example" -> label(runs.get(2), "Example 3", "케이스 3");
            case "Korean Example label for a non-Example" -> label(runs.get(2), "Case 3", "예시 3");
            case "label numbered past its run" -> label(runs.get(0), "Example 2", "예시 1");
            case "free label on a sample run" -> label(runs.get(2), "All fresh", "케이스 3");
            case "Korean free label on a sample run" -> label(runs.get(2), "Case 3", "모두 신선");
            case "no label" -> ((ObjectNode) runs.get(1)).remove("label");
            default -> throw new IllegalArgumentException(breakage);
        }
        List<String> found = labelMismatches("fixture", walkthrough, TWO_EXAMPLES);
        assertTrue(found.stream().anyMatch(m -> m.startsWith("fixture: ") && m.contains(expected)),
                breakage + " was not caught as \"" + expected + "\": " + found);
    }

    @Test
    void runsLabelledByTheirExamplesPass() throws Exception {
        ObjectNode walkthrough = labelledFixture();
        ((ArrayNode) walkthrough.get("runs")).addObject().put("extra", true).putObject("label").put("en", "All fresh").put("ko", "모두 신선");
        assertEquals(List.of(), labelMismatches("fixture", walkthrough, TWO_EXAMPLES));
    }

    /**
     * A problem with no Korean description still has its Korean labels checked, against the English description's
     * Examples: the samples it shows as Examples are the same in both languages, and skipping Korean would let any
     * Korean label through.
     */
    @Test
    void withNoKoreanDescriptionKoreanLabelsFollowTheEnglishExamples() throws Exception {
        Map<String, String> englishOnly = Map.of("en", TWO_EXAMPLES.get("en"));
        assertEquals(List.of(), labelMismatches("fixture", labelledFixture(), englishOnly));

        ObjectNode walkthrough = labelledFixture();
        label(walkthrough.get("runs").get(2), "Case 3", "예시 3");
        List<String> found = labelMismatches("fixture", walkthrough, englishOnly);
        assertTrue(found.stream().anyMatch(m -> m.contains("run 3 (Case 3): ko label is \"예시 3\", not \"케이스 3\"")),
                found.toString());
    }

    /** {@link #samplesFixture()} labelled for {@link #TWO_EXAMPLES}: Example 1, Example 2, Case 3. */
    private static ObjectNode labelledFixture() throws Exception {
        ObjectNode walkthrough = samplesFixture();
        label(walkthrough.get("runs").get(2), "Case 3", "케이스 3");
        return walkthrough;
    }

    private static void label(JsonNode run, String english, String korean) {
        ((ObjectNode) run).putObject("label").put("en", english).put("ko", korean);
    }

    // --- the checks catch what they should, each on a Walkthrough it builds ---------------------------------
    //
    // Each case breaks a fixture below, never a real Walkthrough at a fixed frame or move: regenerating a tracer moves
    // what a position holds, and the case would then fail for the wrong reason or pass without testing anything
    // (CODING_STANDARDS.md, "A test makes the missing asset it needs").

    /**
     * Three sample runs of a grid {@code tray} and a queue {@code queue}: in each, a cell joins the queue from the grid
     * in its first frame and spreads to its neighbour in the second.
     */
    private static ObjectNode samplesFixture() throws Exception {
        String run = """
                [{'views': {'tray': {'cells': [[2, 1]]}, 'queue': {'values': [[0, 0]]}},
                  'moves': [{'from': {'view': 'tray', 'at': [0, 0]}, 'to': {'view': 'queue', 'at': 0}}]},
                 {'views': {'tray': {'cells': [[2, 2]]}, 'queue': {'values': []}},
                  'moves': [{'from': {'view': 'tray', 'at': [0, 0]}, 'to': {'view': 'tray', 'at': [0, 1]}}]},
                 {'views': {'tray': {'cells': [[2, 2]]}, 'queue': {'values': []}}}]""";
        return walkthrough("[{'id': 'tray', 'type': 'grid'}, {'id': 'queue', 'type': 'queue'}]", run, run, run);
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "unknown view type               | view \"tray\": unknown type \"tree\"",
            "mark outside the grid           | view \"tray\": mark \"lit\" names [9,9], not a cell [r, c] in the data",
            "answer on a middle frame        | run 1 (Example 1) frame 2 of 3: answer \"4\" on a frame before the last",
            "no answer on the last frame     | run 1 (Example 1): the last frame has no answer",
            "answer not the expected         | run 1 (Example 1): the last frame's answer is \"5\", the run's expected is \"out 1\"",
            "expected not the sample's       | run 1 (Example 1): expected is \"5\", sample 1's expected output is \"out 1\"",
            "sampleInput not the sample's    | run 1 (Example 1): sampleInput is \"[[2,1]]\", sample 1's input is \"in 1\"",
            "missing run                     | sample 3 (input \"in 3\", expected output \"out 3\") has no run",
            "swapped runs                    | run 1 (Example 2): sampleInput is \"in 2\", sample 1's input is \"in 1\"",
            "extra run before a sample run   | run 3 (Example 3): is a sample run after an extra run",
            "extra run with a sampleInput    | run 4 (Example 1): is marked extra but has a sampleInput",
            "run past the samples            | run 4 (Example 1): is not marked extra, but the problem has only 3 samples",
            "empty caption                   | run 1 (Example 1) frame 1 of 3: caption missing",
            "three-sentence caption          | run 1 (Example 1) frame 1 of 3: en caption has 3 sentences",
            "three-sentence Korean caption   | run 1 (Example 1) frame 1 of 3: ko caption has 3 sentences",
    })
    void aBrokenWalkthroughIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = samplesFixture();
        ArrayNode runs = (ArrayNode) walkthrough.get("runs");
        ObjectNode first = (ObjectNode) runs.get(0);
        ArrayNode frames = (ArrayNode) first.get("frames");
        switch (breakage) {
            case "unknown view type" -> ((ObjectNode) walkthrough.get("views").get(0)).put("type", "tree");
            case "mark outside the grid" -> ((ObjectNode) frames.get(1).get("views").get("tray"))
                    .putObject("marks").putArray("lit").add(JSON.readTree("[9,9]"));
            case "answer on a middle frame" -> ((ObjectNode) frames.get(1)).put("answer", "4");
            case "no answer on the last frame" -> ((ObjectNode) frames.get(frames.size() - 1)).remove("answer");
            case "answer not the expected" -> ((ObjectNode) frames.get(frames.size() - 1)).put("answer", "5");
            case "expected not the sample's" -> {
                first.put("expected", "5");
                ((ObjectNode) frames.get(frames.size() - 1)).put("answer", "5");
            }
            case "sampleInput not the sample's" -> first.put("sampleInput", "[[2,1]]");
            case "missing run" -> runs.remove(2);
            case "swapped runs" -> runs.insert(0, runs.remove(1));
            case "extra run before a sample run" -> ((ObjectNode) runs.get(1)).put("extra", true);
            case "extra run with a sampleInput" -> runs.add(((ObjectNode) runs.get(0).deepCopy()).put("extra", true));
            case "run past the samples" -> runs.add(runs.get(0).deepCopy());
            case "empty caption" -> ((ObjectNode) frames.get(0).get("caption")).put("ko", " ");
            case "three-sentence caption" -> ((ObjectNode) frames.get(0).get("caption"))
                    .put("en", "Minute 0. Two donuts are stale. Spread from both.");
            case "three-sentence Korean caption" -> ((ObjectNode) frames.get(0).get("caption"))
                    .put("ko", "0분입니다. 상한 도넛이 둘입니다. 둘 다에서 퍼집니다.");
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(3), breakage, expected);
    }

    /** One run of an array {@code log} counted into a map {@code uses}, beside a {@code vars} view and an output not drawn. */
    private static ObjectNode movesFixture() throws Exception {
        return walkthrough("""
                        [{'id': 'log', 'type': 'array'}, {'id': 'uses', 'type': 'map'}, {'id': 'state', 'type': 'vars'},
                         {'id': 'board', 'type': 'output'}]""", """
                        [{'views': {'log': {'values': [3, 5]}, 'uses': {'entries': []}, 'state': {'items': []}}},
                         {'views': {'log': {'values': [3, 5]}, 'uses': {'entries': [{'key': 3, 'value': 1}]}, 'state': {'items': []}},
                          'moves': [{'from': {'view': 'log', 'at': 0}, 'to': {'view': 'uses', 'at': 3}}]}]""");
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "move to a missing key                   | to {\"view\":\"uses\",\"at\":99} is not a key of map \"uses\"",
            "move from outside the array             | is not an index of array \"log\"",
            "move to an unknown view                 | to names unknown view \"nope\"",
            "move with no ends                       | move 0: no from and no to",
            "move to a view type without addresses   | view type \"vars\" has no addresses",
            "move with an unknown mark               | move 0: unknown mark \"loud\"",
            "moves not a list                        | moves is not a list",
            "move to a view not drawn in this frame  | view \"uses\" is not drawn in this frame",
            "repeated map key                        | view \"uses\": key",
            "rank of a missing key                   | rank 1 names 99, not a key",
            "repeated ranks key                      | rank 2 repeats key",
            "probe with no key                       | probe has no key",
            "probe hit that isn't true or false      | probe hit must be true or false",
            "probe hitting a key not held            | probe hits 99, not a key",
            "output mark out of range                | view \"board\": mark \"good\" names 99",
    })
    void aBrokenMoveOrMapIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = movesFixture();
        ArrayNode frames = (ArrayNode) walkthrough.get("runs").get(0).get("frames");
        ObjectNode move = (ObjectNode) frames.get(1).get("moves").get(0);
        ObjectNode views = (ObjectNode) frames.get(1).get("views");
        ObjectNode uses = (ObjectNode) views.get("uses");
        JsonNode firstKey = uses.get("entries").get(0).get("key");
        switch (breakage) {
            case "move to a missing key" -> ((ObjectNode) move.get("to")).put("at", 99);
            case "move from outside the array" -> ((ObjectNode) move.get("from")).put("at", 99);
            case "move to an unknown view" -> ((ObjectNode) move.get("to")).put("view", "nope");
            case "move with no ends" -> move.removeAll();
            case "move to a view type without addresses" -> ((ObjectNode) move.get("to")).put("view", "state");
            case "move with an unknown mark" -> move.put("mark", "loud");
            case "moves not a list" -> ((ObjectNode) frames.get(1)).put("moves", "uses");
            case "move to a view not drawn in this frame" -> views.remove("uses");
            case "repeated map key" -> ((ArrayNode) uses.get("entries")).add(uses.get("entries").get(0).deepCopy());
            case "rank of a missing key" -> uses.putArray("ranks").add(99);
            case "repeated ranks key" -> uses.putArray("ranks").add(firstKey).add(firstKey);
            case "probe with no key" -> uses.putObject("probe").put("label", "lookup");
            case "probe hit that isn't true or false" -> uses.putObject("probe").put("key", 99).put("hit", "yes");
            case "probe hitting a key not held" -> uses.putObject("probe").put("key", 99).put("hit", true);
            case "output mark out of range" -> {
                ObjectNode board = views.putObject("board");
                board.putArray("values");
                board.putObject("marks").putArray("good").add(99);
            }
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(1), breakage, expected);
    }

    /** One run of a table {@code groups} whose second frame moves a value out of a cell. */
    private static ObjectNode tableFixture() throws Exception {
        return walkthrough("[{'id': 'groups', 'type': 'table'}]", """
                [{'views': {'groups': {'rows': [{'cells': ['aet', ['eat']]}]}}},
                 {'views': {'groups': {'rows': [{'cells': ['aet', ['eat']]}]}}, 'moves': [{'from': {'view': 'groups', 'at': [0, 1]}, 'mark': 'good'}]}]""");
    }

    @ParameterizedTest(name = "{0}")
    @ValueSource(strings = {"move from a row that isn't there", "move from a column that isn't there", "move from a bare index"})
    void aBrokenTableAddressIsCaught(String breakage) throws Exception {
        ObjectNode walkthrough = tableFixture();
        ArrayNode frames = (ArrayNode) walkthrough.get("runs").get(0).get("frames");
        ObjectNode from = (ObjectNode) frames.get(1).get("moves").get(0).get("from");
        switch (breakage) {
            case "move from a row that isn't there" -> from.set("at", JSON.readTree("[99, 0]"));
            case "move from a column that isn't there" -> from.set("at", JSON.readTree("[0, 9]"));
            case "move from a bare index" -> from.put("at", 0);
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(1), breakage, "is not a [row, col] of table");
    }

    /** One run of an intervals view {@code line} on the axis 0 to 10: two slots in group 0 merged into group 1. */
    private static ObjectNode intervalsFixture() throws Exception {
        return walkthrough("[{'id': 'line', 'type': 'intervals'}]", """
                [{'views': {'line': {'domain': [0, 10], 'groups': [{'intervals': [[1, 3], [2, 5]]}, {'intervals': []}]}}},
                 {'views': {'line': {'domain': [0, 10], 'groups': [{'intervals': [[1, 3], [2, 5]]}, {'intervals': [[1, 5]]}]}},
                  'moves': [{'from': {'view': 'line', 'at': [0, 1]}, 'to': {'view': 'line', 'at': [1, 0]}}]}]""");
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "interval starting after its end    | group 1 interval 0 [9,1] starts after it ends",
            "move to a missing interval         | to {\"view\":\"line\",\"at\":[1,5]} is not a [group, index] of intervals",
            "move to a group that isn't there   | to {\"view\":\"line\",\"at\":[2,0]} is not a [group, index] of intervals",
            "mark outside its group             | group 1: mark \"good\" names 5",
            "point off the axis                 | point 0 at 999 is outside the axis",
            "domain not [low, high]             | domain [5,1] is not [low, high]",
            "point with an unknown mark         | point 0 has unknown mark \"loud\"",
    })
    void aBrokenIntervalsViewIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = intervalsFixture();
        ArrayNode frames = (ArrayNode) walkthrough.get("runs").get(0).get("frames");
        ObjectNode move = (ObjectNode) frames.get(1).get("moves").get(0);
        ObjectNode line = (ObjectNode) frames.get(1).get("views").get("line");
        ObjectNode merged = (ObjectNode) line.get("groups").get(1);
        switch (breakage) {
            case "interval starting after its end" -> merged.set("intervals", JSON.readTree("[[9, 1]]"));
            case "move to a missing interval" -> ((ObjectNode) move.get("to")).set("at", JSON.readTree("[1, 5]"));
            case "move to a group that isn't there" -> ((ObjectNode) move.get("to")).set("at", JSON.readTree("[2, 0]"));
            case "mark outside its group" -> merged.putObject("marks").putArray("good").add(5);
            case "point off the axis" -> line.putArray("points").addObject().put("at", 999);
            case "domain not [low, high]" -> line.set("domain", JSON.readTree("[5, 1]"));
            case "point with an unknown mark" -> line.putArray("points").addObject().put("at", 1).put("mark", "loud");
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(1), breakage, expected);
    }

    /** One run of an array {@code lockers} read into a set {@code seen}, which a probe has missed. */
    private static ObjectNode setFixture() throws Exception {
        return walkthrough("[{'id': 'lockers', 'type': 'array'}, {'id': 'seen', 'type': 'set'}]", """
                [{'views': {'lockers': {'values': [4, 7, 4]}, 'seen': {'members': [], 'probes': []}}},
                 {'views': {'lockers': {'values': [4, 7, 4]}, 'seen': {'members': [4], 'probes': [{'value': 4, 'hit': false}]}},
                  'moves': [{'from': {'view': 'lockers', 'at': 0}, 'to': {'view': 'seen', 'at': 4}}]}]""");
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "repeated set member           | view \"seen\": member 4 repeats",
            "move to a missing member      | to {\"view\":\"seen\",\"at\":999} is not a member of set \"seen\"",
            "probe hitting a non-member    | view \"seen\": probe 1 hits 999, not a member",
            "probe with no value           | view \"seen\": probe 1 has no value",
            "mark on a missing member      | view \"seen\": mark \"lit\" names 999, not a member in the data",
            "probes not a list             | view \"seen\": probes must be a list",
    })
    void aBrokenSetIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = setFixture();
        ObjectNode frame = (ObjectNode) walkthrough.get("runs").get(0).get("frames").get(1);
        ObjectNode move = (ObjectNode) frame.get("moves").get(0);
        ObjectNode seen = (ObjectNode) frame.get("views").get("seen");
        switch (breakage) {
            case "repeated set member" -> ((ArrayNode) seen.get("members")).add(seen.get("members").get(0).asText());
            case "move to a missing member" -> ((ObjectNode) move.get("to")).put("at", 999);
            case "probe hitting a non-member" -> ((ArrayNode) seen.get("probes")).addObject().put("value", 999).put("hit", true);
            case "probe with no value" -> ((ArrayNode) seen.get("probes")).addObject().put("hit", false);
            case "mark on a missing member" -> seen.putObject("marks").putArray("lit").add(999);
            case "probes not a list" -> seen.put("probes", 4);
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(1), breakage, expected);
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "move from a missing grid cell                     | is not a [row, col] of grid \"tray\"",
            "move from a grid address that isn't [row, col]    | is not a [row, col] of grid \"tray\"",
            "move to a missing queue position                  | is not a position from the front of queue \"queue\"",
            "queue mark past the queue                         | view \"queue\": mark \"good\" names",
            "queue tag past the queue                          | is outside the queue",
            "queue without values                              | view \"queue\": values must be a list, front first",
            "deque flag not true or false                      | view \"queue\": deque must be true or false",
    })
    void aBrokenQueueOrGridMoveIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = samplesFixture();
        ArrayNode frames = (ArrayNode) walkthrough.get("runs").get(0).get("frames");
        ObjectNode joins = (ObjectNode) frames.get(0).get("moves").get(0); // a cell joins the queue from the grid
        ObjectNode queue = (ObjectNode) frames.get(0).get("views").get("queue");
        int n = queue.get("values").size();
        switch (breakage) {
            case "move from a missing grid cell" -> ((ObjectNode) joins.get("from")).set("at", JSON.readTree("[9, 0]"));
            case "move from a grid address that isn't [row, col]" -> ((ObjectNode) joins.get("from")).put("at", 0);
            case "move to a missing queue position" -> ((ObjectNode) joins.get("to")).put("at", n);
            case "queue mark past the queue" -> queue.putObject("marks").putArray("good").add(n);
            case "queue tag past the queue" -> queue.putArray("tags").addArray().add(n).add("x");
            case "queue without values" -> queue.remove("values");
            case "deque flag not true or false" -> ((ObjectNode) walkthrough.get("views").get(1)).put("deque", "yes");
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(3), breakage, expected);
    }

    /**
     * One run of a 2x2 grid {@code board} in boxes of one cell, read into a map {@code rows} of chip lists, the cell
     * read shaded with its band.
     */
    private static ObjectNode boardFixture() throws Exception {
        return walkthrough("[{'id': 'board', 'type': 'grid', 'boxes': 1}, {'id': 'rows', 'type': 'map'}]", """
                [{'views': {'board': {'cells': [['5', '3'], ['6', '.']]}, 'rows': {'entries': []}}},
                 {'views': {'board': {'cells': [['5', '3'], ['6', '.']], 'shade': [[0, 0], [0, 1]], 'marks': {'lit': [[0, 0]]}},
                            'rows': {'entries': [{'key': 'row 1', 'label': 'row 1', 'value': ['5']}]}},
                  'moves': [{'from': {'view': 'board', 'at': [0, 0]}, 'to': {'view': 'rows', 'at': 'row 1'}}]}]""");
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "boxes not a whole number            | view \"board\": boxes must be a whole number of cells, 1 or more",
            "boxes of zero                       | view \"board\": boxes must be a whole number of cells, 1 or more",
            "shade outside the grid              | view \"board\": shade names [9,0], not a cell [r, c]",
            "entry label not Text                | view \"rows\": entry row 1 has a label that is not Text",
            "chip mark past the entry's list     | view \"rows\": entry row 1: mark \"bad\" names 5, not a chip index",
    })
    void aBrokenBoardOrRegionCardIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = boardFixture();
        ArrayNode frames = (ArrayNode) walkthrough.get("runs").get(0).get("frames");
        ObjectNode board = (ObjectNode) walkthrough.get("views").get(0);
        ObjectNode read = (ObjectNode) frames.get(1).get("views").get("board");
        ObjectNode entry = (ObjectNode) frames.get(1).get("views").get("rows").get("entries").get(0);
        switch (breakage) {
            case "boxes not a whole number" -> board.put("boxes", "3");
            case "boxes of zero" -> board.put("boxes", 0);
            case "shade outside the grid" -> ((ArrayNode) read.get("shade")).addArray().add(9).add(0);
            case "entry label not Text" -> entry.put("label", 3);
            case "chip mark past the entry's list" -> entry.putObject("marks").putArray("bad").add(5);
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(1), breakage, expected);
    }

    /** One run of a directed graph {@code cafes}, 0 to 1, whose edge relaxes node 1's cost into an array {@code now}. */
    private static ObjectNode graphFixture() throws Exception {
        String graph = "'nodes': [{'id': 0}, {'id': 1}], 'edges': [{'from': 0, 'to': 1, 'label': 50}]";
        return walkthrough("[{'id': 'cafes', 'type': 'graph', 'directed': true}, {'id': 'now', 'type': 'array'}]",
                "[{'views': {'cafes': {" + graph + "}, 'now': {'values': [0, 'inf']}}},"
                        + " {'views': {'cafes': {" + graph + ", 'values': {'1': 50}}, 'now': {'values': [0, 50]}},"
                        + "  'moves': [{'from': {'view': 'cafes', 'at': [0, 1]}, 'to': {'view': 'now', 'at': 1}, 'mark': 'good'}]}]");
    }

    @ParameterizedTest(name = "{0}")
    @ValueSource(strings = {
            "move from a directed edge turned around", "move from an edge that isn't there",
            "move from an edge address that isn't [from, to]", "move to a missing node",
    })
    void aBrokenGraphMoveIsCaught(String breakage) throws Exception {
        String expected = "is not a node id or a [from, to] edge of graph \"cafes\"";
        ObjectNode walkthrough = graphFixture();
        ObjectNode relaxes = (ObjectNode) walkthrough.get("runs").get(0).get("frames").get(1).get("moves").get(0);
        ObjectNode from = (ObjectNode) relaxes.get("from");
        JsonNode edge = from.get("at");
        switch (breakage) {
            case "move from a directed edge turned around" -> from.set("at", JSON.createArrayNode().add(edge.get(1)).add(edge.get(0)));
            case "move from an edge that isn't there" -> from.set("at", JSON.createArrayNode().add(edge.get(0)).add(99));
            case "move from an edge address that isn't [from, to]" -> from.set("at", JSON.createArrayNode().add(edge.get(0)).add(edge.get(1)).add(0));
            case "move to a missing node" -> relaxes.set("to", JSON.createObjectNode().put("view", "cafes").put("at", 99));
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(1), breakage, expected);
    }

    /** One run of an array {@code queue} under a span {@code window}, counted into a map {@code window} of two slots. */
    private static ObjectNode spanFixture() throws Exception {
        return walkthrough("[{'id': 'queue', 'type': 'array'}, {'id': 'window', 'type': 'map'}]", """
                [{'views': {'queue': {'values': ['a', 'b', 'a']}, 'window': {'entries': [], 'slots': 2}}},
                 {'views': {'queue': {'values': ['a', 'b', 'a'], 'spans': {'window': {'from': 0, 'to': 0}}},
                            'window': {'entries': [{'key': 'a', 'value': 1}], 'slots': 2}},
                  'moves': [{'from': {'view': 'queue', 'at': 0}, 'to': {'view': 'window', 'at': 'a'}}]}]""");
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "span past the array's end        | view \"queue\": span \"window\"",
            "span turned around               | view \"queue\": span \"window\"",
            "span with an unknown mark        | span \"window\" has unknown mark \"loud\"",
            "span label that is not text      | span \"window\" has a label that is not Text",
            "negative slots                   | slots -1 is not a non-negative integer",
            "fractional slots                 | slots 1.5 is not a non-negative integer",
            "unread outside the array         | unread names",
            "label under outside the array    | label under",
            "struck key not held              | struck names \"no such genre\", not a key",
    })
    void aBrokenSpanOrSlotIsCaught(String breakage, String expected) throws Exception {
        ObjectNode walkthrough = spanFixture();
        ObjectNode frame = (ObjectNode) walkthrough.get("runs").get(0).get("frames").get(1);
        ObjectNode queue = (ObjectNode) frame.get("views").get("queue");
        ObjectNode window = (ObjectNode) queue.get("spans").get("window");
        ObjectNode genres = (ObjectNode) frame.get("views").get("window");
        int n = queue.get("values").size();
        switch (breakage) {
            case "span past the array's end" -> window.put("to", n);
            case "span turned around" -> window.put("from", window.get("to").asInt() + 1);
            case "span with an unknown mark" -> window.put("mark", "loud");
            case "span label that is not text" -> window.put("label", 5);
            case "negative slots" -> genres.put("slots", -1);
            case "fractional slots" -> genres.put("slots", 1.5);
            case "unread outside the array" -> queue.putArray("unread").add(n);
            case "label under outside the array" -> queue.putArray("under").addArray().add(n).add("x");
            case "struck key not held" -> genres.putArray("struck").add("no such genre");
            default -> throw new IllegalArgumentException(breakage);
        }
        assertCaught(walkthrough, samples(1), breakage, expected);
    }

    @ParameterizedTest(name = "{0}")
    @ValueSource(strings = {"samples", "moves", "table", "intervals", "set", "board", "graph", "span"})
    void aFixtureUnbrokenPasses(String fixture) throws Exception {
        ObjectNode walkthrough = switch (fixture) {
            case "samples" -> samplesFixture();
            case "moves" -> movesFixture();
            case "table" -> tableFixture();
            case "intervals" -> intervalsFixture();
            case "set" -> setFixture();
            case "board" -> boardFixture();
            case "graph" -> graphFixture();
            case "span" -> spanFixture();
            default -> throw new IllegalArgumentException(fixture);
        };
        assertEquals(List.of(), mismatches("fixture", walkthrough, samples(walkthrough.get("runs").size())));
    }

    /**
     * A well-formed Walkthrough of {@code views}, one sample run per entry of {@code runs} (each a list of frames, JSON
     * with single quotes for double): run n is labelled Example n, its sampleInput "in n" and expected "out n", every
     * frame given a caption and the last the answer.
     */
    private static ObjectNode walkthrough(String views, String... runs) throws Exception {
        ObjectNode walkthrough = (ObjectNode) fixture("{'format': 'walkthrough/1', 'title': 'Fixture', 'approach': 'Read each value once.', "
                + "'views': " + views + "}");
        ArrayNode all = walkthrough.putArray("runs");
        for (int r = 0; r < runs.length; r++) {
            int n = r + 1;
            ArrayNode frames = (ArrayNode) fixture(runs[r]);
            for (int f = 0; f < frames.size(); f++) {
                ((ObjectNode) frames.get(f)).putObject("caption").put("en", "Step " + (f + 1) + ".").put("ko", (f + 1) + "단계입니다.");
            }
            ((ObjectNode) frames.get(frames.size() - 1)).put("answer", "out " + n);
            ObjectNode run = all.addObject();
            run.putObject("label").put("en", "Example " + n).put("ko", "예시 " + n);
            run.put("sampleInput", "in " + n).put("expected", "out " + n).set("frames", frames);
        }
        return walkthrough;
    }

    /** The samples a {@link #walkthrough} of {@code count} runs shows: "in n" giving "out n". */
    private static List<Sample> samples(int count) {
        List<Sample> samples = new ArrayList<>();
        for (int n = 1; n <= count; n++) samples.add(new Sample("in " + n, "out " + n));
        return samples;
    }

    /** {@code breakage} to a fixture showing {@code samples} was caught, by a line naming it that says {@code expected}. */
    private static void assertCaught(JsonNode walkthrough, List<Sample> samples, String breakage, String expected) {
        List<String> found = mismatches("fixture", walkthrough, samples);
        assertTrue(found.stream().anyMatch(m -> m.startsWith("fixture: ") && m.contains(expected)),
                breakage + " was not caught as \"" + expected + "\": " + found);
    }

    // --- #273's two rules ------------------------------------------------------------------------------

    /**
     * #273's first rule: a frame shows where its step's value came from and where it went. Every place of every view
     * that takes addresses (the kit's address table) is compared with the frame before; a place that is new or holds
     * a new value has a move into it in that frame. What needs no move, as the rule allows:
     * <ul>
     *   <li>a step that only reads changes no place, so it needs none: its marks show what it read;</li>
     *   <li>a run's first frame is its setup, the data as read in;</li>
     *   <li>a value leaving a place is shown by its move out of the place, marked {@code bad} (a move with no
     *       {@code to} is {@code bad} by default): that excuses the place only when it is emptied (null, an empty
     *       string or list) or holds a smaller number (a count going down), never a value that grows or is replaced;
     *       a place that disappears needs none, since it stayed drawn for the step it left;</li>
     *   <li>a move out of a place reaches the places the address table says it carries its value on to (an edge's
     *       far end), as a relaxation draws a graph node's new cost.</li>
     * </ul>
     * A list by index (an array, an output, a queue) is compared both in place and as a sequence whose values shift
     * (a queue's front leaving, a value joining an end), whichever changes fewer places; a view hidden in a frame is
     * empty there, so everything it shows when it comes back is new.
     */
    @Test
    void everyPlaceThatChangesHasAMoveIntoIt() throws Exception {
        List<String> found = new ArrayList<>();
        for (String slug : WALKTHROUGHS.slugs()) {
            found.addAll(changesWithoutMoves(slug, JSON.readTree(WALKTHROUGHS.of(slug).orElseThrow())));
        }
        assertTrue(found.isEmpty(), "Places that change with no move into them (#273's first rule; the tracer adds "
                + "the move):\n" + String.join("\n", found));
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "array cell written in place              | array     | {'values': [1, 2]}            | {'values': [9, 2]}                        | []                                 | array \"v\" at 0 now holds 9",
            "array grown at its end                   | array     | {'values': [1, 2]}            | {'values': [1, 2, 3]}                     | []                                 | array \"v\" at 2 now holds 3",
            "map key added                            | map       | {'entries': []}               | {'entries': [{'key': 4, 'value': 1}]}     | []                                 | map \"v\" at 4 now holds 1",
            "count going down with a good move out    | map       | {'entries': [{'key': 'y', 'value': 2}]} | {'entries': [{'key': 'y', 'value': 1}]} | [{'from': {'view': 'v', 'at': 'y'}, 'mark': 'good'}] | map \"v\" at y now holds 1",
            "count going up with only a bad move out  | map       | {'entries': [{'key': 'y', 'value': 1}]} | {'entries': [{'key': 'y', 'value': 2}]} | [{'from': {'view': 'v', 'at': 'y'}}] | map \"v\" at y now holds 2",
            "cell written over with a bad move out    | grid      | {'cells': [[1, 2]]}           | {'cells': [[3, 2]]}                       | [{'from': {'view': 'v', 'at': [0, 0]}, 'mark': 'bad'}] | grid \"v\" at [0,0] now holds 3",
            "set member added                         | set       | {'members': [1]}              | {'members': [1, 5]}                       | []                                 | set \"v\" at 5 now holds 5",
            "queue value joining                      | queue     | {'values': [1]}               | {'values': [1, 2]}                        | []                                 | queue \"v\" at 1 now holds 2",
            "grid cell changed                        | grid      | {'cells': [[0, 0]]}           | {'cells': [[9, 0]]}                       | []                                 | grid \"v\" at [0,0] now holds 9",
            "output value appended                    | output    | {'values': []}                | {'values': [7]}                           | []                                 | output \"v\" at 0 now holds 7",
            "table cell written                       | table     | {'rows': [{'cells': [1, 2]}]} | {'rows': [{'cells': [1, 'x']}]}           | []                                 | table \"v\" at [0,1] now holds \"x\"",
            "interval added                           | intervals | {'groups': [{'intervals': []}]} | {'groups': [{'intervals': [[0, 1]]}]}   | []                                 | intervals \"v\" at [0,0] now holds [0,1]",
            "graph node value changed                 | graph     | {'nodes': [{'id': 'a'}, {'id': 'b'}], 'edges': [{'from': 'a', 'to': 'b'}]} | {'nodes': [{'id': 'a'}, {'id': 'b'}], 'edges': [{'from': 'a', 'to': 'b'}], 'values': {'b': 7}} | [] | graph \"v\" at b now holds 7",
    })
    void aChangeWithNoMoveIsCaught(String breakage, String type, String before, String after, String moves, String expected)
            throws Exception {
        List<String> found = changesWithoutMoves("fixture", step(type, before, after, moves));
        assertTrue(found.stream().anyMatch(m -> m.startsWith("fixture: ") && m.contains(expected)),
                breakage + " was not caught as \"" + expected + "\": " + found);
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "count going down with a bad move out     | map   | {'entries': [{'key': 'y', 'value': 2}]} | {'entries': [{'key': 'y', 'value': 1}]} | [{'from': {'view': 'v', 'at': 'y'}, 'mark': 'bad'}]",
            "key leaving with a dropped move          | map   | {'entries': [{'key': 'y', 'value': 1}, {'key': 'z', 'value': 1}]} | {'entries': [{'key': 'z', 'value': 1}]} | [{'from': {'view': 'v', 'at': 'y'}}]",
            "cell emptied with a bad move out         | table | {'rows': [{'cells': [1, [4]]}]} | {'rows': [{'cells': [1, []]}]} | [{'from': {'view': 'v', 'at': [0, 1]}, 'mark': 'bad'}]",
            "front leaving a queue                    | queue | {'values': [1, 2]}              | {'values': [2]}                | [{'from': {'view': 'v', 'at': 0}}]",
            "cost carried along an edge into its node | graph | {'nodes': [{'id': 'a'}, {'id': 'b'}], 'edges': [{'from': 'a', 'to': 'b'}]} | {'nodes': [{'id': 'a'}, {'id': 'b'}], 'edges': [{'from': 'a', 'to': 'b'}], 'values': {'b': 7}} | [{'from': {'view': 'v', 'at': ['a', 'b']}, 'mark': 'good'}]",
            "only read                                | array | {'values': [1, 2]}              | {'values': [1, 2], 'marks': {'lit': [0]}} | []",
    })
    void aChangeTheRuleAllowsPasses(String allowed, String type, String before, String after, String moves) throws Exception {
        assertEquals(List.of(), changesWithoutMoves("fixture", step(type, before, after, moves)), allowed);
    }

    /**
     * A Walkthrough of one view {@code v} of {@code type} over two frames, drawing {@code before} and then {@code after}
     * with {@code moves} (JSON, single quotes for double).
     */
    private static JsonNode step(String type, String before, String after, String moves) throws Exception {
        return fixture("{'views': [{'id': 'v', 'type': '" + type + "'}], 'runs': [{'label': 'Example 1', 'frames': ["
                + "{'views': {'v': " + before + "}}, {'views': {'v': " + after + "}, 'moves': " + moves + "}]}]}");
    }

    /** A Walkthrough written in a test, JSON with single quotes for double. */
    private static JsonNode fixture(String json) throws Exception {
        return JSON.readTree(json.replace('\'', '"'));
    }

    /** Each place of {@code walkthrough} that changes with no move into it, by #273's first rule. */
    static List<String> changesWithoutMoves(String slug, JsonNode walkthrough) {
        Map<String, String> types = new LinkedHashMap<>();
        for (JsonNode view : walkthrough.path("views")) {
            String type = view.path("type").asText();
            if (ADDRESSES.viewTypes().contains(type)) types.put(view.path("id").asText(), type);
        }
        List<String> found = new ArrayList<>();
        JsonNode runs = walkthrough.path("runs");
        for (int r = 0; r < runs.size(); r++) {
            JsonNode run = runs.get(r), frames = run.path("frames");
            Map<String, Map<String, JsonNode>> previous = new HashMap<>();
            for (int f = 0; f < frames.size(); f++) {
                JsonNode frame = frames.get(f);
                for (var view : types.entrySet()) {
                    String id = view.getKey(), type = view.getValue();
                    Optional<ObjectNode> state = WalkthroughAddresses.stateIn(id, run.path("setup"), frame.path("views"));
                    Map<String, JsonNode> now = state.map(s -> ADDRESSES.places(type, s)).orElse(Map.of());
                    Map<String, JsonNode> before = previous.put(id, now);
                    if (f == 0) continue;
                    for (String at : changed(type, before, now)) {
                        if (movedInto(frame, id, type, at, before.get(at), now.get(at))) continue;
                        found.add(slug + ": " + runName(run, r) + ", frame " + (f + 1) + ": " + type + " \"" + id
                                + "\" at " + at + " now holds " + now.get(at) + " with no move into it");
                    }
                }
            }
        }
        return found;
    }

    /**
     * The addresses of {@code now} that are new or hold a new value since {@code before}. A list by index is compared
     * in place and as a shifted sequence (its longest run of values in common with before kept, the rest new),
     * whichever finds fewer.
     */
    private static List<String> changed(String type, Map<String, JsonNode> before, Map<String, JsonNode> now) {
        List<String> inPlace = new ArrayList<>();
        now.forEach((at, value) -> {
            if (!value.equals(before.get(at))) inPlace.add(at);
        });
        if (!ADDRESSES.indexed(type)) return inPlace;
        List<JsonNode> b = new ArrayList<>(before.values()), a = new ArrayList<>(now.values());
        int length = 0, start = 0;
        for (int i = 0; i < b.size(); i++) {
            for (int j = 0; j < a.size(); j++) {
                int k = 0;
                while (i + k < b.size() && j + k < a.size() && b.get(i + k).equals(a.get(j + k))) k++;
                if (k > length) {
                    length = k;
                    start = j;
                }
            }
        }
        List<String> shifted = new ArrayList<>();
        for (int j = 0; j < a.size(); j++) if (j < start || j >= start + length) shifted.add(String.valueOf(j));
        return shifted.size() < inPlace.size() ? shifted : inPlace;
    }

    /**
     * Whether a move of {@code frame} reaches place {@code at} of view {@code id}, which held {@code was} (null when it
     * is new) and now holds {@code now}: one into it; one out of it marked {@code bad} when its value {@link #left};
     * or one out of a place that carries its value on to it (an edge into its node).
     */
    private static boolean movedInto(JsonNode frame, String id, String type, String at, JsonNode was, JsonNode now) {
        for (JsonNode move : frame.path("moves")) {
            JsonNode to = move.get("to"), from = move.get("from");
            if (to != null && id.equals(to.path("view").asText()) && at.equals(WalkthroughAddresses.address(to.get("at")))) {
                return true;
            }
            if (from == null || !id.equals(from.path("view").asText())) continue;
            boolean leaving = move.hasNonNull("mark") ? "bad".equals(move.get("mark").asText()) : to == null || to.isNull();
            if (leaving && left(was, now) && at.equals(WalkthroughAddresses.address(from.get("at")))) return true;
            if (ADDRESSES.onward(type, from.get("at")).contains(at)) return true;
        }
        return false;
    }

    /** Whether a place holding {@code was} and now {@code now} lost its value: emptied, or a count gone down. */
    private static boolean left(JsonNode was, JsonNode now) {
        if (now.isNull() || (now.isTextual() && now.asText().isEmpty()) || (now.isContainerNode() && now.size() == 0)) return true;
        return was != null && was.isNumber() && now.isNumber() && now.decimalValue().compareTo(was.decimalValue()) < 0;
    }

    /**
     * #273's second rule: a value with a place in the data is drawn there, and {@code vars} holds only values with none.
     * A {@code vars} item repeats a value drawn on the data in a run when, in every frame of that run that draws both
     * (two or more), the item's value is that value, and the item changes: takes two values or more in some run of the
     * Walkthrough, so a run where it happens to hold still is held to the rule too. The value drawn on the data is any place's
     * value in a view (a cell, a count per key, a member, a node's value), a pointer, a span's start, end or length, a
     * label under an array, or a whole list; or one derived from these ({@link #onTheData}); or, following none, one of
     * them a frame early or late, in every pair of frames that draws both (two pairs or more), a tracer updating
     * {@code vars} before or after the data. An item that keeps one value is a parameter such as {@code k}, which
     * equals some number in the data by chance. An item that should stay anyway carries a {@code why}, its reason
     * (references/format.md) on any of its frames, which excuses it in every run; a {@code why} on an item that repeats
     * nothing in any run fails, so a stale one goes.
     */
    @Test
    void noVarsItemRepeatsAValueDrawnOnTheData() throws Exception {
        List<String> found = new ArrayList<>();
        for (String slug : WALKTHROUGHS.slugs()) {
            found.addAll(varsRepeatingTheData(slug, JSON.readTree(WALKTHROUGHS.of(slug).orElseThrow())));
        }
        assertTrue(found.isEmpty(), "vars items that repeat a value drawn on the data (#273's second rule; draw it "
                + "there and drop the item, or give the item a why):\n" + String.join("\n", found));
    }

    /**
     * A Walkthrough for #273's second rule: an array {@code xs} holding a 9 at the frame's index, whose pointer
     * {@code right} and span {@code best} grow by one each frame, a map {@code counts} whose key {@code y} counts up beside them by more than one (1, 3, 6, so a
     * value a frame out of step is not also one off), and a {@code vars} view {@code state} for the items a test adds.
     * Its second run holds still, with no span and no 9: {@code right} at 0 and {@code y} at 4.
     */
    private static ObjectNode varsFixture() throws Exception {
        StringBuilder first = new StringBuilder();
        for (int f = 0; f < 3; f++) {
            List<Integer> xs = new ArrayList<>(List.of(5, 6, 7, 8));
            xs.set(f, 9);
            first.append(f == 0 ? "" : ", ").append("{'views': {'xs': {'values': ").append(xs).append(", 'pointers': {'right': ").append(f)
                    .append("}, 'spans': {'best': {'from': 0, 'to': ").append(f).append("}}}, 'counts': {'entries': [{'key': 'y', 'value': ")
                    .append(triangle(f + 1)).append("}]}, 'state': {'items': []}}}");
        }
        String still = "{'views': {'xs': {'values': [5, 6, 7, 8], 'pointers': {'right': 0}}, 'counts': {'entries': [{'key': 'y', "
                + "'value': 4}]}, 'state': {'items': []}}}";
        return (ObjectNode) fixture("{'views': [{'id': 'xs', 'type': 'array'}, {'id': 'counts', 'type': 'map'}, "
                + "{'id': 'state', 'type': 'vars'}], 'runs': [{'label': 'Example 1', 'frames': [" + first + "]}, "
                + "{'label': 'Example 2', 'frames': [" + still + ", " + still + "]}]}");
    }

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', quoteCharacter = '`', value = {
            "item following a pointer                   | run 1 (Example 1): vars \"state\" item \"right\" repeats | pointer \"right\" of array \"xs\"",
            "item following the best's length           | run 1 (Example 1): vars \"state\" item \"best\" repeats  | span \"best\"'s length on array \"xs\"",
            "item following a count per key             | run 1 (Example 1): vars \"state\" item \"count\" repeats | a value in map \"counts\"",
            "item changing in one run, repeating in one | run 2 (Example 2): vars \"state\" item \"count\" repeats | a value in map \"counts\"",
            "item with a why repeating nothing          | vars \"state\" item \"limit\" has a why | repeats no value drawn on the data",
            "item a frame late                          | run 1 (Example 1): vars \"state\" item \"late\" repeats  | a value in map \"counts\", a frame late",
            "item a frame early                         | run 1 (Example 1): vars \"state\" item \"early\" repeats | a value in map \"counts\", a frame early",
            "item a pointer plus 1                      | run 1 (Example 1): vars \"state\" item \"r\" repeats     | pointer \"right\" of array \"xs\", plus 1",
            "item a span's exclusive length             | run 1 (Example 1): vars \"state\" item \"width\" repeats | span \"best\"'s exclusive length on array \"xs\"",
            "item a list in another order               | run 1 (Example 1): vars \"state\" item \"sorted\" repeats | the values of array \"xs\", in another order",
    })
    void aVarsItemRepeatingTheDataIsCaught(String breakage, String item, String expected) throws Exception {
        ObjectNode walkthrough = varsFixture();
        switch (breakage) {
            case "item following a pointer" -> addItem(walkthrough, "right", s -> s.path("xs").path("pointers").get("right"), null);
            case "item following the best's length" -> addItem(walkthrough, "best", s -> {
                JsonNode best = s.path("xs").path("spans").get("best");
                return best == null || best.isNull() ? null : JSON.getNodeFactory().numberNode(best.get("to").asInt() - best.get("from").asInt() + 1);
            }, null);
            case "item following a count per key" -> addItem(walkthrough, "count", WalkthroughsMatchSamplesTest::countOfY, null);
            // Example 1: 10, 11, 12, drawn nowhere; Example 2: y's 4 in both frames, one value there
            case "item changing in one run, repeating in one" -> addItem(walkthrough, "count", s -> s.path("xs").path("spans").has("best")
                    ? JSON.getNodeFactory().numberNode(10 + s.path("xs").path("pointers").path("right").asInt()) : countOfY(s), null);
            case "item with a why repeating nothing" -> addItem(walkthrough, "limit", s -> JSON.getNodeFactory().numberNode(-7),
                    "a number from nowhere");
            // y's count is 1, 3, 6: late shows 0, 1, 3 and early 3, 6, 10
            case "item a frame late" -> addItem(walkthrough, "late", s -> inFirstRun(s, f -> triangle(f)), null);
            case "item a frame early" -> addItem(walkthrough, "early", s -> inFirstRun(s, f -> triangle(f + 2)), null);
            // a 1-based position beside the 0-based pointer
            case "item a pointer plus 1" -> addItem(walkthrough, "r", s -> inFirstRun(s, f -> f + 1), null);
            // best runs 0 to f: f - 0, which is also where right points
            case "item a span's exclusive length" -> addItem(walkthrough, "width", s -> inFirstRun(s, f -> f), null);
            case "item a list in another order" -> addItem(walkthrough, "sorted", s -> {
                if (!s.path("xs").path("spans").has("best")) return null;
                List<Integer> xs = new ArrayList<>();
                s.path("xs").path("values").forEach(x -> xs.add(x.asInt()));
                xs.sort(null);
                return JSON.valueToTree(xs);
            }, null);
            default -> throw new IllegalArgumentException(breakage);
        }
        List<String> found = varsRepeatingTheData("fixture", walkthrough);
        assertTrue(found.stream().anyMatch(m -> m.startsWith("fixture: ") && m.contains(item) && m.contains(expected)),
                breakage + " was not caught as " + item + " … " + expected + ": " + found);
    }

    /** The {@code n}th triangle number, y's count in frame {@code n - 1} of the fixture's first run. */
    private static int triangle(int n) {
        return n * (n + 1) / 2;
    }

    /** In the fixture's first run (the one with a span), {@code value} of the frame's index; nothing in the second. */
    private static JsonNode inFirstRun(JsonNode states, java.util.function.IntUnaryOperator value) {
        if (!states.path("xs").path("spans").has("best")) return null;
        return JSON.getNodeFactory().numberNode(value.applyAsInt(states.path("xs").path("pointers").path("right").asInt()));
    }

    /** Key {@code y}'s count in the fixture's map {@code counts}, from a frame's states by view id. */
    private static JsonNode countOfY(JsonNode states) {
        for (JsonNode e : states.path("counts").path("entries")) if ("y".equals(e.path("key").asText())) return e.get("value");
        return null;
    }

    @Test
    void aVarsItemWithAWhyOrKeepingOneValueIsLetThrough() throws Exception {
        ObjectNode walkthrough = varsFixture();
        addItem(walkthrough, "right", s -> s.path("xs").path("pointers").get("right"), "the index the captions name");
        addItem(walkthrough, "first", s -> JSON.getNodeFactory().numberNode(5), null);
        // a parameter equal to right plus 1 in frame 0 and to best's exclusive length in frame 1, by chance: it never changes
        addItem(walkthrough, "k", s -> JSON.getNodeFactory().numberNode(1), null);
        // a why kept by new forms alone: right minus 1, which is also right a frame late
        addItem(walkthrough, "position", s -> inFirstRun(s, f -> f - 1), "the index before right, which the captions name");
        // drawn in frames 0 and 1 only, where frame 1 holds y's count from frame 0: one pair of frames, so by chance
        addItem(walkthrough, "once", s -> s.path("xs").path("pointers").path("right").asInt() == 2 ? null
                : inFirstRun(s, f -> f == 0 ? 42 : triangle(1)), null);
        assertEquals(List.of(), varsRepeatingTheData("fixture", walkthrough));
    }

    @Test
    void aWhyThatIsNotAReasonIsCaught() throws Exception {
        ObjectNode walkthrough = varsFixture();
        addItem(walkthrough, "limit", s -> JSON.getNodeFactory().numberNode(2), " ");
        List<String> found = mismatches("fixture", walkthrough, null);
        assertTrue(found.stream().anyMatch(m -> m.contains("item \"limit\": why must be a non-empty string")), found.toString());
    }

    /**
     * Adds an item labelled {@code label} to the first {@code vars} view of every frame of {@code walkthrough} where
     * {@code value} gives one from the frame's states (by view id), with {@code why} when not null.
     */
    private static void addItem(JsonNode walkthrough, String label, Function<JsonNode, JsonNode> value, String why) {
        String vars = null;
        for (JsonNode view : walkthrough.path("views")) {
            if (vars == null && "vars".equals(view.path("type").asText())) vars = view.path("id").asText();
        }
        assertNotNull(vars, "no vars view to add an item to");
        for (JsonNode run : walkthrough.path("runs")) {
            for (JsonNode frame : run.get("frames")) {
                ObjectNode states = JSON.createObjectNode();
                for (JsonNode view : walkthrough.path("views")) {
                    String id = view.path("id").asText();
                    WalkthroughAddresses.stateIn(id, run.path("setup"), frame.path("views")).ifPresent(st -> states.set(id, st.deepCopy()));
                }
                JsonNode v = value.apply(states);
                if (v == null || v.isNull()) continue;
                ObjectNode state = states.has(vars) ? (ObjectNode) states.get(vars) : JSON.createObjectNode();
                ArrayNode items = state.has("items") ? (ArrayNode) state.get("items") : state.putArray("items");
                ObjectNode item = items.addObject().put("label", label).set("value", v);
                if (why != null) item.put("why", why);
                (frame.has("views") ? (ObjectNode) frame.get("views") : ((ObjectNode) frame).putObject("views")).set(vars, state);
            }
        }
    }

    /** A frame drawing a {@code vars} item: its index in the run, the item's value there, and its {@link #inOrder} when it is a list. */
    private record Sighting(int frame, String value, String inOrder) {
        boolean in(Set<String> drawn) {
            return drawn.contains(value) || inOrder != null && drawn.contains(inOrder);
        }
    }

    /** A frame's values drawn on the data, by what draws them: as drawn, and derived from what is drawn. */
    private record Drawn(Map<String, Set<String>> asDrawn, Map<String, Set<String>> derived) {
    }

    /** A {@code vars} item over the Walkthrough: its frames by run (in run order), and whether any carries a why. */
    private static final class Item {
        final Map<Integer, List<Sighting>> byRun = new LinkedHashMap<>();
        boolean why;

        /** Whether the item takes two values or more in some run. */
        boolean changes() {
            return byRun.values().stream().anyMatch(frames -> frames.stream().map(Sighting::value).distinct().count() >= 2);
        }
    }

    /** How an item's frame lines up with the frame of the data it is compared with: the same, the one before, the one after. */
    private enum Shift {
        NONE(0, ""), LATE(-1, ", a frame late"), EARLY(1, ", a frame early");

        final int offset;
        final String named;

        Shift(int offset, String named) {
            this.offset = offset;
            this.named = named;
        }
    }

    /** Each {@code vars} item of {@code walkthrough} that repeats a value drawn on the data, by #273's second rule. */
    static List<String> varsRepeatingTheData(String slug, JsonNode walkthrough) {
        Map<String, String> types = new LinkedHashMap<>();
        for (JsonNode view : walkthrough.path("views")) types.put(view.path("id").asText(), view.path("type").asText());
        Map<String, Item> items = new LinkedHashMap<>();
        List<List<Drawn>> drawnByRun = new ArrayList<>();
        JsonNode runs = walkthrough.path("runs");
        for (int r = 0; r < runs.size(); r++) {
            JsonNode run = runs.get(r);
            List<Drawn> frames = new ArrayList<>();
            drawnByRun.add(frames);
            for (JsonNode frame : run.path("frames")) {
                Drawn drawn = new Drawn(new LinkedHashMap<>(), new LinkedHashMap<>());
                List<Map.Entry<String, JsonNode>> vars = new ArrayList<>();
                for (var view : types.entrySet()) {
                    Optional<ObjectNode> state = WalkthroughAddresses.stateIn(view.getKey(), run.path("setup"), frame.path("views"));
                    if (state.isEmpty()) continue;
                    if ("vars".equals(view.getValue())) {
                        for (JsonNode item : state.get().path("items")) vars.add(Map.entry(view.getKey(), item));
                    } else {
                        onTheData(view.getKey(), view.getValue(), state.get(), drawn);
                    }
                }
                for (var var : vars) {
                    String name = "vars \"" + var.getKey() + "\" item \"" + plain(var.getValue().get("label")) + "\"";
                    Item item = items.computeIfAbsent(name, k -> new Item());
                    item.byRun.computeIfAbsent(r, k -> new ArrayList<>()).add(new Sighting(frames.size(), value(var.getValue().get("value")),
                            var.getValue().path("value").isArray() ? inOrder(var.getValue().get("value")) : null));
                    item.why |= var.getValue().hasNonNull("why");
                }
                frames.add(drawn);
            }
        }
        List<String> found = new ArrayList<>();
        items.forEach((name, item) -> {
            boolean repeatsAny = false;
            for (var run : item.byRun.entrySet()) {
                List<String> repeats = item.changes() ? repeats(run.getValue(), drawnByRun.get(run.getKey())) : List.of();
                repeatsAny |= !repeats.isEmpty();
                if (!item.why && !repeats.isEmpty()) {
                    found.add(slug + ": " + runName(runs.get(run.getKey()), run.getKey()) + ": " + name + " repeats "
                            + String.join(" and ", repeats) + " in every frame that draws both");
                }
            }
            if (item.why && !repeatsAny) found.add(slug + ": " + name + " has a why but repeats no value drawn on the data: drop the why");
        });
        return found;
    }

    /**
     * The values drawn on the data an item follows in a run whose frames draw {@code drawn}: those that hold its value,
     * as drawn or {@linkplain #derive derived}, in every frame of the run that draws both, two or more. When it follows
     * none, those drawn a frame out of step from it in every pair of frames that draws both, two pairs or more: a
     * pointer moving by one each frame is a frame out of step from itself plus or minus 1, which is named instead.
     */
    private static List<String> repeats(List<Sighting> frames, List<Drawn> drawn) {
        List<String> repeats = follows(frames, drawn, Drawn::asDrawn, Shift.NONE);
        for (String derived : follows(frames, drawn, Drawn::derived, Shift.NONE)) {
            // a list in another order is named only when the item isn't the list in the same order
            if (repeats.stream().noneMatch(r -> derived.startsWith(r + ", "))) repeats.add(derived);
        }
        if (!repeats.isEmpty()) return repeats;
        repeats.addAll(follows(frames, drawn, Drawn::asDrawn, Shift.LATE));
        repeats.addAll(follows(frames, drawn, Drawn::asDrawn, Shift.EARLY));
        return repeats;
    }

    /** The values in {@code which} of {@code drawn} that hold the item's value {@code shift}ed, in every frame (or pair) that draws both, two or more. */
    private static List<String> follows(List<Sighting> frames, List<Drawn> drawn, Function<Drawn, Map<String, Set<String>>> which, Shift shift) {
        Set<String> sources = new LinkedHashSet<>();
        for (Drawn frame : drawn) sources.addAll(which.apply(frame).keySet());
        List<String> follows = new ArrayList<>();
        for (String source : sources) {
            int both = 0;
            boolean every = true;
            for (Sighting sighting : frames) {
                int at = sighting.frame() + shift.offset;
                Set<String> there = at < 0 || at >= drawn.size() ? null : which.apply(drawn.get(at)).get(source);
                if (there == null) continue;
                both++;
                every &= sighting.in(there);
            }
            if (every && both >= 2) follows.add(source + shift.named);
        }
        return follows;
    }

    /**
     * Adds to {@code into} each value view {@code id}'s state draws on the data, by what it is, and each derived from
     * one: a pointer or a span's start or end plus or minus 1 (a 1-based position beside a 0-based pointer), a span's
     * exclusive length ({@code to - from}), and a whole list in another order. A part of a list is not derived: nearly
     * any short list is part of a longer one.
     */
    private static void onTheData(String id, String type, JsonNode state, Drawn into) {
        Map<String, Set<String>> drawn = into.asDrawn(), derived = into.derived();
        String of = type + " \"" + id + "\"";
        Map<String, JsonNode> places = ADDRESSES.places(type, state);
        if (!places.isEmpty()) {
            Set<String> values = new HashSet<>();
            places.values().forEach(v -> values.add(value(v)));
            drawn.put("a value in " + of, values);
        }
        if (ADDRESSES.indexed(type)) {
            drawn.put("the values of " + of, Set.of(value(state.path("values"))));
            derived.put("the values of " + of + ", in another order", Set.of(inOrder(state.path("values"))));
        }
        state.path("pointers").fields().forEachRemaining(p -> {
            if (p.getValue().isNull()) return;
            String name = "pointer \"" + p.getKey() + "\" of " + of;
            drawn.put(name, Set.of(value(p.getValue())));
            if (p.getValue().isIntegralNumber()) oneOff(name, p.getValue().asLong(), derived);
        });
        state.path("spans").fields().forEachRemaining(named -> {
            JsonNode span = named.getValue();
            if (span.isNull()) return;
            String name = "span \"" + named.getKey() + "\"'s ";
            int from = span.path("from").asInt(), to = span.path("to").asInt();
            drawn.put(name + "start on " + of, Set.of(String.valueOf(from)));
            drawn.put(name + "end on " + of, Set.of(String.valueOf(to)));
            drawn.put(name + "length on " + of, Set.of(String.valueOf(to - from + 1)));
            oneOff(name + "start on " + of, from, derived);
            oneOff(name + "end on " + of, to, derived);
            derived.put(name + "exclusive length on " + of, Set.of(String.valueOf(to - from)));
        });
        if (state.path("under").isArray() && !state.path("under").isEmpty()) {
            Set<String> labels = new HashSet<>();
            for (JsonNode under : state.path("under")) labels.add(value(under.path(1)));
            drawn.put("a label under " + of, labels);
        }
    }

    /** Adds {@code drawn}, the number {@code name} draws, plus 1 and minus 1 to {@code derived}. */
    private static void oneOff(String name, long drawn, Map<String, Set<String>> derived) {
        derived.put(name + ", plus 1", Set.of(String.valueOf(drawn + 1)));
        derived.put(name + ", minus 1", Set.of(String.valueOf(drawn - 1)));
    }

    /** A list's values (each by {@link #value}) sorted, so two lists holding the same values in any order have the same one. */
    private static String inOrder(JsonNode list) {
        List<String> values = new ArrayList<>();
        list.forEach(v -> values.add(value(v)));
        values.sort(null);
        return "in order: " + values;
    }

    /** A value as the drawing shows it: a string or a number by its text, anything else as JSON. */
    private static String value(JsonNode v) {
        if (v == null) return "null";
        return v.isTextual() || v.isNumber() ? v.asText() : v.toString();
    }

    /** A label's English text, or the label itself. */
    private static String plain(JsonNode label) {
        return label == null ? "?" : label.isTextual() ? label.asText() : label.path("en").asText(label.toString());
    }

    @Test
    void textDifferingOnlyInSurroundingWhitespaceMatchesAsTheGraderComparesIt() throws Exception {
        List<Sample> samples = samples(3);
        List<Sample> padded = List.of(new Sample(samples.get(0).input() + "\n", samples.get(0).expected()),
                samples.get(1), new Sample(samples.get(2).input(), " " + samples.get(2).expected() + "\n"));
        List<String> found = mismatches("fixture", samplesFixture(), padded);
        assertTrue(found.isEmpty(), String.join("\n", found));
    }

    @Test
    void sentencesEndAtAStopBeforeMoreTextNotAtADecimalOrAnAbbreviation() {
        assertEquals(1, sentences("Take 1.5 of them, e.g. the first, i.e. the stale one."));
        assertEquals(2, sentences("Seat 7: a run starts here. Is 3 > 0? "));
        assertEquals(3, sentences("k = 4. Read left to right! Answer 2."));
    }

    @Test
    void aWalkthroughForNoProblemIsCaught() throws Exception {
        List<String> found = mismatches("no-such-problem", samplesFixture(), null);
        assertTrue(found.stream().anyMatch(m -> m.contains("no problem has this Slug")), found.toString());
    }

    @Test
    void anExtraRunAfterTheSamplesPasses() throws Exception {
        ObjectNode walkthrough = samplesFixture();
        ObjectNode extra = ((ArrayNode) walkthrough.get("runs")).addObject();
        extra.put("label", "All fresh").put("input", "ward = [[1]]").put("expected", "-1").put("extra", true);
        extra.putArray("frames").addObject().put("caption", "No stale donut: -1.").put("answer", "-1");
        List<String> found = mismatches("fixture", walkthrough, samples(3));
        assertTrue(found.isEmpty(), String.join("\n", found));
    }

    // --- the checks --------------------------------------------------------------------------------

    /** Everything wrong with {@code slug}'s Walkthrough, each line naming the Slug; samples null: no problem. */
    static List<String> mismatches(String slug, JsonNode walkthrough, List<Sample> samples) {
        List<String> found = new ArrayList<>();
        structure(walkthrough).forEach(problem -> found.add(slug + ": " + problem));
        if (samples == null) {
            found.add(slug + ": no problem has this Slug after the migrations (a Restatement without the git mv "
                    + "of walkthroughs/<slug>.json?)");
            return found;
        }
        JsonNode runs = walkthrough.path("runs");
        int sampleRuns = 0;
        boolean afterExtra = false;
        for (int r = 0; r < runs.size(); r++) {
            JsonNode run = runs.get(r);
            String at = slug + ": " + runName(run, r) + ": ";
            if (run.path("extra").asBoolean(false)) {
                afterExtra = true;
                if (run.has("sampleInput")) found.add(at + "is marked extra but has a sampleInput");
                continue;
            }
            if (afterExtra) found.add(at + "is a sample run after an extra run; extra runs go after the sample runs");
            if (sampleRuns == samples.size()) {
                found.add(at + "is not marked extra, but the problem has only " + samples.size() + " samples");
                continue;
            }
            Sample sample = samples.get(sampleRuns++);
            JsonNode sampleInput = run.get("sampleInput");
            if (sampleInput == null || !sampleInput.isTextual()) {
                found.add(at + "has no sampleInput text; sample " + sampleRuns + "'s input is " + quote(sample.input()));
            } else if (!sampleInput.asText().trim().equals(sample.input().trim())) {
                found.add(at + "sampleInput is " + quote(sampleInput.asText()) + ", sample " + sampleRuns
                        + "'s input is " + quote(sample.input()));
            }
            JsonNode expected = run.get("expected");
            if (expected == null || !expected.isTextual()) {
                found.add(at + "expected is " + expected + ", not text; sample " + sampleRuns
                        + "'s expected output is " + quote(sample.expected()));
            } else if (!expected.asText().trim().equals(sample.expected().trim())) {
                found.add(at + "expected is " + quote(expected.asText()) + ", sample " + sampleRuns
                        + "'s expected output is " + quote(sample.expected()));
            }
        }
        for (int s = sampleRuns; s < samples.size(); s++) {
            found.add(slug + ": sample " + (s + 1) + " (input " + quote(samples.get(s).input())
                    + ", expected output " + quote(samples.get(s).expected()) + ") has no run");
        }
        return found;
    }

    /**
     * Each sample run of {@code walkthrough} labelled against its problem's {@code descriptions} (by language): run N is
     * "Example N" ("예시 N") exactly when the description has {@code **Example N:**} ({@code **예시 N:**}), and "Case N"
     * ("케이스 N") otherwise; a language with no description follows the English one's Examples. Extra runs are labelled
     * freely; descriptions null: no problem, reported by {@link #mismatches}.
     */
    static List<String> labelMismatches(String slug, JsonNode walkthrough, Map<String, String> descriptions) {
        List<String> found = new ArrayList<>();
        if (descriptions == null) return found;
        JsonNode runs = walkthrough.path("runs");
        int n = 0;
        for (int r = 0; r < runs.size(); r++) {
            JsonNode run = runs.get(r);
            if (run.path("extra").asBoolean(false)) continue;
            n++;
            Map<String, String> labels = run.get("label") == null ? Map.of() : texts(run.get("label"));
            for (String language : List.of("en", "ko")) {
                // With no description in a language, its labels follow the English one's Examples: the same samples
                String shownIn = descriptions.containsKey(language) ? language : "en";
                String example = "**" + EXAMPLE_WORD.get(shownIn) + " " + n + ":**";
                boolean shown = descriptions.getOrDefault(shownIn, "").contains(example);
                String expected = (shown ? EXAMPLE_WORD : CASE_WORD).get(language) + " " + n;
                String label = labels.get(language);
                if (!expected.equals(label)) {
                    found.add(slug + ": " + runName(run, r) + ": " + language + " label is " + (label == null ? "missing" : quote(label))
                            + ", not " + quote(expected) + ": the description has " + (shown ? "" : "no ") + example);
                }
            }
        }
        return found;
    }

    /** What breaks the {@code walkthrough/1} format, as the skill's {@code scripts/validate.mjs} checks it. */
    private static List<String> structure(JsonNode wt) {
        List<String> p = new ArrayList<>();
        if (!"walkthrough/1".equals(wt.path("format").asText(null))) {
            p.add("format is " + wt.get("format") + ", expected \"walkthrough/1\"");
        }
        if (!isText(wt.get("title"))) p.add("title missing");
        if (!isText(wt.get("approach"))) p.add("approach missing");
        Map<String, JsonNode> views = new HashMap<>();
        for (JsonNode view : wt.path("views")) {
            String id = view.path("id").asText("");
            if (id.isEmpty()) p.add("a view has no id");
            if (views.put(id, view) != null) p.add("view id \"" + id + "\" repeats");
            if (!VIEW_TYPES.contains(view.path("type").asText())) {
                p.add("view \"" + id + "\": unknown type " + view.get("type") + " (one of " + VIEW_TYPES + ")");
            }
            if ("queue".equals(view.path("type").asText()) && view.has("deque") && !view.get("deque").isBoolean()) {
                p.add("view \"" + id + "\": deque must be true or false");
            }
            if ("grid".equals(view.path("type").asText()) && view.has("boxes")
                    && !(view.get("boxes").isIntegralNumber() && view.get("boxes").asLong() >= 1)) {
                p.add("view \"" + id + "\": boxes must be a whole number of cells, 1 or more");
            }
        }
        if (views.isEmpty()) p.add("no views");
        JsonNode runs = wt.path("runs");
        if (runs.isEmpty()) p.add("no runs");
        for (int r = 0; r < runs.size(); r++) {
            JsonNode run = runs.get(r);
            String name = runName(run, r);
            if (!isText(run.get("label"))) p.add(name + ": label missing");
            if (!run.has("expected")) p.add(name + ": expected missing");
            run.path("setup").fieldNames().forEachRemaining(id -> {
                if (!views.containsKey(id)) p.add(name + " setup: unknown view \"" + id + "\"");
            });
            JsonNode frames = run.path("frames");
            if (frames.isEmpty()) {
                p.add(name + ": no frames");
                continue;
            }
            for (int f = 0; f < frames.size(); f++) {
                JsonNode frame = frames.get(f);
                String at = name + " frame " + (f + 1) + " of " + frames.size();
                if (!isText(frame.get("caption")) || !hasText(frame.get("caption"))) {
                    p.add(at + ": caption missing");
                } else {
                    texts(frame.get("caption")).forEach((language, caption) -> {
                        if (sentences(caption) > MAX_CAPTION_SENTENCES) {
                            p.add(at + ": " + language + " caption has " + sentences(caption) + " sentences, at most "
                                    + MAX_CAPTION_SENTENCES + ": " + quote(caption));
                        }
                    });
                }
                JsonNode moves = frame.get("moves");
                if (moves != null && !moves.isArray()) {
                    p.add(at + ": moves is not a list");
                } else if (moves != null) {
                    for (int m = 0; m < moves.size(); m++) {
                        for (String problem : move(moves.get(m), views, run.path("setup"), frame.path("views"))) {
                            p.add(at + " move " + m + ": " + problem);
                        }
                    }
                }
                if (frame.has("answer") && f != frames.size() - 1) {
                    p.add(at + ": answer " + frame.get("answer") + " on a frame before the last; only the last "
                            + "frame carries the answer");
                }
                var states = frame.path("views").fields();
                while (states.hasNext()) {
                    var state = states.next();
                    JsonNode view = views.get(state.getKey());
                    if (view == null) {
                        p.add(at + ": unknown view \"" + state.getKey() + "\"");
                        continue;
                    }
                    ObjectNode merged = JSON.createObjectNode();
                    if (run.path("setup").get(state.getKey()) instanceof ObjectNode setup) merged.setAll(setup);
                    if (state.getValue() instanceof ObjectNode own) merged.setAll(own);
                    for (String problem : view(view.path("type").asText(), merged)) {
                        p.add(at + " view \"" + state.getKey() + "\": " + problem);
                    }
                }
            }
            JsonNode last = frames.get(frames.size() - 1);
            if (!last.has("answer")) {
                p.add(name + ": the last frame has no answer");
            } else if (!sameAnswer(last.get("answer"), run.get("expected"))) {
                p.add(name + ": the last frame's answer is " + last.get("answer") + ", the run's expected is "
                        + run.get("expected"));
            }
        }
        return p;
    }

    private static final List<String> MOVE_MARKS = List.of("good", "bad", "path");

    /**
     * What is wrong with one move: its mark, and each end it has naming a place that exists in that frame's state of its
     * view, by the kit's address table ({@link WalkthroughAddresses}).
     */
    private static List<String> move(JsonNode move, Map<String, JsonNode> views, JsonNode setup, JsonNode states) {
        if (!move.isObject() || (!move.hasNonNull("from") && !move.hasNonNull("to"))) return List.of("no from and no to");
        List<String> p = new ArrayList<>();
        unknownMark(move.get("mark"), MOVE_MARKS).ifPresent(p::add);
        for (String end : List.of("from", "to")) {
            JsonNode address = move.get(end);
            if (address != null && !address.isNull()) p.addAll(ADDRESSES.problems(end, address, views, setup, states));
        }
        return p;
    }

    /** "unknown mark …" when {@code mark} is given and isn't one of {@code known}. */
    private static Optional<String> unknownMark(JsonNode mark, List<String> known) {
        return mark != null && !mark.isNull() && !known.contains(mark.asText())
                ? Optional.of("unknown mark " + mark + " (one of " + known + ")")
                : Optional.empty();
    }

    /**
     * The distinct keys of {@code items} by {@code key} (a string or a number, {@code 4} and {@code "4"} one key),
     * adding to {@code p} each that isn't one and each that repeats, named as a {@code noun}.
     */
    private static Set<String> distinct(JsonNode items, UnaryOperator<JsonNode> key, String noun,
                                        List<String> p) {
        Set<String> seen = new HashSet<>();
        for (JsonNode item : items) {
            String k = key(key.apply(item));
            if (k == null) p.add(noun + " " + key.apply(item) + " is not a string or a number");
            else if (!seen.add(k)) p.add(noun + " " + k + " repeats");
        }
        return seen;
    }

    /** Whether {@code i} is an index into the list {@code list}. */
    private static boolean index(JsonNode i, JsonNode list) {
        return i != null && i.isInt() && i.asInt() >= 0 && list.isArray() && i.asInt() < list.size();
    }

    /** A map key as the player compares it: a string or a number, by its text. Null for anything else. */
    private static String key(JsonNode k) {
        return k != null && (k.isTextual() || k.isNumber()) ? k.asText() : null;
    }

    /** Text compared trimmed, as the Grader compares output; anything else as JSON. */
    private static boolean sameAnswer(JsonNode answer, JsonNode expected) {
        if (answer.isTextual() && expected != null && expected.isTextual()) {
            return answer.asText().trim().equals(expected.asText().trim());
        }
        return answer.equals(expected);
    }

    private static List<String> view(String type, JsonNode s) {
        return switch (type) {
            case "grid" -> {
                JsonNode cells = s.get("cells");
                if (cells == null || !cells.isArray() || cells.isEmpty() || !allRows(cells)) {
                    yield List.of("cells must be a rectangular 2D list");
                }
                int rows = cells.size(), cols = cells.get(0).size();
                Predicate<JsonNode> inside = k -> k.isArray() && k.size() >= 2 && k.get(0).isInt() && k.get(1).isInt()
                        && k.get(0).asInt() >= 0 && k.get(0).asInt() < rows && k.get(1).asInt() >= 0
                        && k.get(1).asInt() < cols;
                List<String> p = marks(s.get("marks"), inside, "cell [r, c]");
                for (JsonNode tag : s.path("tags")) if (!inside.test(tag)) p.add("tag " + tag + " is outside the grid");
                for (JsonNode cell : s.path("shade")) if (!inside.test(cell)) p.add("shade names " + cell + ", not a cell [r, c]");
                yield p;
            }
            case "array" -> {
                JsonNode values = s.get("values");
                if (values == null || !values.isArray()) yield List.of("values must be a list");
                Predicate<JsonNode> inside = i -> i.isInt() && i.asInt() >= 0 && i.asInt() < values.size();
                List<String> p = marks(s.get("marks"), inside, "index");
                s.path("pointers").fields().forEachRemaining(ptr -> {
                    if (!ptr.getValue().isNull() && !inside.test(ptr.getValue())) {
                        p.add("pointer " + ptr.getKey() + " = " + ptr.getValue() + " is outside the array");
                    }
                });
                if (s.has("fill") && s.get("fill").size() != values.size()) p.add("fill and values differ in length");
                for (JsonNode tag : s.path("tags")) if (!inside.test(tag.path(0))) p.add("tag " + tag + " is outside the array");
                s.path("spans").fields().forEachRemaining(named -> {
                    JsonNode span = named.getValue();
                    if (span.isNull()) return;
                    JsonNode from = span.path("from"), to = span.path("to");
                    if (!inside.test(from) || !inside.test(to) || from.asInt() > to.asInt()) {
                        p.add("span \"" + named.getKey() + "\" (" + from + ".." + to + ") is outside the array");
                    }
                    unknownMark(span.get("mark"), MARKS).ifPresent(m -> p.add("span \"" + named.getKey() + "\" has " + m));
                    if (span.has("label") && !isText(span.get("label"))) p.add("span \"" + named.getKey() + "\" has a label that is not Text");
                });
                for (JsonNode i : s.path("unread")) if (!inside.test(i)) p.add("unread names " + i + ", not an index");
                for (JsonNode under : s.path("under")) if (!inside.test(under.path(0))) p.add("label under " + under + " is outside the array");
                yield p;
            }
            case "map" -> {
                JsonNode entries = s.get("entries");
                if (entries == null || !entries.isArray()) yield List.of("entries must be a list of { key, value }");
                List<String> p = new ArrayList<>();
                Set<String> seen = distinct(entries, entry -> entry.get("key"), "key", p);
                for (JsonNode entry : entries) {
                    String k = key(entry.get("key"));
                    if (entry.hasNonNull("label") && !isText(entry.get("label"))) p.add("entry " + k + " has a label that is not Text");
                    JsonNode chips = entry.path("value");
                    if (entry.has("marks")) {
                        for (String m : marks(entry.get("marks"), i -> index(i, chips), "chip index")) p.add("entry " + k + ": " + m);
                    }
                }
                p.addAll(marks(s.get("marks"), k -> seen.contains(key(k)), "key"));
                JsonNode slots = s.get("slots");
                if (slots != null && !(slots.isIntegralNumber() && slots.asLong() >= 0)) p.add("slots " + slots + " is not a non-negative integer");
                for (JsonNode k : s.path("struck")) if (!seen.contains(key(k))) p.add("struck names " + k + ", not a key");
                JsonNode probe = s.get("probe");
                if (probe != null) {
                    String k = key(probe.get("key"));
                    JsonNode hit = probe.get("hit");
                    if (k == null) p.add("probe has no key (a string or a number)");
                    else if (hit != null && !hit.isBoolean()) p.add("probe hit must be true or false");
                    else if (hit != null && hit.asBoolean() && !seen.contains(k)) p.add("probe hits " + k + ", not a key");
                }
                JsonNode ranks = s.get("ranks");
                if (ranks != null && !ranks.isArray()) {
                    p.add("ranks must be a list of keys, first is #1");
                } else if (ranks != null) {
                    Set<String> ranked = new HashSet<>();
                    for (int i = 0; i < ranks.size(); i++) {
                        String k = key(ranks.get(i));
                        if (!seen.contains(k)) p.add("rank " + (i + 1) + " names " + ranks.get(i) + ", not a key");
                        else if (!ranked.add(k)) p.add("rank " + (i + 1) + " repeats key " + k);
                    }
                }
                yield p;
            }
            case "set" -> set(s);
            case "output" -> {
                JsonNode values = s.get("values");
                if (values == null || !values.isArray()) yield List.of("values must be a list");
                yield marks(s.get("marks"), i -> i.isInt() && i.asInt() >= 0 && i.asInt() < values.size(), "index");
            }
            case "queue" -> {
                JsonNode values = s.get("values");
                if (values == null || !values.isArray()) yield List.of("values must be a list, front first");
                List<String> p = marks(s.get("marks"), i -> index(i, values), "position");
                for (JsonNode tag : s.path("tags")) {
                    if (!tag.isArray() || !index(tag.get(0), values)) p.add("tag " + tag + " is outside the queue");
                }
                yield p;
            }
            case "intervals" -> intervals(s);
            case "graph" -> {
                JsonNode nodes = s.get("nodes"), edges = s.get("edges");
                if (nodes == null || !nodes.isArray() || edges == null || !edges.isArray()) {
                    yield List.of("nodes and edges must be lists (usually in the run setup)");
                }
                Set<String> ids = new HashSet<>();
                nodes.forEach(n -> ids.add(n.path("id").asText()));
                List<String> p = new ArrayList<>();
                for (int i = 0; i < edges.size(); i++) {
                    JsonNode e = edges.get(i);
                    if (!ids.contains(e.path("from").asText()) || !ids.contains(e.path("to").asText())) {
                        p.add("edge " + i + " " + e + " names a node that doesn't exist");
                    }
                }
                p.addAll(marks(s.get("nodeMarks"), k -> ids.contains(k.asText()), "node id"));
                p.addAll(marks(s.get("edgeMarks"), k -> k.isInt() && k.asInt() >= 0 && k.asInt() < edges.size(),
                        "edge index"));
                s.path("values").fieldNames().forEachRemaining(id -> {
                    if (!ids.contains(id)) p.add("value for unknown node \"" + id + "\"");
                });
                yield p;
            }
            case "table" -> {
                JsonNode rows = s.get("rows");
                if (rows == null || !rows.isArray()) yield List.of("rows must be a list");
                yield marks(s.get("marks"), k -> k.isArray() && k.get(0) != null && k.get(0).isInt()
                        && k.get(0).asInt() >= 0 && k.get(0).asInt() < rows.size() && k.get(1) != null
                        && k.get(1).isInt() && k.get(1).asInt() >= 0
                        && k.get(1).asInt() < rows.get(k.get(0).asInt()).path("cells").size(), "cell [row, col]");
            }
            case "vars" -> {
                JsonNode items = s.get("items");
                if (items == null || !items.isArray()) yield List.of("items must be a list");
                List<String> p = new ArrayList<>();
                for (JsonNode item : items) {
                    unknownMark(item.get("mark"), MARKS).ifPresent(m -> p.add("item " + item.get("label") + " has " + m));
                    JsonNode why = item.get("why");
                    if (why != null && !(why.isTextual() && !why.asText().isBlank())) {
                        p.add("item " + item.get("label") + ": why must be a non-empty string (the reason it stays in vars)");
                    }
                }
                yield p;
            }
            default -> List.of(); // an unknown type is reported with the views
        };
    }

    /**
     * What is wrong with an intervals state: each group's intervals two numbers with start no later than end and inside
     * the axis ({@code domain}, when given), its marks indexes into the group, and each point a number on the axis.
     */
    private static List<String> intervals(JsonNode s) {
        JsonNode groups = s.get("groups");
        if (groups == null || !groups.isArray()) return List.of("groups must be a list of { label, intervals }");
        List<String> p = new ArrayList<>();
        JsonNode d = s.get("domain");
        boolean axis = d != null && d.isArray() && d.size() == 2 && d.get(0).isNumber() && d.get(1).isNumber()
                && d.get(0).asDouble() <= d.get(1).asDouble();
        if (d != null && !axis) p.add("domain " + d + " is not [low, high]");
        Predicate<Double> onAxis = v -> !axis || (v >= d.get(0).asDouble() && v <= d.get(1).asDouble());
        for (int g = 0; g < groups.size(); g++) {
            JsonNode list = groups.get(g).get("intervals");
            if (list == null || !list.isArray()) {
                p.add("group " + g + ": intervals must be a list of [start, end]");
                continue;
            }
            for (int i = 0; i < list.size(); i++) {
                JsonNode iv = list.get(i);
                String where = "group " + g + " interval " + i + " " + iv;
                if (!iv.isArray() || iv.size() != 2 || !iv.get(0).isNumber() || !iv.get(1).isNumber()) {
                    p.add(where + " is not two numbers");
                } else if (iv.get(0).asDouble() > iv.get(1).asDouble()) {
                    p.add(where + " starts after it ends");
                } else if (!onAxis.test(iv.get(0).asDouble()) || !onAxis.test(iv.get(1).asDouble())) {
                    p.add(where + " is outside the axis " + d);
                }
            }
            String group = "group " + g + ": ";
            marks(groups.get(g).get("marks"), k -> index(k, list), "row index").forEach(m -> p.add(group + m));
        }
        JsonNode points = s.get("points");
        for (int i = 0; points != null && i < points.size(); i++) {
            JsonNode point = points.get(i), at = point.get("at");
            if (at == null || !at.isNumber()) p.add("point " + i + " at " + at + " is not a number");
            else if (!onAxis.test(at.asDouble())) p.add("point " + i + " at " + at + " is outside the axis " + d);
            String which = "point " + i + " has ";
            unknownMark(point.get("mark"), MARKS).ifPresent(m -> p.add(which + m));
        }
        return p;
    }

    /**
     * What is wrong with a set state: members strings or numbers, none twice (4 and "4" are one member), marks on
     * members, and each probe a value; a probe that says it hits must name a member.
     */
    private static List<String> set(JsonNode s) {
        JsonNode members = s.get("members");
        if (members == null || !members.isArray()) return List.of("members must be a list of strings or numbers");
        List<String> p = new ArrayList<>();
        Set<String> seen = distinct(members, member -> member, "member", p);
        p.addAll(marks(s.get("marks"), k -> seen.contains(key(k)), "member"));
        JsonNode probes = s.get("probes");
        if (probes != null && !probes.isArray()) {
            p.add("probes must be a list of { value, hit? }");
        } else if (probes != null) {
            for (int i = 0; i < probes.size(); i++) {
                JsonNode probe = probes.get(i), hit = probe.get("hit");
                String value = key(probe.get("value"));
                if (value == null) p.add("probe " + i + " has no value (a string or a number)");
                else if (hit != null && hit.isBoolean() && hit.asBoolean() && !seen.contains(value)) {
                    p.add("probe " + i + " hits " + probe.get("value") + ", not a member");
                }
                if (hit != null && !hit.isBoolean()) p.add("probe " + i + ": hit is not true or false");
            }
        }
        return p;
    }

    private static boolean allRows(JsonNode cells) {
        for (JsonNode row : cells) if (!row.isArray() || row.size() != cells.get(0).size()) return false;
        return true;
    }

    private static List<String> marks(JsonNode marks, Predicate<JsonNode> inside, String what) {
        List<String> p = new ArrayList<>();
        if (marks == null || marks.isNull()) return p;
        marks.fields().forEachRemaining(mark -> {
            if (!MARKS.contains(mark.getKey())) {
                p.add("unknown mark \"" + mark.getKey() + "\" (one of " + MARKS + ")");
            } else if (!mark.getValue().isArray()) {
                p.add("mark \"" + mark.getKey() + "\" is not a list");
            } else {
                for (JsonNode k : mark.getValue()) {
                    if (!inside.test(k)) p.add("mark \"" + mark.getKey() + "\" names " + k + ", not a " + what + " in the data");
                }
            }
        });
        return p;
    }

    /** A string, or an object of strings by language. */
    private static boolean isText(JsonNode text) {
        if (text == null) return false;
        if (text.isTextual()) return true;
        if (!text.isObject() || text.isEmpty()) return false;
        for (JsonNode value : text) if (!value.isTextual()) return false;
        return true;
    }

    /** Text by language: a plain string is "en"; Korean ends its sentences with the same marks. */
    private static Map<String, String> texts(JsonNode text) {
        Map<String, String> byLanguage = new LinkedHashMap<>();
        if (text.isTextual()) {
            byLanguage.put("en", text.asText());
        } else {
            text.fields().forEachRemaining(language -> byLanguage.put(language.getKey(), language.getValue().asText()));
        }
        return byLanguage;
    }

    /** How many sentences {@code text} has, by {@link #SENTENCE_END}. */
    static int sentences(String text) {
        return 1 + (int) SENTENCE_END.matcher(text.strip()).results().count();
    }

    /** Not blank, in any language. */
    private static boolean hasText(JsonNode text) {
        if (text.isTextual()) return !text.asText().isBlank();
        for (JsonNode value : text) if (value.asText().isBlank()) return false;
        return true;
    }

    private static String runName(JsonNode run, int index) {
        JsonNode label = run.get("label");
        String text = label == null ? "?" : label.isTextual() ? label.asText() : label.path("en").asText("?");
        return "run " + (index + 1) + " (" + text + ")";
    }

    private static String quote(String text) {
        return JSON.valueToTree(text).toString();
    }
}
