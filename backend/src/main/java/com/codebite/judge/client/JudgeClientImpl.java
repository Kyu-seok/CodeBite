package com.codebite.judge.client;

import com.codebite.common.exception.JudgeExecutionException;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Component
public class JudgeClientImpl implements JudgeClient {

    private static final Logger log = LoggerFactory.getLogger(JudgeClientImpl.class);

    private final RestTemplate judgeRestTemplate;
    private final String baseUrl;

    public JudgeClientImpl(RestTemplate judgeRestTemplate,
                           @Value("${app.judge0.url}") String baseUrl) {
        this.judgeRestTemplate = judgeRestTemplate;
        this.baseUrl = baseUrl;
    }

    @Override
    public JudgeResponse submit(JudgeRequest request) {
        String url = baseUrl + "/submissions?base64_encoded=false";
        try {
            log.debug("Judge0 request: sourceCode.length={}, languageId={}, stdin.length={}",
                    request.sourceCode() != null ? request.sourceCode().length() : 0,
                    request.languageId(),
                    request.stdin() != null ? request.stdin().length() : 0);
            JudgeResponse response = judgeRestTemplate.postForObject(url, request, JudgeResponse.class);
            log.debug("Judge0 response: {}", response);
            return response;
        } catch (RestClientException e) {
            throw new JudgeExecutionException("Failed to communicate with Judge0: " + e.getMessage(), e);
        }
    }

    @Override
    public JudgeResponse getSubmission(String token) {
        String url = baseUrl + "/submissions/" + token + "?base64_encoded=false";
        try {
            JudgeResponse response = judgeRestTemplate.getForObject(url, JudgeResponse.class);
            log.debug("Judge0 poll response for token {}: {}", token, response);
            return response;
        } catch (RestClientException e) {
            throw new JudgeExecutionException("Failed to poll Judge0 submission: " + e.getMessage(), e);
        }
    }
}
