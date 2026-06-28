package com.codebite.judge.service;

import com.codebite.common.exception.JudgeExecutionException;
import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.submission.entity.SubmissionStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class JudgeService {

    private static final Logger log = LoggerFactory.getLogger(JudgeService.class);

    private static final Map<String, Integer> LANGUAGE_IDS = Map.of(
            "java", 62,
            "python", 71,
            "javascript", 63,
            "cpp", 54
    );

    private final JudgeClient judgeClient;
    private final long pollIntervalMs;
    private final long pollTimeoutMs;

    public JudgeService(JudgeClient judgeClient,
                        @Value("${app.judge0.poll-interval-ms:150}") long pollIntervalMs,
                        @Value("${app.judge0.poll-timeout-ms:30000}") long pollTimeoutMs) {
        this.judgeClient = judgeClient;
        this.pollIntervalMs = pollIntervalMs;
        this.pollTimeoutMs = pollTimeoutMs;
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
        JudgeResponse submitResponse = judgeClient.submit(request);
        String token = submitResponse.token();

        long start = System.currentTimeMillis();
        while (true) {
            JudgeResponse result = judgeClient.getSubmission(token);
            if (isTerminal(result)) {
                return result;
            }
            if (System.currentTimeMillis() - start > pollTimeoutMs) {
                throw new JudgeExecutionException("Judge0 timed out after " + pollTimeoutMs + "ms", null);
            }
            sleepBetweenPolls();
        }
    }

    /**
     * Submits all stdins as a single Judge0 batch and polls the batch endpoint until every
     * submission reaches a terminal status. Results are returned in the same order as {@code stdins}.
     */
    public List<JudgeResponse> executeBatch(String sourceCode, int languageId, List<String> stdins) {
        if (stdins.isEmpty()) {
            return List.of();
        }

        List<JudgeRequest> requests = stdins.stream()
                .map(stdin -> new JudgeRequest(sourceCode, languageId, stdin))
                .toList();
        List<JudgeResponse> submitResponses = judgeClient.submitBatch(requests);

        if (submitResponses.size() != requests.size()) {
            throw new JudgeExecutionException(
                    "Judge0 batch submit returned " + submitResponses.size()
                            + " tokens but " + requests.size() + " were requested", null);
        }
        List<String> tokens = submitResponses.stream().map(JudgeResponse::token).toList();

        long start = System.currentTimeMillis();
        while (true) {
            List<JudgeResponse> results = judgeClient.getBatch(tokens);
            if (results.size() == tokens.size() && results.stream().allMatch(this::isTerminal)) {
                return results;
            }
            if (System.currentTimeMillis() - start > pollTimeoutMs) {
                throw new JudgeExecutionException(
                        "Judge0 batch timed out after " + pollTimeoutMs + "ms", null);
            }
            sleepBetweenPolls();
        }
    }

    private boolean isTerminal(JudgeResponse response) {
        // Judge0 status: 1=In Queue, 2=Processing. Anything else is a terminal result.
        return response != null && response.status() != null
                && response.status().id() != 1 && response.status().id() != 2;
    }

    private void sleepBetweenPolls() {
        try {
            Thread.sleep(pollIntervalMs);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new JudgeExecutionException("Judge0 polling interrupted", e);
        }
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
