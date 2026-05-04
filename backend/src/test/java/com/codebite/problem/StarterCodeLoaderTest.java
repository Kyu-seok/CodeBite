package com.codebite.problem;

import com.codebite.problem.service.StarterCodeLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class StarterCodeLoaderTest {

    private StarterCodeLoader loader;

    @BeforeEach
    void setUp() throws Exception {
        loader = new StarterCodeLoader();
        loader.loadStarterCode();
    }

    @Test
    void loadsAllStarterCodeEntries() {
        String[] slugs = {"snack-drawer-pair", "valid-brackets", "zero-sum-trio", "group-drink-labels", "merge-reservation-slots"};
        String[] languages = {"java", "python", "javascript", "cpp"};

        for (String slug : slugs) {
            Map<String, String> starterCode = loader.getStarterCode(slug);
            assertEquals(4, starterCode.size(), "Expected 4 languages for " + slug);
            for (String language : languages) {
                assertNotNull(starterCode.get(language), slug + ":" + language + " should exist");
            }
        }
    }

    @Test
    void snackDrawerPair_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("snack-drawer-pair");
        assertTrue(code.get("java").contains("findPairIndices"));
        assertTrue(code.get("python").contains("findPairIndices"));
        assertTrue(code.get("javascript").contains("findPairIndices"));
        assertTrue(code.get("cpp").contains("findPairIndices"));
    }

    @Test
    void validBrackets_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("valid-brackets");
        assertTrue(code.get("java").contains("verifyJobNesting"));
        assertTrue(code.get("python").contains("verifyJobNesting"));
        assertTrue(code.get("javascript").contains("verifyJobNesting"));
        assertTrue(code.get("cpp").contains("verifyJobNesting"));
    }

    @Test
    void zeroSumTrio_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("zero-sum-trio");
        assertTrue(code.get("java").contains("triageZeroPriority"));
        assertTrue(code.get("python").contains("triageZeroPriority"));
        assertTrue(code.get("javascript").contains("triageZeroPriority"));
        assertTrue(code.get("cpp").contains("triageZeroPriority"));
    }

    @Test
    void nonexistentSlug_returnsEmptyMap() {
        Map<String, String> code = loader.getStarterCode("nonexistent");
        assertTrue(code.isEmpty());
    }
}
