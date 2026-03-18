package com.codebite.judge;

import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.judge.service.JudgeService;
import com.codebite.submission.entity.SubmissionStatus;
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
        assertEquals(71, judgeService.mapLanguageToId("python"));
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
        assertEquals(71, judgeService.mapLanguageToId("Python"));
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

    // --- mapStatus ---

    @Test
    void mapStatus_status3_outputMatches_accepted() {
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), "[0,1]\n", null, null, "0.01", 9400);

        assertEquals(SubmissionStatus.ACCEPTED, judgeService.mapStatus(response, "[0,1]"));
    }

    @Test
    void mapStatus_status3_outputDiffers_wrongAnswer() {
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), "[1,2]\n", null, null, "0.01", 9400);

        assertEquals(SubmissionStatus.WRONG_ANSWER, judgeService.mapStatus(response, "[0,1]"));
    }

    @Test
    void mapStatus_status3_trimsWhitespace() {
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), "  [0,1]  \n", null, null, "0.01", 9400);

        assertEquals(SubmissionStatus.ACCEPTED, judgeService.mapStatus(response, "  [0,1]  "));
    }

    @Test
    void mapStatus_status3_nullStdout_wrongAnswer() {
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), null, null, null, "0.01", 9400);

        assertEquals(SubmissionStatus.WRONG_ANSWER, judgeService.mapStatus(response, "[0,1]"));
    }

    @Test
    void mapStatus_status5_timeLimitExceeded() {
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(5, "Time Limit Exceeded"), null, null, null, null, null);

        assertEquals(SubmissionStatus.TIME_LIMIT_EXCEEDED, judgeService.mapStatus(response, "expected"));
    }

    @Test
    void mapStatus_status6_compilationError() {
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(6, "Compilation Error"), null, null, "error msg", null, null);

        assertEquals(SubmissionStatus.COMPILATION_ERROR, judgeService.mapStatus(response, "expected"));
    }

    @Test
    void mapStatus_status7to12_runtimeError() {
        for (int statusId = 7; statusId <= 12; statusId++) {
            JudgeResponse response = new JudgeResponse(
                    null, new JudgeResponse.Status(statusId, "Runtime Error"), null, "SIGSEGV", null, null, null);

            assertEquals(SubmissionStatus.RUNTIME_ERROR, judgeService.mapStatus(response, "expected"));
        }
    }

    @Test
    void mapStatus_status13plus_internalError() {
        JudgeResponse response = new JudgeResponse(
                null, new JudgeResponse.Status(13, "Internal Error"), null, null, null, null, null);

        assertEquals(SubmissionStatus.INTERNAL_ERROR, judgeService.mapStatus(response, "expected"));
    }
}
