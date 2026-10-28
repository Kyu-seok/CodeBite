package com.codebite.judge;

import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.service.JudgeService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(MockitoExtension.class)
class JudgeServiceTest {

    @Mock
    private JudgeClient judgeClient;

    private JudgeService judgeService;

    @BeforeEach
    void setUp() {
        judgeService = new JudgeService(judgeClient, 100, 5000);
    }

    // --- buildSourceCode ---

    @Test
    void buildSourceCode_replacesPlaceholder() {
        String template = "import java.util.*;\n\n{USER_CODE}\n\npublic class Main {}";
        String userCode = "class Solution { int solve() { return 42; } }";

        String result = judgeService.buildSourceCode(template, userCode);

        assertTrue(result.contains("class Solution { int solve() { return 42; } }"));
        assertFalse(result.contains("{USER_CODE}"));
    }

    // --- mapLanguageToId ---

    @Test
    void mapLanguageToId_java() {
        assertEquals(62, judgeService.mapLanguageToId("java"));
    }

    @Test
    void mapLanguageToId_python() {
        assertEquals(100, judgeService.mapLanguageToId("python"));
    }

    @Test
    void mapLanguageToId_javascript() {
        assertEquals(63, judgeService.mapLanguageToId("javascript"));
    }

    @Test
    void mapLanguageToId_cpp() {
        assertEquals(54, judgeService.mapLanguageToId("cpp"));
    }

    @Test
    void mapLanguageToId_caseInsensitive() {
        assertEquals(62, judgeService.mapLanguageToId("Java"));
        assertEquals(100, judgeService.mapLanguageToId("Python"));
    }

    @Test
    void mapLanguageToId_unsupported_throws() {
        assertThrows(IllegalArgumentException.class,
                () -> judgeService.mapLanguageToId("rust"));
    }

    @Test
    void isLanguageSupported_true() {
        assertTrue(judgeService.isLanguageSupported("java"));
        assertTrue(judgeService.isLanguageSupported("python"));
        assertTrue(judgeService.isLanguageSupported("javascript"));
        assertTrue(judgeService.isLanguageSupported("cpp"));
    }

    @Test
    void isLanguageSupported_false() {
        assertFalse(judgeService.isLanguageSupported("rust"));
    }
}
