package com.codebite.judge;

import com.codebite.judge.service.DriverCodeLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class DriverCodeLoaderTest {

    private DriverCodeLoader loader;

    @BeforeEach
    void setUp() throws Exception {
        loader = new DriverCodeLoader();
        loader.loadTemplates();
    }

    @Test
    void loadsAllJavaTemplates() {
        assertNotNull(loader.getDriverCode("two-sum", "java"));
        assertNotNull(loader.getDriverCode("fizzbuzz", "java"));
        assertNotNull(loader.getDriverCode("reverse-string", "java"));
        assertNotNull(loader.getDriverCode("valid-parentheses", "java"));
        assertNotNull(loader.getDriverCode("palindrome-number", "java"));
    }

    @Test
    void loadsAllPythonTemplates() {
        assertNotNull(loader.getDriverCode("two-sum", "python"));
        assertNotNull(loader.getDriverCode("fizzbuzz", "python"));
        assertNotNull(loader.getDriverCode("reverse-string", "python"));
        assertNotNull(loader.getDriverCode("valid-parentheses", "python"));
        assertNotNull(loader.getDriverCode("palindrome-number", "python"));
    }

    @Test
    void templateContainsUserCodePlaceholder() {
        String template = loader.getDriverCode("two-sum", "java");
        assertTrue(template.contains("{USER_CODE}"));
    }

    @Test
    void hasDriverCode_returnsTrueForExisting() {
        assertTrue(loader.hasDriverCode("two-sum", "java"));
        assertTrue(loader.hasDriverCode("two-sum", "python"));
    }

    @Test
    void hasDriverCode_returnsFalseForMissing() {
        assertFalse(loader.hasDriverCode("nonexistent", "java"));
        assertFalse(loader.hasDriverCode("two-sum", "rust"));
    }

    @Test
    void getDriverCode_throwsForMissingTemplate() {
        assertThrows(IllegalArgumentException.class,
                () -> loader.getDriverCode("nonexistent", "java"));
    }

    @Test
    void resolveLibMarkers_noMarkers_returnsUnchanged() {
        String template = "some code without markers";
        String result = loader.resolveLibMarkers(template, "java");
        assertTrue(result.equals(template));
    }

    @Test
    void resolveLibMarkers_hashMarker_resolvesCorrectly() {
        String template = "# {{LIB:JsonOutput}}\nsome code";
        String result = loader.resolveLibMarkers(template, "java");
        assertTrue(result.contains("class JsonOutput"));
        assertFalse(result.contains("# {{LIB:"));
    }

    @Test
    void javaFizzbuzzDriver_usesJsonOutput() {
        String template = loader.getDriverCode("fizzbuzz", "java");
        assertTrue(template.contains("JsonOutput.stringList("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void javaTwoSumDriver_usesJsonOutput() {
        String template = loader.getDriverCode("two-sum", "java");
        assertTrue(template.contains("JsonOutput.intArray("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void javaReverseStringDriver_usesJsonOutput() {
        String template = loader.getDriverCode("reverse-string", "java");
        assertTrue(template.contains("JsonOutput.charArray("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void loadsAllJavascriptTemplates() {
        assertNotNull(loader.getDriverCode("two-sum", "javascript"));
        assertNotNull(loader.getDriverCode("fizzbuzz", "javascript"));
        assertNotNull(loader.getDriverCode("reverse-string", "javascript"));
        assertNotNull(loader.getDriverCode("valid-parentheses", "javascript"));
        assertNotNull(loader.getDriverCode("palindrome-number", "javascript"));
    }

    @Test
    void loadsAllCppTemplates() {
        assertNotNull(loader.getDriverCode("two-sum", "cpp"));
        assertNotNull(loader.getDriverCode("fizzbuzz", "cpp"));
        assertNotNull(loader.getDriverCode("reverse-string", "cpp"));
        assertNotNull(loader.getDriverCode("valid-parentheses", "cpp"));
        assertNotNull(loader.getDriverCode("palindrome-number", "cpp"));
    }

    @Test
    void javascriptDrivers_useJsonStringify() {
        String twoSum = loader.getDriverCode("two-sum", "javascript");
        assertTrue(twoSum.contains("JSON.stringify("));

        String fizzbuzz = loader.getDriverCode("fizzbuzz", "javascript");
        assertTrue(fizzbuzz.contains("JSON.stringify("));

        String reverseString = loader.getDriverCode("reverse-string", "javascript");
        assertTrue(reverseString.contains("JSON.stringify("));
    }

    @Test
    void cppTwoSumDriver_usesJsonOutput() {
        String template = loader.getDriverCode("two-sum", "cpp");
        assertTrue(template.contains("JsonOutput::intVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void cppFizzbuzzDriver_usesJsonOutput() {
        String template = loader.getDriverCode("fizzbuzz", "cpp");
        assertTrue(template.contains("JsonOutput::stringVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void cppReverseStringDriver_usesJsonOutput() {
        String template = loader.getDriverCode("reverse-string", "cpp");
        assertTrue(template.contains("JsonOutput::charVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void pythonDrivers_useJsonDumps() {
        String twoSum = loader.getDriverCode("two-sum", "python");
        assertTrue(twoSum.contains("json.dumps("));

        String fizzbuzz = loader.getDriverCode("fizzbuzz", "python");
        assertTrue(fizzbuzz.contains("json.dumps("));

        String reverseString = loader.getDriverCode("reverse-string", "python");
        assertTrue(reverseString.contains("json.dumps("));
    }
}
