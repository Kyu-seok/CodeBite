package com.codebite.github.gateway;

import com.codebite.config.GitHubAppProperties;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.springframework.boot.web.client.ClientHttpRequestFactories;
import org.springframework.boot.web.client.ClientHttpRequestFactorySettings;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.function.Function;
import java.util.function.Supplier;

/**
 * {@link GitHubGateway} over GitHub's REST API, acting as the CodeBite GitHub App.
 *
 * <p>Nothing is read or validated at startup, so the backend boots without an App configured;
 * calls then fail with {@link GitHubAppNotConfiguredException}. Installation tokens are minted per
 * operation from an app JWT ({@link #installationToken}) and never cached or stored.
 */
@Component
public class GitHubAppGateway implements GitHubGateway {

    private static final int PAGE_SIZE = 100;
    /**
     * Bounds every request, so a hung GitHub surfaces as a {@link GitHubTransientException}
     * instead of holding a listener thread or a profile read.
     */
    private static final ClientHttpRequestFactorySettings TIMEOUTS = ClientHttpRequestFactorySettings.DEFAULTS
            .withConnectTimeout(Duration.ofSeconds(5))
            .withReadTimeout(Duration.ofSeconds(10));

    private final GitHubAppProperties properties;
    private final RestClient api;
    private final RestClient web;
    private volatile GitHubAppJwt appJwt;

    public GitHubAppGateway(GitHubAppProperties properties, RestClient.Builder restClientBuilder) {
        this.properties = properties;
        this.api = restClientBuilder.clone()
                .requestFactory(ClientHttpRequestFactories.get(TIMEOUTS))
                .baseUrl(properties.getApiBaseUrl())
                .defaultHeader(HttpHeaders.ACCEPT, "application/vnd.github+json")
                .defaultHeader("X-GitHub-Api-Version", "2022-11-28")
                .build();
        this.web = restClientBuilder.clone()
                .requestFactory(ClientHttpRequestFactories.get(TIMEOUTS))
                .baseUrl(properties.getWebBaseUrl())
                .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                .build();
    }

    @Override
    public ResolvedInstallation resolveInstallCallback(String authorizationCode, long installationId) {
        requireConfigured();
        String userToken = exchangeUserCode(authorizationCode);
        UserResponse user = call("GET /user", () -> api.get().uri("/user")
                .header(HttpHeaders.AUTHORIZATION, bearer(userToken))
                .retrieve().body(UserResponse.class));

        // The anti-hijack check: the installation id comes from the redirect and is untrusted.
        boolean accessible = paged("GET /user/installations",
                page -> api.get().uri("/user/installations?per_page={n}&page={p}", PAGE_SIZE, page)
                        .header(HttpHeaders.AUTHORIZATION, bearer(userToken))
                        .retrieve().body(InstallationsPage.class).installations())
                .stream().anyMatch(i -> i.id() == installationId);
        if (!accessible) {
            throw new GitHubInstallationNotAccessibleException(
                    "account " + user.id() + " cannot access installation " + installationId);
        }

        return new ResolvedInstallation(new GitHubAccount(user.id(), user.login()), installationId,
                listInstallationRepositories(installationId));
    }

    @Override
    public List<GitHubRepo> listInstallationRepositories(long installationId) {
        requireConfigured();
        String token = installationToken(installationId);
        return paged("GET /installation/repositories",
                page -> api.get().uri("/installation/repositories?per_page={n}&page={p}", PAGE_SIZE, page)
                        .header(HttpHeaders.AUTHORIZATION, bearer(token))
                        .retrieve().body(RepositoriesPage.class).repositories())
                .stream()
                .map(r -> new GitHubRepo(r.id(), r.fullName(), r.defaultBranch(), r.isPrivate()))
                .toList();
    }

    @Override
    public CommittedFile addFile(long installationId, String repositoryFullName, String branch, NewFile file) {
        requireConfigured();
        String token = installationToken(installationId);
        // No "sha" in the body, so GitHub only ever creates: an existing path is refused with 422.
        ContentsRequest request = new ContentsRequest(
                file.message(),
                Base64.getEncoder().encodeToString(file.content().getBytes(StandardCharsets.UTF_8)),
                branch,
                new Author(file.author().login(), file.author().noreplyEmail(),
                        DateTimeFormatter.ISO_INSTANT.format(file.authorDate())));
        String what = "PUT /repos/" + repositoryFullName + "/contents/" + file.path();
        try {
            ContentsResponse response = api.put()
                    .uri("/repos/" + repositoryFullName + "/contents/" + file.path())
                    .header(HttpHeaders.AUTHORIZATION, bearer(token))
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(request)
                    .retrieve().body(ContentsResponse.class);
            return new CommittedFile(response.commit().sha(), response.commit().htmlUrl());
        } catch (RestClientResponseException e) {
            int status = e.getStatusCode().value();
            if (status == 422 && e.getResponseBodyAsString().contains("sha")) {
                throw new GitHubFileExistsException(repositoryFullName + " already has " + file.path());
            }
            if (status == 404) {
                // The token was minted, so the installation exists but no longer grants this
                // repository: it was deleted or removed from the installation.
                throw new GitHubInstallationGoneException(
                        repositoryFullName + " is not reachable through installation " + installationId);
            }
            throw translate(what, e);
        } catch (ResourceAccessException e) {
            throw new GitHubTransientException(what + " unreachable", e);
        }
    }

    @Override
    public boolean isRepositoryReachable(long installationId, long repositoryId) {
        requireConfigured();
        String token;
        try {
            token = installationToken(installationId);
        } catch (GitHubInstallationGoneException e) {
            return false;
        }
        // An installation token only sees the repositories its installation grants; any other
        // repository, including a deleted one, is a 404.
        String what = "GET /repositories/" + repositoryId;
        try {
            api.get().uri("/repositories/{id}", repositoryId)
                    .header(HttpHeaders.AUTHORIZATION, bearer(token))
                    .retrieve().toBodilessEntity();
            return true;
        } catch (RestClientResponseException e) {
            if (e.getStatusCode().value() == 404) {
                return false;
            }
            throw translate(what, e);
        } catch (ResourceAccessException e) {
            throw new GitHubTransientException(what + " unreachable", e);
        }
    }

    /** Exchanges a user authorization code for a user-to-server token, using the App's client. */
    private String exchangeUserCode(String code) {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("client_id", properties.getClientId());
        form.add("client_secret", properties.getClientSecret());
        form.add("code", code);
        TokenExchangeResponse response = call("POST /login/oauth/access_token", () -> web.post()
                .uri("/login/oauth/access_token")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(form)
                .retrieve().body(TokenExchangeResponse.class));
        if (response == null || response.accessToken() == null) {
            throw new GitHubInstallationNotAccessibleException(
                    "authorization code rejected: " + (response == null ? "empty response" : response.error()));
        }
        return response.accessToken();
    }

    /**
     * Mints a one-hour installation token. Later operations (commits, pushes, reachability) call
     * this per operation rather than holding tokens.
     *
     * @throws GitHubInstallationGoneException if the installation was removed or suspended
     */
    String installationToken(long installationId) {
        String jwt = appJwt().sign(Instant.now());
        try {
            InstallationTokenResponse response = api.post()
                    .uri("/app/installations/{id}/access_tokens", installationId)
                    .header(HttpHeaders.AUTHORIZATION, bearer(jwt))
                    .retrieve().body(InstallationTokenResponse.class);
            return response.token();
        } catch (RestClientResponseException e) {
            int status = e.getStatusCode().value();
            if (status == 404 || status == 403) {
                throw new GitHubInstallationGoneException(
                        "installation " + installationId + " is gone: HTTP " + status);
            }
            throw translate("POST /app/installations/{id}/access_tokens", e);
        } catch (ResourceAccessException e) {
            throw new GitHubTransientException("POST /app/installations/{id}/access_tokens unreachable", e);
        }
    }

    private <T> List<T> paged(String what, Function<Integer, List<T>> fetchPage) {
        List<T> all = new ArrayList<>();
        for (int page = 1; ; page++) {
            int p = page;
            List<T> items = call(what, () -> fetchPage.apply(p));
            all.addAll(items);
            if (items.size() < PAGE_SIZE) {
                return all;
            }
        }
    }

    private <T> T call(String what, Supplier<T> request) {
        try {
            return request.get();
        } catch (RestClientResponseException e) {
            throw translate(what, e);
        } catch (ResourceAccessException e) {
            throw new GitHubTransientException(what + " unreachable", e);
        }
    }

    private static GitHubGatewayException translate(String what, RestClientResponseException e) {
        int status = e.getStatusCode().value();
        String message = what + " failed: HTTP " + status;
        if (status >= 500 || status == 429) {
            return new GitHubTransientException(message, e);
        }
        return new GitHubGatewayException(message, e);
    }

    private void requireConfigured() {
        if (!properties.isConfigured()) {
            throw new GitHubAppNotConfiguredException();
        }
    }

    private GitHubAppJwt appJwt() {
        GitHubAppJwt jwt = appJwt;
        if (jwt == null) {
            jwt = new GitHubAppJwt(properties.getAppId(), properties.getPrivateKeyBase64());
            appJwt = jwt;
        }
        return jwt;
    }

    private static String bearer(String token) {
        return "Bearer " + token;
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record TokenExchangeResponse(@JsonProperty("access_token") String accessToken, String error) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record UserResponse(long id, String login) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record InstallationsPage(List<Installation> installations) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record Installation(long id) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record InstallationTokenResponse(String token) {
    }

    record ContentsRequest(String message, String content, String branch, Author author) {
    }

    record Author(String name, String email, String date) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record ContentsResponse(CommitRef commit) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record CommitRef(String sha, @JsonProperty("html_url") String htmlUrl) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record RepositoriesPage(List<Repository> repositories) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record Repository(
            long id,
            @JsonProperty("full_name") String fullName,
            @JsonProperty("default_branch") String defaultBranch,
            @JsonProperty("private") boolean isPrivate) {
    }
}
