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
        String[] slugs = {"pair-sum", "bracket-validator", "three-sum", "anagram-groups", "overlap-merge"};
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
    void pairSum_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("pair-sum");
        assertTrue(code.get("java").contains("twoSum"));
        assertTrue(code.get("python").contains("twoSum"));
        assertTrue(code.get("javascript").contains("twoSum"));
        assertTrue(code.get("cpp").contains("twoSum"));
    }

    @Test
    void bracketValidator_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("bracket-validator");
        assertTrue(code.get("java").contains("isValid"));
        assertTrue(code.get("python").contains("isValid"));
        assertTrue(code.get("javascript").contains("isValid"));
        assertTrue(code.get("cpp").contains("isValid"));
    }

    @Test
    void threeSum_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("three-sum");
        assertTrue(code.get("java").contains("threeSum"));
        assertTrue(code.get("python").contains("threeSum"));
        assertTrue(code.get("javascript").contains("threeSum"));
        assertTrue(code.get("cpp").contains("threeSum"));
    }

    @Test
    void nonexistentSlug_returnsEmptyMap() {
        Map<String, String> code = loader.getStarterCode("nonexistent");
        assertTrue(code.isEmpty());
    }
}
