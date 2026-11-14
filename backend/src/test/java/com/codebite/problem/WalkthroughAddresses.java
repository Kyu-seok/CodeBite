package com.codebite.problem;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

/**
 * Where a Walkthrough move may start or end, read from the kit's address table, {@code addresses.json} beside the
 * player (copied in verbatim, ADR 0012): the one definition the kit's {@code scripts/validate.mjs} also reads. For
 * each view type it says what an address is and the forms it accepts in a frame's state of the view; this class
 * knows the forms ({@code index}, {@code key}, {@code pair}, {@code edge}) and refuses a table naming another, so a
 * new kind of address fails here until it is read. A new address of a known form is a table edit alone.
 */
final class WalkthroughAddresses {

    /**
     * The copy, by its path from the repository root. Read from there, not from the kit checkout (CI has none) and not
     * as a test resource (a second copy that could drift): backend tests run with {@code backend/} as their working
     * directory, so the root is its parent.
     */
    static final String COPY = "frontend/src/components/walkthrough/addresses.json";

    private static final ObjectMapper JSON = new ObjectMapper();

    /** Whether {@code at} names a place in {@code state}, the frame's state of {@code view}. */
    private interface Form {
        boolean names(JsonNode at, JsonNode state, JsonNode view);
    }

    private record Entry(String what, List<Form> forms) {
    }

    private final Map<String, Entry> byType;

    private WalkthroughAddresses(Map<String, Entry> byType) {
        this.byType = byType;
    }

    /** The table as CodeBite carries it. */
    static WalkthroughAddresses kit() {
        Path copy = Path.of("").toAbsolutePath().getParent().resolve(COPY);
        try {
            return of(JSON.readTree(Files.readString(copy)));
        } catch (IOException e) {
            throw new UncheckedIOException("No address table at " + copy + ": run with backend/ as the working "
                    + "directory, and copy the kit in with scripts/copy-walkthrough-kit.py", e);
        }
    }

    /** A table's view entries, each form read; a form this class doesn't know is refused, naming it. */
    static WalkthroughAddresses of(JsonNode table) {
        Map<String, Entry> byType = new LinkedHashMap<>();
        table.path("views").fields().forEachRemaining(view -> {
            List<Form> forms = new ArrayList<>();
            for (JsonNode f : view.getValue().path("forms")) forms.add(form(view.getKey(), f));
            byType.put(view.getKey(), new Entry(view.getValue().path("what").asText(), forms));
        });
        return new WalkthroughAddresses(byType);
    }

    private static Form form(String type, JsonNode f) {
        String list = f.path("list").asText();
        String field = f.path("field").asText(null), inner = f.path("inner").asText(null);
        return switch (f.path("form").asText()) {
            case "index" -> (at, s, v) -> index(at, s.path(list));
            case "key" -> (at, s, v) -> {
                String k = key(at);
                if (k == null) return false;
                for (JsonNode item : s.path(list)) if (k.equals(key(field == null ? item : item.get(field)))) return true;
                return false;
            };
            case "pair" -> (at, s, v) -> at != null && at.isArray() && at.size() == 2 && index(at.get(0), s.path(list))
                    && index(at.get(1), inner == null ? s.path(list).path(at.get(0).asInt())
                    : s.path(list).path(at.get(0).asInt()).path(inner));
            case "edge" -> (at, s, v) -> at != null && at.isArray() && at.size() == 2
                    && edge(s.path(list), key(at.get(0)), key(at.get(1)), v.path("directed").asBoolean(true));
            default -> throw new IllegalStateException(COPY + ": view type \"" + type + "\": unknown address form "
                    + f.get("form"));
        };
    }

    /** The view types that take addresses. */
    Set<String> viewTypes() {
        return byType.keySet();
    }

    /** What an address of {@code type} is, as a problem names it; empty when the type takes none. */
    Optional<String> what(String type) {
        return Optional.ofNullable(byType.get(type)).map(Entry::what);
    }

    /** Whether {@code at} names a place in {@code state}, a frame's state of {@code view}, whose type is {@code type}. */
    boolean names(String type, JsonNode at, JsonNode state, JsonNode view) {
        Entry entry = byType.get(type);
        if (entry == null) return false;
        for (Form f : entry.forms()) if (f.names(at, state, view)) return true;
        return false;
    }

    /** View {@code id}'s state in a frame: the run's setup merged with the frame's own; empty when neither draws it. */
    static Optional<ObjectNode> stateIn(String id, JsonNode setup, JsonNode frameViews) {
        if (!frameViews.has(id) && !setup.has(id)) return Optional.empty();
        ObjectNode state = JSON.createObjectNode();
        if (setup.get(id) instanceof ObjectNode own) state.setAll(own);
        if (frameViews.get(id) instanceof ObjectNode own) state.setAll(own);
        return Optional.of(state);
    }

    /**
     * What is wrong with one end ({@code "from"} or {@code "to"}) of a move, {@code address} being its {@code {view, at}}:
     * an unknown view, a view type that takes no addresses, a view not drawn in the frame, or an {@code at} naming no
     * place in that frame's state. Each problem names the address.
     */
    List<String> problems(String end, JsonNode address, Map<String, JsonNode> views, JsonNode setup,
                          JsonNode frameViews) {
        String id = address.path("view").asText();
        JsonNode view = views.get(id);
        if (view == null) return List.of(end + " names unknown view \"" + id + "\"");
        String type = view.path("type").asText(), where = end + " " + address;
        Optional<String> what = what(type);
        if (what.isEmpty()) return List.of(where + ": view type \"" + type + "\" has no addresses");
        Optional<ObjectNode> state = stateIn(id, setup, frameViews);
        if (state.isEmpty()) return List.of(where + ": view \"" + id + "\" is not drawn in this frame");
        if (!names(type, address.get("at"), state.get(), view)) {
            return List.of(where + " is not " + what.get() + " of " + type + " \"" + id + "\"");
        }
        return List.of();
    }

    /** Whether {@code i} is an index into the list {@code list}. */
    private static boolean index(JsonNode i, JsonNode list) {
        return i != null && i.isInt() && i.asInt() >= 0 && list.isArray() && i.asInt() < list.size();
    }

    /** A key as the player compares it: a string or a number, by its text. Null for anything else. */
    private static String key(JsonNode k) {
        return k != null && (k.isTextual() || k.isNumber()) ? k.asText() : null;
    }

    /** Whether {@code edges} hold one from {@code a} to {@code b}, or either way when undirected. */
    private static boolean edge(JsonNode edges, String a, String b, boolean directed) {
        if (a == null || b == null) return false;
        for (JsonNode e : edges) {
            String from = key(e.get("from")), to = key(e.get("to"));
            if ((a.equals(from) && b.equals(to)) || (!directed && a.equals(to) && b.equals(from))) return true;
        }
        return false;
    }
}
