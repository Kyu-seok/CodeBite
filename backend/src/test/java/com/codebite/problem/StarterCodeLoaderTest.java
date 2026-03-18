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
        String[] slugs = {"two-sum", "fizzbuzz", "reverse-string", "valid-parentheses", "palindrome-number"};
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
    void twoSum_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("two-sum");
        assertTrue(code.get("java").contains("twoSum"));
        assertTrue(code.get("python").contains("twoSum"));
        assertTrue(code.get("javascript").contains("twoSum"));
        assertTrue(code.get("cpp").contains("twoSum"));
    }

    @Test
    void fizzbuzz_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("fizzbuzz");
        assertTrue(code.get("java").contains("fizzBuzz"));
        assertTrue(code.get("python").contains("fizzBuzz"));
        assertTrue(code.get("javascript").contains("fizzBuzz"));
        assertTrue(code.get("cpp").contains("fizzBuzz"));
    }

    @Test
    void reverseString_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("reverse-string");
        assertTrue(code.get("java").contains("reverseString"));
        assertTrue(code.get("python").contains("reverseString"));
        assertTrue(code.get("javascript").contains("reverseString"));
        assertTrue(code.get("cpp").contains("reverseString"));
    }

    @Test
    void validParentheses_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("valid-parentheses");
        assertTrue(code.get("java").contains("isValid"));
        assertTrue(code.get("python").contains("isValid"));
        assertTrue(code.get("javascript").contains("isValid"));
        assertTrue(code.get("cpp").contains("isValid"));
    }

    @Test
    void palindromeNumber_containsExpectedMethodSignatures() {
        Map<String, String> code = loader.getStarterCode("palindrome-number");
        assertTrue(code.get("java").contains("isPalindrome"));
        assertTrue(code.get("python").contains("isPalindrome"));
        assertTrue(code.get("javascript").contains("isPalindrome"));
        assertTrue(code.get("cpp").contains("isPalindrome"));
    }

    @Test
    void nonexistentSlug_returnsEmptyMap() {
        Map<String, String> code = loader.getStarterCode("nonexistent");
        assertTrue(code.isEmpty());
    }
}
