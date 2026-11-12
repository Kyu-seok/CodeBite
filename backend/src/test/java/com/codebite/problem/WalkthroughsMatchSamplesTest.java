package com.codebite.problem;

import com.codebite.problem.service.Walkthroughs;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every Walkthrough (GLOSSARY.md, ADR 0011) shows the samples it claims to: its problem exists
 * under the Slug it is filed under; it is a well-formed {@code walkthrough/1} document (the public
 * walkthrough skill's {@code references/format.md}: known view types, marks inside the data they
 * name, the answer on the last frame only); its sample runs are, in order, exactly the problem's
 * sample Test Cases by {@code sampleInput} and {@code expected}, compared trimmed as the Grader
 * compares; each run ends on its {@code expected}; and any run marked {@code extra} comes after
 * the sample runs. Correcting, adding or reordering a sample without regenerating the Walkthrough
 * (its tracer is {@code scripts/walkthroughs/<slug>.py}) fails here.
 */
class WalkthroughsMatchSamplesTest {

    private static final ObjectMapper JSON = new ObjectMapper();
    private static final MigratedDatabase DATABASE = new MigratedDatabase("walkthroughs-match-samples");
    private static final Walkthroughs WALKTHROUGHS = new Walkthroughs();

    private static final List<String> VIEW_TYPES = List.of("grid", "array", "graph", "table", "vars");
    private static final List<String> MARKS = List.of("lit", "good", "bad", "path", "dim");

    /** A sample Test Case's input and expected output, as PostgreSQL stores them. */
    record Sample(String input, String expected) {
    }

    private static final Map<String, List<Sample>> SAMPLES = new HashMap<>();

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

    // --- the checks catch what they should, on a copy of rotting-donuts --------------------------

    @ParameterizedTest(name = "{0}")
    @ValueSource(strings = {
            "unknown view type", "mark outside the grid", "answer on a middle frame", "no answer on the last frame",
            "answer not the expected", "expected not the sample's", "sampleInput not the sample's", "missing run",
            "swapped runs", "extra run before a sample run", "extra run with a sampleInput", "run past the samples",
            "empty caption",
    })
    void aBrokenWalkthroughIsCaught(String breakage) throws Exception {
        ObjectNode walkthrough = rottingDonuts();
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
            default -> throw new IllegalArgumentException(breakage);
        }
        List<String> found = mismatches("rotting-donuts", walkthrough, SAMPLES.get("rotting-donuts"));
        assertFalse(found.isEmpty(), breakage + " was not caught");
        assertTrue(found.stream().allMatch(m -> m.startsWith("rotting-donuts")), "Unnamed: " + found);
    }

    @Test
    void textDifferingOnlyInSurroundingWhitespaceMatchesAsTheGraderComparesIt() throws Exception {
        List<Sample> samples = SAMPLES.get("rotting-donuts");
        List<Sample> padded = List.of(new Sample(samples.get(0).input() + "\n", samples.get(0).expected()),
                samples.get(1), new Sample(samples.get(2).input(), " " + samples.get(2).expected() + "\n"));
        List<String> found = mismatches("rotting-donuts", rottingDonuts(), padded);
        assertTrue(found.isEmpty(), String.join("\n", found));
    }

    @Test
    void aWalkthroughForNoProblemIsCaught() throws Exception {
        assertFalse(mismatches("no-such-problem", rottingDonuts(), null).isEmpty());
    }

    @Test
    void anExtraRunAfterTheSamplesPasses() throws Exception {
        ObjectNode walkthrough = rottingDonuts();
        ObjectNode extra = ((ArrayNode) walkthrough.get("runs")).addObject();
        extra.put("label", "All fresh").put("input", "ward = [[1]]").put("expected", "-1").put("extra", true);
        extra.putArray("frames").addObject().put("caption", "No stale donut: -1.").put("answer", "-1");
        List<String> found = mismatches("rotting-donuts", walkthrough, SAMPLES.get("rotting-donuts"));
        assertTrue(found.isEmpty(), String.join("\n", found));
    }

    private static ObjectNode rottingDonuts() throws Exception {
        return (ObjectNode) JSON.readTree(WALKTHROUGHS.of("rotting-donuts").orElseThrow());
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
                if (!isText(frame.get("caption")) || !hasText(frame.get("caption"))) p.add(at + ": caption missing");
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
                yield p;
            }
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
                    JsonNode mark = item.get("mark");
                    if (mark != null && !mark.isNull() && !MARKS.contains(mark.asText())) {
                        p.add("item " + item.get("label") + " has unknown mark " + mark);
                    }
                }
                yield p;
            }
            default -> List.of(); // an unknown type is reported with the views
        };
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
