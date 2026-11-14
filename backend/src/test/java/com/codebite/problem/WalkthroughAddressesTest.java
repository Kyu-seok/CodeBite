package com.codebite.problem;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** {@link WalkthroughAddresses} reads the kit's address table, as the kit's {@code validate.mjs} does. */
class WalkthroughAddressesTest {

    private static final ObjectMapper JSON = new ObjectMapper();

    private static JsonNode json(String text) throws Exception {
        return JSON.readTree(text.replace('\'', '"'));
    }

    @Test
    void theCopiedTableNamesTheViewTypesThatTakeAddresses() {
        WalkthroughAddresses kit = WalkthroughAddresses.kit();
        assertEquals(Set.of("grid", "array", "map", "set", "output", "queue", "table", "graph", "intervals"), kit.viewTypes());
    }

    @Test
    void eachFormAcceptsWhatItNamesAndNothingElse() throws Exception {
        WalkthroughAddresses kit = WalkthroughAddresses.kit();
        JsonNode plain = json("{}"), undirected = json("{'directed': false}");
        JsonNode array = json("{'values': [7, 8]}");
        assertTrue(kit.names("array", json("1"), array, plain));
        assertFalse(kit.names("array", json("2"), array, plain));
        assertFalse(kit.names("array", json("'0'"), array, plain));
        JsonNode map = json("{'entries': [{'key': 4}]}");
        assertTrue(kit.names("map", json("'4'"), map, plain));
        assertFalse(kit.names("map", json("5"), map, plain));
        assertFalse(kit.names("set", json("['x']"), json("{'members': ['x']}"), plain));
        assertTrue(kit.names("table", json("[0, 1]"), json("{'rows': [{'cells': [1, 2]}]}"), plain));
        assertFalse(kit.names("table", json("[0, 2]"), json("{'rows': [{'cells': [1, 2]}]}"), plain));
        assertTrue(kit.names("grid", json("[0, 1]"), json("{'cells': [[1, 2]]}"), plain));
        assertFalse(kit.names("grid", json("0"), json("{'cells': [[1]]}"), plain));
        JsonNode graph = json("{'nodes': [{'id': 'a'}, {'id': 'b'}], 'edges': [{'from': 'a', 'to': 'b'}]}");
        assertTrue(kit.names("graph", json("'b'"), graph, plain));
        assertTrue(kit.names("graph", json("['a', 'b']"), graph, plain));
        assertFalse(kit.names("graph", json("['b', 'a']"), graph, plain));
        assertTrue(kit.names("graph", json("['b', 'a']"), graph, undirected));
        assertFalse(kit.names("graph", json("'c'"), graph, plain));
        assertFalse(kit.names("vars", json("0"), json("{'items': []}"), plain));
    }

    @Test
    void eachFormListsThePlacesAStateHoldsWithTheValueDrawnThere() throws Exception {
        WalkthroughAddresses kit = WalkthroughAddresses.kit();
        assertEquals(Map.of("0", json("7"), "1", json("8")), kit.places("queue", json("{'values': [7, 8]}")));
        assertEquals(Map.of("4", json("2"), "x", json("[1]")),
                kit.places("map", json("{'entries': [{'key': 4, 'value': 2}, {'key': 'x', 'value': [1]}]}")));
        assertEquals(Map.of("x", json("'x'")), kit.places("set", json("{'members': ['x']}")));
        assertEquals(Map.of("[0,0]", json("1"), "[0,1]", json("2")), kit.places("table", json("{'rows': [{'cells': [1, 2]}]}")));
        assertEquals(Map.of("a", json("0"), "b", json("null"), "[a,b]", json("5")), kit.places("graph",
                json("{'nodes': [{'id': 'a'}, {'id': 'b'}], 'edges': [{'from': 'a', 'to': 'b', 'label': 5}], 'values': {'a': 0}}")));
        assertEquals(Map.of(), kit.places("vars", json("{'items': [{'label': 'k', 'value': 2}]}")));
        assertEquals(Set.of("b"), kit.onward("graph", json("['a', 'b']")));
        assertEquals(Set.of(), kit.onward("graph", json("'a'")));
        assertEquals(Set.of(), kit.onward("table", json("[0, 1]")));
        assertTrue(kit.indexed("queue"));
        assertFalse(kit.indexed("graph"));
        assertEquals("4", WalkthroughAddresses.address(json("'4'")));
        assertEquals("[a,4]", WalkthroughAddresses.address(json("['a', 4]")));
    }

    @Test
    void aFormTheReaderDoesNotKnowIsRefusedByName() throws Exception {
        JsonNode table = json("{'views': {'a': {'what': 'x', 'forms': [{'form': 'slot', 'list': 'values'}]}}}");
        IllegalStateException e = assertThrows(IllegalStateException.class, () -> WalkthroughAddresses.of(table));
        assertTrue(e.getMessage().contains("view type \"a\": unknown address form \"slot\""), e.getMessage());
    }

    @Test
    void aMoveEndIsResolvedInTheFrameItIsDrawnIn() throws Exception {
        WalkthroughAddresses kit = WalkthroughAddresses.kit();
        Map<String, JsonNode> views = Map.of("xs", json("{'id': 'xs', 'type': 'array'}"),
                "state", json("{'id': 'state', 'type': 'vars'}"));
        JsonNode setup = json("{'xs': {'values': [1, 2]}}"), frame = json("{'xs': {'values': [1, 2, 3]}}");
        assertEquals(List.of(), kit.problems("to", json("{'view': 'xs', 'at': 2}"), views, setup, frame));
        assertEquals(List.of("to {\"view\":\"xs\",\"at\":3} is not an index of array \"xs\""),
                kit.problems("to", json("{'view': 'xs', 'at': 3}"), views, setup, frame));
        assertEquals(List.of("from names unknown view \"nope\""),
                kit.problems("from", json("{'view': 'nope', 'at': 0}"), views, setup, frame));
        assertEquals(List.of("from {\"view\":\"state\",\"at\":0}: view type \"vars\" has no addresses"),
                kit.problems("from", json("{'view': 'state', 'at': 0}"), views, setup, frame));
        assertEquals(List.of("to {\"view\":\"xs\",\"at\":0}: view \"xs\" is not drawn in this frame"),
                kit.problems("to", json("{'view': 'xs', 'at': 0}"), views, json("{}"), json("{}")));
        assertEquals(3, WalkthroughAddresses.stateIn("xs", setup, frame).orElseThrow().get("values").size());
        assertTrue(WalkthroughAddresses.stateIn("state", setup, frame).isEmpty());
    }
}
