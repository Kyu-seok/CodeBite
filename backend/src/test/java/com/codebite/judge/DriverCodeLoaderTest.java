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
        assertNotNull(loader.getDriverCode("snack-drawer-pair", "java"));
        assertNotNull(loader.getDriverCode("chat-log-codec", "java"));
        assertNotNull(loader.getDriverCode("top-espresso-machines", "java"));
        assertNotNull(loader.getDriverCode("valid-brackets", "java"));
        assertNotNull(loader.getDriverCode("spot-duplicate-locker", "java"));
    }

    @Test
    void loadsAllPythonTemplates() {
        assertNotNull(loader.getDriverCode("snack-drawer-pair", "python"));
        assertNotNull(loader.getDriverCode("chat-log-codec", "python"));
        assertNotNull(loader.getDriverCode("top-espresso-machines", "python"));
        assertNotNull(loader.getDriverCode("valid-brackets", "python"));
        assertNotNull(loader.getDriverCode("spot-duplicate-locker", "python"));
    }

    @Test
    void templateContainsUserCodePlaceholder() {
        String template = loader.getDriverCode("snack-drawer-pair", "java");
        assertTrue(template.contains("{USER_CODE}"));
    }

    @Test
    void hasDriverCode_returnsTrueForExisting() {
        assertTrue(loader.hasDriverCode("snack-drawer-pair", "java"));
        assertTrue(loader.hasDriverCode("snack-drawer-pair", "python"));
    }

    @Test
    void hasDriverCode_returnsFalseForMissing() {
        assertFalse(loader.hasDriverCode("nonexistent", "java"));
        assertFalse(loader.hasDriverCode("snack-drawer-pair", "rust"));
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
        String template = loader.getDriverCode("chat-log-codec", "java");
        assertTrue(template.contains("JsonOutput.stringList("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void javaTwoSumDriver_usesJsonOutput() {
        String template = loader.getDriverCode("snack-drawer-pair", "java");
        assertTrue(template.contains("JsonOutput.intArray("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void javaKMostFrequentDriver_usesJsonOutput() {
        String template = loader.getDriverCode("top-espresso-machines", "java");
        assertTrue(template.contains("JsonOutput.intArray("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void loadsAllJavascriptTemplates() {
        assertNotNull(loader.getDriverCode("snack-drawer-pair", "javascript"));
        assertNotNull(loader.getDriverCode("chat-log-codec", "javascript"));
        assertNotNull(loader.getDriverCode("top-espresso-machines", "javascript"));
        assertNotNull(loader.getDriverCode("valid-brackets", "javascript"));
        assertNotNull(loader.getDriverCode("spot-duplicate-locker", "javascript"));
    }

    @Test
    void loadsAllCppTemplates() {
        assertNotNull(loader.getDriverCode("snack-drawer-pair", "cpp"));
        assertNotNull(loader.getDriverCode("chat-log-codec", "cpp"));
        assertNotNull(loader.getDriverCode("top-espresso-machines", "cpp"));
        assertNotNull(loader.getDriverCode("valid-brackets", "cpp"));
        assertNotNull(loader.getDriverCode("spot-duplicate-locker", "cpp"));
    }

    @Test
    void javascriptDrivers_useJsonStringify() {
        String twoSum = loader.getDriverCode("snack-drawer-pair", "javascript");
        assertTrue(twoSum.contains("JSON.stringify("));

        String chatLogCodec = loader.getDriverCode("chat-log-codec", "javascript");
        assertTrue(chatLogCodec.contains("JSON.stringify("));

        String kMostFrequent = loader.getDriverCode("top-espresso-machines", "javascript");
        assertTrue(kMostFrequent.contains("JSON.stringify("));
    }

    @Test
    void cppTwoSumDriver_usesJsonOutput() {
        String template = loader.getDriverCode("snack-drawer-pair", "cpp");
        assertTrue(template.contains("JsonOutput::intVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void cppStringCodecDriver_usesJsonOutput() {
        String template = loader.getDriverCode("chat-log-codec", "cpp");
        assertTrue(template.contains("JsonOutput::stringVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void cppKMostFrequentDriver_usesJsonOutput() {
        String template = loader.getDriverCode("top-espresso-machines", "cpp");
        assertTrue(template.contains("JsonOutput::intVector("));
        assertTrue(template.contains("class JsonOutput"));
    }

    @Test
    void pythonDrivers_useJsonDumps() {
        String twoSum = loader.getDriverCode("snack-drawer-pair", "python");
        assertTrue(twoSum.contains("json.dumps("));

        String chatLogCodec = loader.getDriverCode("chat-log-codec", "python");
        assertTrue(chatLogCodec.contains("json.dumps("));

        String kMostFrequent = loader.getDriverCode("top-espresso-machines", "python");
        assertTrue(kMostFrequent.contains("json.dumps("));
    }
}
