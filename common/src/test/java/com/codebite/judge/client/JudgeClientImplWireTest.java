package com.codebite.judge.client;

import com.codebite.config.JudgeClientConfig;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * What Judge0 receives from the {@link JudgeClientImpl} that {@link JudgeClientConfig} wires: a
 * JSON body with a Content-Length and never chunked, since Judge0 answers a chunked body with 422.
 */
class JudgeClientImplWireTest {

    private record Received(String method, String pathAndQuery, Headers headers, byte[] body) {}

    private final ObjectMapper json = new ObjectMapper();
    private final AtomicReference<Received> received = new AtomicReference<>();
    private HttpServer judge0;
    private JudgeClient client;

    @BeforeEach
    void startJudge0StandIn() throws IOException {
        // 127.0.0.1, not the wildcard address: macOS can hand out a port another process holds there (#247).
        judge0 = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        judge0.createContext("/submissions", exchange -> {
            byte[] body;
            try (InputStream in = exchange.getRequestBody()) {
                body = in.readAllBytes();
            }
            received.set(new Received(exchange.getRequestMethod(), exchange.getRequestURI().toString(),
                    exchange.getRequestHeaders(), body));
            byte[] response = (exchange.getRequestURI().getPath().endsWith("/batch")
                    ? "[{\"token\":\"t1\"},{\"token\":\"t2\"}]"
                    : "{\"token\":\"t1\"}").getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(201, response.length);
            try (OutputStream out = exchange.getResponseBody()) {
                out.write(response);
            }
        });
        judge0.start();
        client = new JudgeClientImpl(new JudgeClientConfig().judgeRestTemplate(),
                "http://127.0.0.1:" + judge0.getAddress().getPort());
    }

    @AfterEach
    void stopJudge0StandIn() {
        judge0.stop(0);
    }

    @Test
    void submitSendsOneSizedJsonBodyWithTheCodeAndStdinInBase64() throws IOException {
        JudgeResponse response = client.submit(new JudgeRequest("print('한글')", 71, "1 2\n"));

        Received request = received.get();
        assertThat(request.method()).isEqualTo("POST");
        assertThat(request.pathAndQuery()).isEqualTo("/submissions?base64_encoded=true");
        assertSizedJson(request);

        JsonNode body = json.readTree(request.body());
        assertThat(body.get("language_id").asInt()).isEqualTo(71);
        assertThat(decode(body.get("source_code"))).isEqualTo("print('한글')");
        assertThat(decode(body.get("stdin"))).isEqualTo("1 2\n");
        assertThat(response.token()).isEqualTo("t1");
    }

    @Test
    void submitBatchSendsOneSizedJsonBodyWithEverySubmission() throws IOException {
        List<JudgeResponse> responses = client.submitBatch(List.of(
                new JudgeRequest("class Solution {}", 62, "a"),
                new JudgeRequest("class Solution {}", 62, "b")));

        Received request = received.get();
        assertThat(request.method()).isEqualTo("POST");
        assertThat(request.pathAndQuery()).isEqualTo("/submissions/batch?base64_encoded=true");
        assertSizedJson(request);

        JsonNode submissions = json.readTree(request.body()).get("submissions");
        assertThat(submissions).hasSize(2);
        assertThat(decode(submissions.get(0).get("stdin"))).isEqualTo("a");
        assertThat(decode(submissions.get(1).get("stdin"))).isEqualTo("b");
        assertThat(submissions.get(1).get("language_id").asInt()).isEqualTo(62);
        assertThat(responses).extracting(JudgeResponse::token).containsExactly("t1", "t2");
    }

    private static void assertSizedJson(Received request) {
        assertThat(request.headers().getFirst("Content-Type")).startsWith("application/json");
        assertThat(request.headers().get("Transfer-Encoding")).isNull();
        assertThat(request.headers().getFirst("Content-Length"))
                .isEqualTo(String.valueOf(request.body().length));
    }

    private static String decode(JsonNode base64) {
        return new String(Base64.getDecoder().decode(base64.asText()), StandardCharsets.UTF_8);
    }
}
