package com.codebite.problem;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.NullNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

/**
 * Where a Walkthrough move may start or end, read from the kit's address table, {@code addresses.json} beside the
 * player (copied in verbatim, ADR 0012): the one definition the kit's {@code scripts/validate.mjs} also reads. For
 * each view type it says what an address is and the forms it accepts in a frame's state of the view; this class
 * knows the forms ({@code index}, {@code key}, {@code pair}, {@code edge}) and refuses a table naming another, so a
 * new kind of address fails here until it is read. A new address of a known form is a table edit alone: the table also
 * names where a place's value is drawn ({@code value}, {@code valueIn}), so no view type is named here.
 */
final class WalkthroughAddresses {

    /**
     * The copy, by its path from the repository root. Read from there, not from the kit checkout (CI has none) and not
     * as a test resource (a second copy that could drift): backend tests run with {@code backend/} as their working
     * directory, so the root is its parent.
     */
    static final String COPY = "frontend/src/components/walkthrough/addresses.json";

    private static final ObjectMapper JSON = new ObjectMapper();

    /**
     * One address form, by its name in the table: whether {@code at} names a place in a state, every place a state
     * holds, and where a move out of a place carries its value on to.
     */
    private record Form(String name, Names names, Places places, Onward onward) {
    }

    /** Whether {@code at} names a place in {@code state}, the frame's state of {@code view}. */
    private interface Names {
        boolean test(JsonNode at, JsonNode state, JsonNode view);
    }

    /** Each place in {@code state} by its {@link #address}, with the value drawn there, in the state's order. */
    private interface Places {
        void list(JsonNode state, Map<String, JsonNode> into);
    }

    /** The address of the place a move out of {@code at} also reaches, or null when it reaches none. */
    private interface Onward {
        String from(JsonNode at);
    }

    private static final Onward NOWHERE = at -> null;

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
        String name = f.path("form").asText(), list = f.path("list").asText();
        String field = f.path("field").asText(null), inner = f.path("inner").asText(null);
        Drawn drawn = new Drawn(f.path("value").asText(null), f.path("valueIn").asText(null));
        return switch (name) {
            case "index" -> new Form(name, (at, s, v) -> index(at, s.path(list)), (s, into) -> {
                for (int i = 0; i < s.path(list).size(); i++) into.put(String.valueOf(i), drawn.at(s, null, s.path(list).get(i)));
            }, NOWHERE);
            case "key" -> new Form(name, (at, s, v) -> {
                String k = key(at);
                if (k == null) return false;
                for (JsonNode item : s.path(list)) if (k.equals(key(field == null ? item : item.get(field)))) return true;
                return false;
            }, (s, into) -> {
                for (JsonNode item : s.path(list)) {
                    String k = key(field == null ? item : item.get(field));
                    if (k != null) into.put(k, drawn.at(s, k, item));
                }
            }, NOWHERE);
            case "pair" -> new Form(name, (at, s, v) -> at != null && at.isArray() && at.size() == 2 && index(at.get(0), s.path(list))
                    && index(at.get(1), inner == null ? s.path(list).path(at.get(0).asInt())
                    : s.path(list).path(at.get(0).asInt()).path(inner)), (s, into) -> {
                for (int i = 0; i < s.path(list).size(); i++) {
                    JsonNode row = inner == null ? s.path(list).get(i) : s.path(list).get(i).path(inner);
                    for (int j = 0; j < row.size(); j++) into.put(pair(String.valueOf(i), String.valueOf(j)), drawn.at(s, null, row.get(j)));
                }
            }, NOWHERE);
            case "edge" -> new Form(name, (at, s, v) -> at != null && at.isArray() && at.size() == 2
                    && edge(s.path(list), key(at.get(0)), key(at.get(1)), v.path("directed").asBoolean(true)), (s, into) -> {
                for (JsonNode e : s.path(list)) into.put(pair(key(e.get("from")), key(e.get("to"))), drawn.at(s, null, e));
            }, at -> at != null && at.isArray() && at.size() == 2 ? key(at.get(1)) : null);
            default -> throw new IllegalStateException(COPY + ": view type \"" + type + "\": unknown address form "
                    + f.get("form"));
        };
    }

    /**
     * Where a form's table entry says a place's value is drawn: the item itself; with {@code value}, the item's field of
     * that name; with {@code valueIn}, the state's object of that name, by the place's key. Null when missing.
     */
    private record Drawn(String field, String in) {
        JsonNode at(JsonNode state, String key, JsonNode item) {
            JsonNode value = in != null ? (key == null ? null : state.path(in).get(key))
                    : field != null ? (item.isObject() ? item.get(field) : null) : item;
            return value == null ? NullNode.getInstance() : value;
        }
    }

    /** The view types that take addresses. */
    Set<String> viewTypes() {
        return byType.keySet();
    }

    /** Whether {@code at} names a place in {@code state}, a frame's state of {@code view}, whose type is {@code type}. */
    boolean names(String type, JsonNode at, JsonNode state, JsonNode view) {
        Entry entry = byType.get(type);
        if (entry == null) return false;
        for (Form f : entry.forms()) if (f.names().test(at, state, view)) return true;
        return false;
    }

    /**
     * Every place of {@code type} in {@code state}, by its {@link #address}, with the value drawn there, in the state's
     * order, where the table says it is drawn (a list's item, a map entry's {@code value}, a graph's {@code values} by
     * node id, an edge's {@code label}). Empty for a type that takes no addresses.
     */
    Map<String, JsonNode> places(String type, JsonNode state) {
        Map<String, JsonNode> places = new LinkedHashMap<>();
        Entry entry = byType.get(type);
        if (entry != null) for (Form f : entry.forms()) f.places().list(state, places);
        return places;
    }

    /**
     * Whether {@code type}'s places are one list by index (an array, an output, a queue): a list whose values can
     * shift, as a queue's do when its front leaves, so its places are compared as a sequence.
     */
    boolean indexed(String type) {
        Entry entry = byType.get(type);
        return entry != null && entry.forms().stream().map(Form::name).toList().equals(List.of("index"));
    }

    /**
     * The addresses of the places of {@code type} that a move out of {@code at} carries its value on to, beside {@code at}
     * itself: an edge's far end (its second id), as a relaxation moves a cost along an edge into a node.
     */
    Set<String> onward(String type, JsonNode at) {
        Entry entry = byType.get(type);
        Set<String> onward = new LinkedHashSet<>();
        if (entry != null) for (Form f : entry.forms()) if (f.onward().from(at) != null) onward.add(f.onward().from(at));
        return onward;
    }

    /**
     * An address as {@link #places} keys it: a key or an index by its text (4 and "4" are one), a pair or an edge as
     * {@code [a,b]}; null for anything else.
     */
    static String address(JsonNode at) {
        if (at != null && at.isArray() && at.size() == 2 && key(at.get(0)) != null && key(at.get(1)) != null) {
            return pair(key(at.get(0)), key(at.get(1)));
        }
        return key(at);
    }

    /** A pair or an edge address as text, {@code [a,b]}: the one place it is spelled. */
    private static String pair(String a, String b) {
        return "[" + a + "," + b + "]";
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
        Entry entry = byType.get(type);
        if (entry == null) return List.of(where + ": view type \"" + type + "\" has no addresses");
        Optional<ObjectNode> state = stateIn(id, setup, frameViews);
        if (state.isEmpty()) return List.of(where + ": view \"" + id + "\" is not drawn in this frame");
        if (!names(type, address.get("at"), state.get(), view)) {
            return List.of(where + " is not " + entry.what() + " of " + type + " \"" + id + "\"");
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
