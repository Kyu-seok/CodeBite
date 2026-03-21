package com.codebite.judge.client;

import com.codebite.common.exception.JudgeExecutionException;
import com.codebite.config.JudgeClientConfig;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Component
public class JudgeClientImpl implements JudgeClient {

    private static final Logger log = LoggerFactory.getLogger(JudgeClientImpl.class);

    private final RestTemplate judgeRestTemplate;
    private final ObjectMapper judgeObjectMapper;
    private final String baseUrl;

    public JudgeClientImpl(RestTemplate judgeRestTemplate,
                           @Value("${app.judge0.url}") String baseUrl) {
        this.judgeRestTemplate = judgeRestTemplate;
        this.judgeObjectMapper = JudgeClientConfig.createJudgeObjectMapper();
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

            byte[] body = judgeObjectMapper.writeValueAsBytes(request);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setContentLength(body.length);

            HttpEntity<byte[]> entity = new HttpEntity<>(body, headers);

            JudgeResponse response = judgeRestTemplate.postForObject(url, entity, JudgeResponse.class);
            log.debug("Judge0 response: {}", response);
            return response;
        } catch (JsonProcessingException e) {
            throw new JudgeExecutionException("Failed to serialize Judge0 request: " + e.getMessage(), e);
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
