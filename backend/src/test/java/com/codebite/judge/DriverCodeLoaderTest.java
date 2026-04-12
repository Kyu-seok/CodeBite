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
        assertNotNull(loader.getDriverCode("pair-sum", "java"));
        assertNotNull(loader.getDriverCode("string-codec", "java"));
        assertNotNull(loader.getDriverCode("k-most-frequent", "java"));
        assertNotNull(loader.getDriverCode("bracket-validator", "java"));
        assertNotNull(loader.getDriverCode("find-duplicates", "java"));
    }

    @Test
    void loadsAllPythonTemplates() {
        assertNotNull(loader.getDriverCode("pair-sum", "python"));
        assertNotNull(loader.getDriverCode("string-codec", "python"));
        assertNotNull(loader.getDriverCode("k-most-frequent", "python"));
        assertNotNull(loader.getDriverCode("bracket-validator", "python"));
        assertNotNull(loader.getDriverCode("find-duplicates", "python"));
    }

    @Test
    void templateContainsUserCodePlaceholder() {
        String template = loader.getDriverCode("pair-sum", "java");
        assertTrue(template.contains("{USER_CODE}"));
    }

    @Test
    void hasDriverCode_returnsTrueForExisting() {
        assertTrue(loader.hasDriverCode("pair-sum", "java"));
        assertTrue(loader.hasDriverCode("pair-sum", "python"));
    }

    @Test
    void hasDriverCode_returnsFalseForMissing() {
        assertFalse(loader.hasDriverCode("nonexistent", "java"));
        assertFalse(loader.hasDriverCode("pair-sum", "rust"));
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
    void javaStringCodecDriver_usesJsonOutput() {
        String template = loader.getDriverCode("string-codec", "java");
        assertTrue(template.contains("JsonOutput.stringList("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void javaTwoSumDriver_usesJsonOutput() {
        String template = loader.getDriverCode("pair-sum", "java");
        assertTrue(template.contains("JsonOutput.intArray("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void javaKMostFrequentDriver_usesJsonOutput() {
        String template = loader.getDriverCode("k-most-frequent", "java");
        assertTrue(template.contains("JsonOutput.intArray("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void loadsAllJavascriptTemplates() {
        assertNotNull(loader.getDriverCode("pair-sum", "javascript"));
        assertNotNull(loader.getDriverCode("string-codec", "javascript"));
        assertNotNull(loader.getDriverCode("k-most-frequent", "javascript"));
        assertNotNull(loader.getDriverCode("bracket-validator", "javascript"));
        assertNotNull(loader.getDriverCode("find-duplicates", "javascript"));
    }

    @Test
    void loadsAllCppTemplates() {
        assertNotNull(loader.getDriverCode("pair-sum", "cpp"));
        assertNotNull(loader.getDriverCode("string-codec", "cpp"));
        assertNotNull(loader.getDriverCode("k-most-frequent", "cpp"));
        assertNotNull(loader.getDriverCode("bracket-validator", "cpp"));
        assertNotNull(loader.getDriverCode("find-duplicates", "cpp"));
    }

    @Test
    void javascriptDrivers_useJsonStringify() {
        String twoSum = loader.getDriverCode("pair-sum", "javascript");
        assertTrue(twoSum.contains("JSON.stringify("));

        String stringCodec = loader.getDriverCode("string-codec", "javascript");
        assertTrue(stringCodec.contains("JSON.stringify("));

        String kMostFrequent = loader.getDriverCode("k-most-frequent", "javascript");
        assertTrue(kMostFrequent.contains("JSON.stringify("));
    }

    @Test
    void cppTwoSumDriver_usesJsonOutput() {
        String template = loader.getDriverCode("pair-sum", "cpp");
        assertTrue(template.contains("JsonOutput::intVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void cppStringCodecDriver_usesJsonOutput() {
        String template = loader.getDriverCode("string-codec", "cpp");
        assertTrue(template.contains("JsonOutput::stringVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void cppKMostFrequentDriver_usesJsonOutput() {
        String template = loader.getDriverCode("k-most-frequent", "cpp");
        assertTrue(template.contains("JsonOutput::intVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void pythonDrivers_useJsonDumps() {
        String twoSum = loader.getDriverCode("pair-sum", "python");
        assertTrue(twoSum.contains("json.dumps("));

        String stringCodec = loader.getDriverCode("string-codec", "python");
        assertTrue(stringCodec.contains("json.dumps("));

        String kMostFrequent = loader.getDriverCode("k-most-frequent", "python");
        assertTrue(kMostFrequent.contains("json.dumps("));
    }
}
