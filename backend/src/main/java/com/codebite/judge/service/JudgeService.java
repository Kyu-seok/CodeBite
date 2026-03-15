package com.codebite.judge.service;

import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.submission.entity.SubmissionStatus;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class JudgeService {

    private static final Map<String, Integer> LANGUAGE_IDS = Map.of(
            "java", 62,
            "python", 71
    );

    private final JudgeClient judgeClient;

    public JudgeService(JudgeClient judgeClient) {
        this.judgeClient = judgeClient;
    }

    public String buildSourceCode(String driverTemplate, String userCode) {
        return driverTemplate.replace("{USER_CODE}", userCode);
    }

    public int mapLanguageToId(String language) {
        Integer id = LANGUAGE_IDS.get(language.toLowerCase());
        if (id == null) {
            throw new IllegalArgumentException("Unsupported language: " + language);
        }
        return id;
    }

    public boolean isLanguageSupported(String language) {
        return LANGUAGE_IDS.containsKey(language.toLowerCase());
    }

    public JudgeResponse execute(String sourceCode, int languageId, String stdin) {
        JudgeRequest request = new JudgeRequest(sourceCode, languageId, stdin);
        return judgeClient.submit(request);
    }

    public SubmissionStatus mapStatus(JudgeResponse response, String expectedOutput) {
        int statusId = response.status().id();

        // Status 3 = program ran successfully, compare output
        if (statusId == 3) {
            String actual = response.stdout() != null ? response.stdout().trim() : "";
            String expected = expectedOutput.trim();
            return actual.equals(expected) ? SubmissionStatus.ACCEPTED : SubmissionStatus.WRONG_ANSWER;
        }

        // Status 5 = Time Limit Exceeded
        if (statusId == 5) {
            return SubmissionStatus.TIME_LIMIT_EXCEEDED;
        }

        // Status 6 = Compilation Error
        if (statusId == 6) {
            return SubmissionStatus.COMPILATION_ERROR;
        }

        // Status 7-12 = Runtime Error variants
        if (statusId >= 7 && statusId <= 12) {
            return SubmissionStatus.RUNTIME_ERROR;
        }

        // Status 13+ = Internal Error
        return SubmissionStatus.INTERNAL_ERROR;
    }
}
