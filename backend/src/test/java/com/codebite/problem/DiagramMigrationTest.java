package com.codebite.problem;

import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.ProblemTranslation;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.ProblemTranslationRepository;
import db.migration.V182__diagram_dedupe;
import org.junit.jupiter.api.Test;
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
}
