package com.codebite.judge.client;

import com.codebite.common.exception.JudgeExecutionException;
import com.codebite.config.JudgeClientConfig;
import com.codebite.judge.dto.BatchGetResponse;
import com.codebite.judge.dto.BatchSubmitRequest;
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

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;

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
        // base64_encoded=true is required: g++ can emit non-UTF-8 bytes in
        // compile_output (locale-dependent quote characters), which Judge0
        // refuses to serialize as plain text.
        String url = baseUrl + "/submissions?base64_encoded=true";
        try {
            log.debug("Judge0 request: sourceCode.length={}, languageId={}, stdin.length={}",
                    request.sourceCode() != null ? request.sourceCode().length() : 0,
                    request.languageId(),
                    request.stdin() != null ? request.stdin().length() : 0);

            JudgeRequest encoded = new JudgeRequest(
                    encode(request.sourceCode()),
                    request.languageId(),
                    encode(request.stdin())
            );
            byte[] body = judgeObjectMapper.writeValueAsBytes(encoded);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setContentLength(body.length);

            HttpEntity<byte[]> entity = new HttpEntity<>(body, headers);

            JudgeResponse response = judgeRestTemplate.postForObject(url, entity, JudgeResponse.class);
            log.debug("Judge0 response: {}", response);
            // POST only returns {token}; no output fields to decode yet.
            return response;
        } catch (JsonProcessingException e) {
            throw new JudgeExecutionException("Failed to serialize Judge0 request: " + e.getMessage(), e);
        } catch (RestClientException e) {
            throw new JudgeExecutionException("Failed to communicate with Judge0: " + e.getMessage(), e);
        }
    }

    @Override
    public JudgeResponse getSubmission(String token) {
        String url = baseUrl + "/submissions/" + token + "?base64_encoded=true";
        try {
            JudgeResponse response = judgeRestTemplate.getForObject(url, JudgeResponse.class);
            JudgeResponse decoded = decodeResponse(response);
            log.debug("Judge0 poll response for token {}: {}", token, decoded);
            return decoded;
        } catch (RestClientException e) {
            throw new JudgeExecutionException("Failed to poll Judge0 submission: " + e.getMessage(), e);
        }
    }

    @Override
    public List<JudgeResponse> submitBatch(List<JudgeRequest> requests) {
        if (requests.isEmpty()) {
            return List.of();
        }
        String url = baseUrl + "/submissions/batch?base64_encoded=true";
        try {
            List<JudgeRequest> encoded = requests.stream()
                    .map(r -> new JudgeRequest(encode(r.sourceCode()), r.languageId(), encode(r.stdin())))
                    .toList();
            byte[] body = judgeObjectMapper.writeValueAsBytes(new BatchSubmitRequest(encoded));

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setContentLength(body.length);

            HttpEntity<byte[]> entity = new HttpEntity<>(body, headers);

            // Judge0 returns a flat array of {token} objects for batch submit.
            JudgeResponse[] response = judgeRestTemplate.postForObject(url, entity, JudgeResponse[].class);
            log.debug("Judge0 batch submit response: {} tokens", response != null ? response.length : 0);
            return response == null ? List.of() : List.of(response);
        } catch (JsonProcessingException e) {
            throw new JudgeExecutionException("Failed to serialize Judge0 batch request: " + e.getMessage(), e);
        } catch (RestClientException e) {
            throw new JudgeExecutionException("Failed to submit Judge0 batch: " + e.getMessage(), e);
        }
    }

    @Override
    public List<JudgeResponse> getBatch(List<String> tokens) {
        if (tokens.isEmpty()) {
            return List.of();
        }
        // Judge0 wraps batch GET in {"submissions": [...]}, unlike single GET.
        String url = baseUrl + "/submissions/batch?tokens=" + String.join(",", tokens)
                + "&base64_encoded=true";
        try {
            BatchGetResponse response = judgeRestTemplate.getForObject(url, BatchGetResponse.class);
            if (response == null || response.submissions() == null) {
                return List.of();
            }
            List<JudgeResponse> decoded = response.submissions().stream()
                    .map(JudgeClientImpl::decodeResponse)
                    .toList();
            log.debug("Judge0 batch poll response: {} results", decoded.size());
            return decoded;
        } catch (RestClientException e) {
            throw new JudgeExecutionException("Failed to poll Judge0 batch: " + e.getMessage(), e);
        }
    }

    private static String encode(String s) {
        if (s == null) return null;
        return Base64.getEncoder().encodeToString(s.getBytes(StandardCharsets.UTF_8));
    }

    private static String decode(String s) {
        if (s == null) return null;
        try {
            // MIME decoder tolerates embedded whitespace/newlines that Judge0
            // occasionally inserts into long base64 strings.
            byte[] bytes = Base64.getMimeDecoder().decode(s);
            return new String(bytes, StandardCharsets.UTF_8);
        } catch (IllegalArgumentException e) {
            log.warn("Failed to base64-decode Judge0 field, returning raw: {}", e.getMessage());
            return s;
        }
    }

    private static JudgeResponse decodeResponse(JudgeResponse r) {
        if (r == null) return null;
        return new JudgeResponse(
                r.token(),
                r.status(),
                decode(r.stdout()),
                decode(r.stderr()),
                decode(r.compileOutput()),
                r.time(),
                r.memory()
        );
    }
}
