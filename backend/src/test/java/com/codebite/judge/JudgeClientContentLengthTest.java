package com.codebite.judge;

import com.codebite.judge.dto.JudgeRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import static org.junit.jupiter.api.Assertions.*;

class JudgeClientContentLengthTest {

    private HttpServer server;
    private int port;
    private final ConcurrentMap<String, List<String>> capturedHeaders = new ConcurrentHashMap<>();

    @BeforeEach
    void setUp() throws IOException {
        server = HttpServer.create(new InetSocketAddress(0), 0);
        port = server.getAddress().getPort();

        server.createContext("/submissions", exchange -> {
            exchange.getRequestHeaders().forEach(capturedHeaders::put);

            String response = "{\"token\":\"test-token\"}";
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(201, response.length());
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes());
            }
        });

        server.start();
    }

    @AfterEach
    void tearDown() {
        server.stop(0);
    }

    @Test
    void postToJudge0_shouldUseContentLength_notChunkedTransferEncoding() throws Exception {
        // Same config as JudgeClientConfig
        ObjectMapper mapper = new ObjectMapper();
        mapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);

        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();

        ByteArrayHttpMessageConverter byteConverter = new ByteArrayHttpMessageConverter();
        byteConverter.setSupportedMediaTypes(List.of(MediaType.APPLICATION_JSON, MediaType.APPLICATION_OCTET_STREAM));

        RestTemplate restTemplate = new RestTemplate(factory);
        restTemplate.setMessageConverters(List.of(byteConverter, new MappingJackson2HttpMessageConverter(mapper)));

        // Pre-serialize body to bytes — same approach as JudgeClientImpl.submit()
        JudgeRequest request = new JudgeRequest(
                "public class Main { public static void main(String[] args) { System.out.println(42); } }",
                62,
                "test input"
        );
        byte[] body = mapper.writeValueAsBytes(request);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setContentLength(body.length);

        HttpEntity<byte[]> entity = new HttpEntity<>(body, headers);

        String url = "http://localhost:" + port + "/submissions?base64_encoded=true";
        try {
            restTemplate.postForObject(url, entity, String.class);
        } catch (Exception ignored) {
            // Response parsing may fail — we only care about outgoing request headers
        }

        // Verify Content-Length is present
        assertTrue(capturedHeaders.containsKey("Content-length"),
                "Request must include Content-Length header. Headers received: " + capturedHeaders.keySet());

        String contentLength = capturedHeaders.get("Content-length").get(0);
        assertTrue(Integer.parseInt(contentLength) > 0,
                "Content-Length must be a positive integer, got: " + contentLength);

        // Verify Transfer-Encoding: chunked is NOT present
        if (capturedHeaders.containsKey("Transfer-encoding")) {
            List<String> te = capturedHeaders.get("Transfer-encoding");
            te.forEach(value ->
                    assertFalse(value.toLowerCase().contains("chunked"),
                            "Request must NOT use chunked Transfer-Encoding, got: " + value));
        }
    }
}
