package com.codebite.judge.client;

import com.codebite.common.exception.JudgeExecutionException;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Component
public class JudgeClientImpl implements JudgeClient {

    private final RestTemplate judgeRestTemplate;
    private final String baseUrl;

    public JudgeClientImpl(RestTemplate judgeRestTemplate,
                           @Value("${app.judge0.url}") String baseUrl) {
        this.judgeRestTemplate = judgeRestTemplate;
        this.baseUrl = baseUrl;
    }

    @Override
    public JudgeResponse submit(JudgeRequest request) {
        String url = baseUrl + "/submissions?base64_encoded=false&wait=true";
        try {
            return judgeRestTemplate.postForObject(url, request, JudgeResponse.class);
        } catch (RestClientException e) {
            throw new JudgeExecutionException("Failed to communicate with Judge0: " + e.getMessage(), e);
        }
    }
}
