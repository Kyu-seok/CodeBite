package com.codebite.problem;

import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.ProblemTranslation;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.ProblemTranslationRepository;
import db.migration.V182__diagram_dedupe;
import db.migration.V183__add_tree_diagrams_batch1;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Verifies the V181 (POC before/after diagram) and V182 (dedupe) migrations.
 *
 * Catches the silent-no-op failure mode where REPLACE matches no rows and
 * the divergent-state failure mode where descriptions accumulate duplicate
 * `diagram-tree` blocks.
 */
@SpringBootTest
@ActiveProfiles("test")
class DiagramMigrationTest {

    @Autowired private ProblemRepository problemRepository;
    @Autowired private ProblemTranslationRepository translationRepository;

    @Test
    void mirrorMenuTree_englishDescription_hasExactlyOneBeforeAfterPair() {
        Problem p = problemRepository.findBySlug("mirror-menu-tree").orElseThrow();
        String desc = p.getDescription();
        long count = desc.split("```diagram-tree", -1).length - 1;
        assertEquals(1, count,
                "Expected exactly one diagram-tree block; actual:\n" + desc);
        assertTrue(desc.contains("nodes: [5, 3, 8, 2, 4, 7, 9]"),
                "Expected input tree in en description");
        assertTrue(desc.contains("after: [5, 8, 3, 9, 7, 4, 2]"),
                "Expected `after` (output tree) in en description");
    }

    @Test
    void mirrorMenuTree_koreanDescription_hasExactlyOneBeforeAfterPair() {
        Problem p = problemRepository.findBySlug("mirror-menu-tree").orElseThrow();
        ProblemTranslation t = translationRepository
                .findByProblemIdAndLocale(p.getId(), "ko")
                .orElse(null);
        assertNotNull(t, "Korean translation should exist for mirror-menu-tree");
        String desc = t.getDescription();
        long count = desc.split("```diagram-tree", -1).length - 1;
        assertEquals(1, count,
                "Expected exactly one diagram-tree block in ko; actual:\n" + desc);
        assertTrue(desc.contains("nodes: [5, 3, 8, 2, 4, 7, 9]"),
                "Expected input tree in ko description");
        assertTrue(desc.contains("after: [5, 8, 3, 9, 7, 4, 2]"),
                "Expected `after` (output tree) in ko description");
    }

    // ---- Unit tests for the V182 dedupe helper ----

    @Test
    void dedupe_singleBlock_isUnchanged() {
        String input = "intro text\n\n```diagram-tree\nnodes: [1,2,3]\n```\n\nmore text";
        assertEquals(input, V182__diagram_dedupe.keepOnlyFirstDiagramTree(input));
    }

    @Test
    void dedupe_noBlock_isUnchanged() {
        String input = "no diagram here at all";
        assertEquals(input, V182__diagram_dedupe.keepOnlyFirstDiagramTree(input));
    }

    @Test
    void dedupe_twoAdjacentBlocks_keepsFirstAndDropsSecond() {
        String input = "intro\n\n```diagram-tree\nnodes: [1,2,3]\n```\n\n"
                + "```diagram-tree\nnodes: [1,2,3]\n```\n\noutro";
        String expected = "intro\n\n```diagram-tree\nnodes: [1,2,3]\n```\n\noutro";
        assertEquals(expected, V182__diagram_dedupe.keepOnlyFirstDiagramTree(input));
    }

    @Test
    void dedupe_twoBlocksSeparatedByText_keepsFirstAndDropsSecond() {
        String input = "intro\n\n```diagram-tree\nnodes: [1,2,3]\n```\n\n"
                + "middle text\n\n```diagram-tree\nnodes: [4,5,6]\n```\n\noutro";
        String expected = "intro\n\n```diagram-tree\nnodes: [1,2,3]\n```\n\n"
                + "middle text\n\noutro";
        assertEquals(expected, V182__diagram_dedupe.keepOnlyFirstDiagramTree(input));
    }

    @Test
    void dedupe_threeBlocks_keepsFirstAndDropsRest() {
        String input = "```diagram-tree\nnodes: [1]\n```\n\n"
                + "```diagram-tree\nnodes: [2]\n```\n\n"
                + "```diagram-tree\nnodes: [3]\n```";
        String expected = "```diagram-tree\nnodes: [1]\n```\n\n";
        assertEquals(expected, V182__diagram_dedupe.keepOnlyFirstDiagramTree(input));
    }

    @Test
    void dedupe_malformedTrailingBlock_isLeftAlone() {
        String input = "```diagram-tree\nnodes: [1]\n```\n\n```diagram-tree\nbroken";
        String expected = "```diagram-tree\nnodes: [1]\n```\n\n```diagram-tree\nbroken";
        assertEquals(expected, V182__diagram_dedupe.keepOnlyFirstDiagramTree(input));
    }

    @Test
    void dedupe_nullInput_isNull() {
        assertNotNull(V182__diagram_dedupe.keepOnlyFirstDiagramTree("ok"));
    }

    // ---- Spot-checks for the V183 Stage 2 batch (sampling 4 representative cases) ----

    @Test
    void v183_lcaBst_descriptionHasDiagramWithHighlight() {
        Problem p = problemRepository.findBySlug("lca-bst").orElseThrow();
        String desc = p.getDescription();
        assertTrue(desc.contains("```diagram-tree"), "Expected diagram in lca-bst");
        assertTrue(desc.contains("nodes: [6, 2, 8, 0, 4, 7, 9, null, null, 3, 5]"),
                "Expected lca-bst input tree");
        assertTrue(desc.contains("highlight: [1, 2]"),
                "Expected p,q indices highlighted");
    }

    @Test
    void v183_sameSkillTrees_hasBothPandQAsBeforeAfter() {
        Problem p = problemRepository.findBySlug("same-skill-trees").orElseThrow();
        String desc = p.getDescription();
        assertTrue(desc.contains("```diagram-tree"), "Expected diagram in same-skill-trees");
        assertTrue(desc.contains("nodes: [8, 4, 12]"), "Expected p tree");
        assertTrue(desc.contains("after: [8, 4, 12]"), "Expected q tree as after");
    }

    @Test
    void v183_appliesToKoreanTranslationsToo() {
        Problem p = problemRepository.findBySlug("lca-bst").orElseThrow();
        ProblemTranslation t = translationRepository
                .findByProblemIdAndLocale(p.getId(), "ko")
                .orElse(null);
        assertNotNull(t);
        assertTrue(t.getDescription().contains("```diagram-tree"),
                "Expected diagram in ko description for lca-bst");
        assertTrue(t.getDescription().contains("nodes: [6, 2, 8, 0, 4, 7, 9, null, null, 3, 5]"),
                "Korean diagram body should match en");
    }

    @Test
    void v183_skipsTrieAndGridProblems() {
        // username-trie, wildcard-lexicon, word-search-ii all carry the trees/tries
        // tag but were intentionally skipped — visualizing them as binary trees would
        // be misleading.
        for (String slug : new String[]{"username-trie", "wildcard-lexicon", "word-search-ii"}) {
            Problem p = problemRepository.findBySlug(slug).orElse(null);
            if (p == null) continue;
            assertEquals(0,
                    p.getDescription().split("```diagram-tree", -1).length - 1,
                    "Expected " + slug + " to have NO tree diagram");
        }
    }

    // ---- Unit tests for the V183 injection helper ----

    @Test
    void inject_insertsDiagramAfterExample1ClosingFence() {
        String desc = "intro\n\n**Example 1:**\n```\nInput: x\nOutput: y\n```\n\n"
                + "**Example 2:**\n```\nInput: a\nOutput: b\n```";
        String diagram = "```diagram-tree\nnodes: [1]\n```";
        String out = V183__add_tree_diagrams_batch1.injectDiagram(desc, "**Example 1:**", diagram);
        // Diagram should land between Example 1's closing fence and the **Example 2:** marker.
        int diagramPos = out.indexOf("```diagram-tree");
        int example2Pos = out.indexOf("**Example 2:**");
        assertTrue(diagramPos > 0, "Diagram should be inserted");
        assertTrue(diagramPos < example2Pos, "Diagram should come before Example 2");
        assertTrue(out.contains("```\n\n```diagram-tree"),
                "Diagram should be on a new paragraph after the closing fence");
    }

    @Test
    void inject_returnsUnchangedWhenAnchorMissing() {
        String desc = "no example marker here at all";
        String unchanged = V183__add_tree_diagrams_batch1.injectDiagram(
                desc, "**Example 1:**", "```diagram-tree\nnodes: [1]\n```");
        assertEquals(desc, unchanged);
    }

    @Test
    void inject_worksForKoreanMarker() {
        String desc = "도입\n\n**예시 1:**\n```\n입력: x\n출력: y\n```\n\n**예시 2:**";
        String out = V183__add_tree_diagrams_batch1.injectDiagram(
                desc, "**예시 1:**", "```diagram-tree\nnodes: [1]\n```");
        assertTrue(out.contains("```diagram-tree"));
        assertTrue(out.indexOf("```diagram-tree") < out.indexOf("**예시 2:**"));
    }

    // ---- V184 Stage 4 batch (graph diagrams for non-grid graph problems) ----

    @ParameterizedTest
    @ValueSource(strings = {
            "snapshot-town-map", "merge-duplicate-contacts", "count-voice-parties",
            "order-group-tasks", "verify-task-order", "cafe-price-ratios",
            "open-all-rooms", "two-shift-baristas", "graph-valid-tree",
            "word-ladder", "dog-street-walk", "cheapest-courier-route",
            "redundant-friendship", "connect-water-bowls", "guild-chat-relay"
    })
    void v184_graphProblem_descriptionHasExactlyOneDiagramGraphBlock(String slug) {
        Problem p = problemRepository.findBySlug(slug).orElseThrow(
                () -> new AssertionError("Problem not found: " + slug));
        String desc = p.getDescription();
        long count = desc.split("```diagram-graph", -1).length - 1;
        assertEquals(1, count,
                "Expected exactly one diagram-graph block in " + slug + "; actual:\n" + desc);
        assertTrue(desc.contains("edges: ["),
                "Expected `edges:` line in " + slug + " diagram");
        assertTrue(desc.contains("directed: "),
                "Expected `directed:` line in " + slug + " diagram");
    }

    @Test
    void v184_directedProblem_carriesDirectedTrue() {
        // order-group-tasks is a topo-sort problem — must render arrows.
        Problem p = problemRepository.findBySlug("order-group-tasks").orElseThrow();
        assertTrue(p.getDescription().contains("directed: true"),
                "order-group-tasks should be a directed graph");
    }

    @Test
    void v184_undirectedProblem_carriesDirectedFalse() {
        // count-voice-parties is undirected (Union-Find).
        Problem p = problemRepository.findBySlug("count-voice-parties").orElseThrow();
        assertTrue(p.getDescription().contains("directed: false"),
                "count-voice-parties should be an undirected graph");
    }

    @Test
    void v184_pathProblem_carriesHighlightPath() {
        // word-ladder is BFS shortest path — should highlight the answer.
        Problem p = problemRepository.findBySlug("word-ladder").orElseThrow();
        assertTrue(p.getDescription().contains("highlight_path: ["),
                "word-ladder should highlight its BFS path");
    }

    @Test
    void v184_appliesToKoreanTranslationsToo() {
        Problem p = problemRepository.findBySlug("order-group-tasks").orElseThrow();
        ProblemTranslation t = translationRepository
                .findByProblemIdAndLocale(p.getId(), "ko")
                .orElse(null);
        assertNotNull(t, "Korean translation should exist");
        assertTrue(t.getDescription().contains("```diagram-graph"),
                "Korean description should also carry the graph diagram");
    }

    // ---- V185 Stage 4 batch (grid diagrams for matrix/island/grid-DP problems) ----

    @ParameterizedTest
    @ValueSource(strings = {
            "rotate-pet-cafe-map", "spiral-shelf-walk", "zero-out-rows-cols",
            "count-desk-clusters", "capture-enclosed-tiles", "walls-and-gates",
            "dual-waterbowl-flow", "rotting-donuts", "shortest-dungeon-path",
            "count-dungeon-paths", "rising-water-path", "word-search", "word-search-ii"
    })
    void v185_gridProblem_descriptionHasExactlyOneDiagramGridBlock(String slug) {
        Problem p = problemRepository.findBySlug(slug).orElseThrow(
                () -> new AssertionError("Problem not found: " + slug));
        String desc = p.getDescription();
        long count = desc.split("```diagram-grid", -1).length - 1;
        assertEquals(1, count,
                "Expected exactly one diagram-grid block in " + slug + "; actual:\n" + desc);
        assertTrue(desc.contains("cells: ["),
                "Expected `cells:` line in " + slug + " diagram");
    }

    @Test
    void v185_transformationProblem_carriesAfterField() {
        // rotate-pet-cafe-map is a structural transform — must use before/after.
        Problem p = problemRepository.findBySlug("rotate-pet-cafe-map").orElseThrow();
        assertTrue(p.getDescription().contains("after: ["),
                "rotate-pet-cafe-map should render as a before/after pair");
    }

    @Test
    void v185_islandProblem_carriesHighlight() {
        // count-desk-clusters (number of islands) — highlight one island so the
        // "what counts as a connected component" intuition reads visually.
        Problem p = problemRepository.findBySlug("count-desk-clusters").orElseThrow();
        assertTrue(p.getDescription().contains("highlight: ["),
                "count-desk-clusters should highlight an island");
    }

    @Test
    void v185_appliesToKoreanTranslationsToo() {
        Problem p = problemRepository.findBySlug("rotate-pet-cafe-map").orElseThrow();
        ProblemTranslation t = translationRepository
                .findByProblemIdAndLocale(p.getId(), "ko")
                .orElse(null);
        assertNotNull(t, "Korean translation should exist");
        assertTrue(t.getDescription().contains("```diagram-grid"),
                "Korean description should also carry the grid diagram");
    }

    // ---- V186 linked-list diagrams (cycle, reverse, restructure) ----

    @ParameterizedTest
    @ValueSource(strings = {
            "reverse-linked-list", "detect-portal-loop", "flip-chunks-of-k",
            "interleave-clip-chain", "swap-print-pairs"
    })
    void v186_linkedListProblem_descriptionHasExactlyOneDiagramBlock(String slug) {
        Problem p = problemRepository.findBySlug(slug).orElseThrow(
                () -> new AssertionError("Problem not found: " + slug));
        String desc = p.getDescription();
        long count = desc.split("```diagram-linked-list", -1).length - 1;
        assertEquals(1, count,
                "Expected exactly one diagram-linked-list block in " + slug
                        + "; actual:\n" + desc);
        assertTrue(desc.contains("nodes: ["),
                "Expected `nodes:` line in " + slug + " diagram");
    }

    @Test
    void v186_cycleProblem_carriesCycleTo() {
        Problem p = problemRepository.findBySlug("detect-portal-loop").orElseThrow();
        assertTrue(p.getDescription().contains("cycle_to:"),
                "detect-portal-loop should mark where the tail loops back");
    }

    @Test
    void v186_reverseProblem_carriesAfter() {
        Problem p = problemRepository.findBySlug("reverse-linked-list").orElseThrow();
        assertTrue(p.getDescription().contains("after: ["),
                "reverse-linked-list should render as a before/after pair");
    }

    @Test
    void v186_appliesToKoreanTranslationsToo() {
        Problem p = problemRepository.findBySlug("reverse-linked-list").orElseThrow();
        ProblemTranslation t = translationRepository
                .findByProblemIdAndLocale(p.getId(), "ko")
                .orElse(null);
        assertNotNull(t, "Korean translation should exist");
        assertTrue(t.getDescription().contains("```diagram-linked-list"),
                "Korean description should also carry the linked-list diagram");
    }
}
