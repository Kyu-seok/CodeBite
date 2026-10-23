package com.codebite.github.gateway;

import com.codebite.config.GitHubAppProperties;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.HttpServer;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.web.client.RestClient;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.time.Instant;
import java.util.Base64;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/** The real adapter against a local HTTP server standing in for github.com and api.github.com. */
class GitHubAppGatewayTest {

    private HttpServer server;
    private String baseUrl;
    /** Canned responses by "METHOD path": {status, body}. */
    private final Map<String, Object[]> responses = new ConcurrentHashMap<>();
    /** What reached the server by "METHOD path": {authorization header, body}. */
    private final Map<String, String[]> received = new ConcurrentHashMap<>();

    @BeforeEach
    void setUp() throws IOException {
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/", exchange -> {
            String key = exchange.getRequestMethod() + " " + exchange.getRequestURI().getPath();
            String body = new String(exchange.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);
            received.put(key, new String[] {exchange.getRequestHeaders().getFirst("Authorization"), body});
            Object[] response = responses.getOrDefault(key, new Object[] {404, "{\"message\":\"Not Found\"}"});
            byte[] bytes = ((String) response[1]).getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders((int) response[0], bytes.length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(bytes);
            }
        });
        server.start();
        baseUrl = "http://localhost:" + server.getAddress().getPort();

        respond("POST /login/oauth/access_token", 200, "{\"access_token\":\"user-token\",\"token_type\":\"bearer\"}");
        respond("GET /user", 200, "{\"id\":583231,\"login\":\"octocat\",\"type\":\"User\"}");
        respond("GET /user/installations", 200, "{\"total_count\":1,\"installations\":[{\"id\":77}]}");
        respond("POST /app/installations/77/access_tokens", 201, "{\"token\":\"installation-token\"}");
        respond("GET /installation/repositories", 200, """
                {"total_count":1,"repositories":[
                  {"id":1296269,"full_name":"octocat/solutions","default_branch":"main","private":true}]}
                """);
    }

    @AfterEach
    void tearDown() {
        server.stop(0);
    }

    @Test
    void resolvesTheAuthorisingAccountAndTheGrantedRepositories() {
        ResolvedInstallation installation = gateway(configured()).resolveInstallCallback("the-code", 77);

        assertThat(installation.account()).isEqualTo(new GitHubAccount(583231, "octocat"));
        assertThat(installation.installationId()).isEqualTo(77);
        assertThat(installation.repositories())
                .containsExactly(new GitHubRepo(1296269, "octocat/solutions", "main", true));

        assertThat(received.get("POST /login/oauth/access_token")[1])
                .contains("client_id=app-client-id", "client_secret=app-client-secret", "code=the-code");
        assertThat(received.get("GET /user")[0]).isEqualTo("Bearer user-token");
        assertThat(received.get("GET /user/installations")[0]).isEqualTo("Bearer user-token");
        assertThat(received.get("GET /installation/repositories")[0]).isEqualTo("Bearer installation-token");
    }

    @Test
    void mintsTheInstallationTokenWithAnRs256AppJwt() throws Exception {
        gateway(configured()).resolveInstallCallback("the-code", 77);

        String authorization = received.get("POST /app/installations/77/access_tokens")[0];
        assertThat(authorization).startsWith("Bearer ");
        Jws<Claims> jwt = Jwts.parser().verifyWith(publicKey()).build()
                .parseSignedClaims(authorization.substring("Bearer ".length()));
        assertThat(jwt.getHeader().getAlgorithm()).isEqualTo("RS256");
        assertThat(jwt.getPayload().getIssuer()).isEqualTo("12345");
        assertThat(jwt.getPayload().getExpiration()).isAfter(jwt.getPayload().getIssuedAt());
    }

    @Test
    void rejectsAnInstallationTheAccountCannotAccessWithoutTouchingIt() {
        respond("POST /app/installations/99/access_tokens", 201, "{\"token\":\"victim-token\"}");

        assertThatThrownBy(() -> gateway(configured()).resolveInstallCallback("the-code", 99))
                .isInstanceOf(GitHubInstallationNotAccessibleException.class);
        assertThat(received).doesNotContainKeys(
                "POST /app/installations/99/access_tokens", "GET /installation/repositories");
    }

    @Test
    void rejectsAnAuthorizationCodeGitHubRefuses() {
        // GitHub answers a bad code with 200 and an error field.
        respond("POST /login/oauth/access_token", 200, "{\"error\":\"bad_verification_code\"}");

        assertThatThrownBy(() -> gateway(configured()).resolveInstallCallback("stale-code", 77))
                .isInstanceOf(GitHubInstallationNotAccessibleException.class);
    }

    @Test
    void serverErrorsAreTransient() {
        respond("GET /user", 502, "{\"message\":\"Bad Gateway\"}");

        assertThatThrownBy(() -> gateway(configured()).resolveInstallCallback("the-code", 77))
                .isInstanceOf(GitHubTransientException.class);
    }

    @Test
    void anInstallationGitHubNoLongerHasIsGone() {
        respond("POST /app/installations/77/access_tokens", 404, "{\"message\":\"Not Found\"}");

        assertThatThrownBy(() -> gateway(configured()).resolveInstallCallback("the-code", 77))
                .isInstanceOf(GitHubInstallationGoneException.class);
    }

    @Test
    void refusesToRunWithoutAppConfig() {
        GitHubAppProperties empty = new GitHubAppProperties();
        empty.setApiBaseUrl(baseUrl);
        empty.setWebBaseUrl(baseUrl);

        assertThatThrownBy(() -> gateway(empty).resolveInstallCallback("the-code", 77))
                .isInstanceOf(GitHubAppNotConfiguredException.class);
        assertThat(received).isEmpty();
    }

    @Test
    void addsOneFileAsACommitThroughTheContentsApi() throws Exception {
        respond(CONTENTS, 201, """
                {"content":{"path":"two-sum/python/2026-10-19T140509Z.py"},
                 "commit":{"sha":"7638417db6d59f3c431d3e1f261cc637155684cd",
                           "html_url":"https://github.com/octocat/solutions/commit/7638417db6d59f3c431d3e1f261cc637155684cd"}}
                """);

        CommittedFile commit = gateway(configured()).addFile(77, "octocat/solutions", "main", solution());

        assertThat(commit).isEqualTo(new CommittedFile("7638417db6d59f3c431d3e1f261cc637155684cd",
                "https://github.com/octocat/solutions/commit/7638417db6d59f3c431d3e1f261cc637155684cd"));
        assertThat(received.get(CONTENTS)[0]).isEqualTo("Bearer installation-token");
        JsonNode body = new ObjectMapper().readTree(received.get(CONTENTS)[1]);
        assertThat(body.get("message").asText()).isEqualTo("Accepted: Two Sum (python) · 12 ms, 1.5 MB");
        assertThat(new String(Base64.getDecoder().decode(body.get("content").asText()), StandardCharsets.UTF_8))
                .isEqualTo("print('안녕')\n");
        assertThat(body.get("branch").asText()).isEqualTo("main");
        assertThat(body.get("author").get("name").asText()).isEqualTo("octocat");
        assertThat(body.get("author").get("email").asText()).isEqualTo("583231+octocat@users.noreply.github.com");
        assertThat(body.get("author").get("date").asText()).isEqualTo("2026-10-19T14:05:09Z");
        assertThat(body.has("sha")).as("never replaces an existing file").isFalse();
    }

    @Test
    void anExistingPathIsLeftAlone() {
        // GitHub's answer to a create on a path that exists: it wants the old blob's sha to replace it.
        respond(CONTENTS, 422, """
                {"message":"Invalid request.\\n\\n\\"sha\\" wasn't supplied.","status":"422"}
                """);

        assertThatThrownBy(() -> gateway(configured()).addFile(77, "octocat/solutions", "main", solution()))
                .isInstanceOf(GitHubFileExistsException.class);
    }

    @Test
    void aRepositoryTheInstallationNoLongerGrantsIsGone() {
        respond(CONTENTS, 404, "{\"message\":\"Not Found\"}");

        assertThatThrownBy(() -> gateway(configured()).addFile(77, "octocat/solutions", "main", solution()))
                .isInstanceOf(GitHubInstallationGoneException.class);
    }

    @Test
    void aServerErrorWhileCommittingIsTransient() {
        respond(CONTENTS, 503, "{\"message\":\"Service Unavailable\"}");

        assertThatThrownBy(() -> gateway(configured()).addFile(77, "octocat/solutions", "main", solution()))
                .isInstanceOf(GitHubTransientException.class);
    }

    private static final String CONTENTS =
            "PUT /repos/octocat/solutions/contents/two-sum/python/2026-10-19T140509Z.py";

    private static NewFile solution() {
        return new NewFile("two-sum/python/2026-10-19T140509Z.py", "print('안녕')\n",
                "Accepted: Two Sum (python) · 12 ms, 1.5 MB", new GitHubAccount(583231, "octocat"),
                Instant.parse("2026-10-19T14:05:09Z"));
    }

    private void respond(String key, int status, String body) {
        responses.put(key, new Object[] {status, body});
    }

    private GitHubAppGateway gateway(GitHubAppProperties properties) {
        return new GitHubAppGateway(properties, RestClient.builder());
    }

    private GitHubAppProperties configured() {
        GitHubAppProperties properties = new GitHubAppProperties();
        properties.setAppId("12345");
        properties.setClientId("app-client-id");
        properties.setClientSecret("app-client-secret");
        properties.setSlug("codebite-test");
        properties.setPrivateKeyBase64(Base64.getEncoder().encodeToString(resource("github/test-app-key.pem")));
        properties.setApiBaseUrl(baseUrl);
        properties.setWebBaseUrl(baseUrl);
        return properties;
    }

    private PublicKey publicKey() throws Exception {
        String pem = new String(resource("github/test-app-key.pub.pem"), StandardCharsets.US_ASCII)
                .replaceAll("-----[A-Z ]+-----", "").replaceAll("\\s", "");
        return KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(Base64.getDecoder().decode(pem)));
    }

    private static byte[] resource(String path) {
        try (InputStream in = GitHubAppGatewayTest.class.getClassLoader().getResourceAsStream(path)) {
            return Objects.requireNonNull(in, path).readAllBytes();
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }
}
