package com.codebite.github;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.gateway.FakeGitHubGateway;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubRepo;
import com.codebite.github.gateway.GitHubTransientException;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.tuple;
import static org.hamcrest.Matchers.startsWith;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class GitHubLinkIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private UserRepository userRepository;
    @Autowired private JwtTokenProvider jwtTokenProvider;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private FakeGitHubGateway gitHub;
    @Autowired private GitHubLinkRepository linkRepository;

    private String token;

    @BeforeEach
    void setUp() {
        gitHub.reset();
        token = tokenFor("linker");
    }

    @Test
    void linkRequiresAuth() throws Exception {
        mockMvc.perform(get("/api/github/link")).andExpect(status().isUnauthorized());
    }

    @Test
    void unlinkedUserHasNoLink() throws Exception {
        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isNoContent());
    }

    @Test
    void installUrlPointsAtTheAppAndCarriesAState() throws Exception {
        mockMvc.perform(get("/api/github/link/install").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.installUrl")
                        .value(startsWith("https://github.com/apps/codebite-test/installations/new?state=")));
    }

    @Test
    void callbackWithOneGrantedRepositoryCreatesTheLink() throws Exception {
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77);
        gitHub.install(77, new GitHubRepo(1296269, "octocat/codebite-solutions", "main", false));

        callback("code-1", 77, stateFor(token), token)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.link.githubLogin").value("octocat"))
                .andExpect(jsonPath("$.link.repositoryFullName").value("octocat/codebite-solutions"))
                .andExpect(jsonPath("$.repositories").isEmpty());

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.githubAccountId").value(583231))
                .andExpect(jsonPath("$.githubLogin").value("octocat"))
                .andExpect(jsonPath("$.repositoryFullName").value("octocat/codebite-solutions"))
                .andExpect(jsonPath("$.repositoryUrl").value("https://github.com/octocat/codebite-solutions"))
                .andExpect(jsonPath("$.defaultBranch").value("main"))
                .andExpect(jsonPath("$.repositoryPrivate").value(false))
                .andExpect(jsonPath("$.status").value("ACTIVE"))
                .andExpect(jsonPath("$.importState").value("AVAILABLE"));
    }

    @Test
    void callbackForAnInstallationTheAccountCannotAccessIsRejected() throws Exception {
        // Someone else's installation 99 exists; octocat only authorised 77.
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77);
        gitHub.install(77, new GitHubRepo(1, "octocat/codebite-solutions", "main", false));
        gitHub.install(99, new GitHubRepo(2, "victim/private-code", "main", true));

        callback("code-1", 99, stateFor(token), token).andExpect(status().isForbidden());

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isNoContent());
    }

    @Test
    void privateRepositoryIsFlagged() throws Exception {
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77);
        gitHub.install(77, new GitHubRepo(1, "octocat/solutions", "trunk", true));

        callback("code-1", 77, stateFor(token), token)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.link.repositoryPrivate").value(true));

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(jsonPath("$.repositoryPrivate").value(true))
                .andExpect(jsonPath("$.defaultBranch").value("trunk"));
    }

    @Test
    void callbackWithSeveralGrantedRepositoriesListsThemWithoutLinking() throws Exception {
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77);
        gitHub.install(77,
                new GitHubRepo(1, "octocat/solutions", "main", false),
                new GitHubRepo(2, "octocat/dotfiles", "main", true));

        callback("code-1", 77, stateFor(token), token)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.link").doesNotExist())
                .andExpect(jsonPath("$.repositories.length()").value(2))
                .andExpect(jsonPath("$.repositories[1].fullName").value("octocat/dotfiles"))
                .andExpect(jsonPath("$.repositories[1].repositoryPrivate").value(true));

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isNoContent());
    }

    @Test
    void callbackWithAnotherUsersStateIsRejected() throws Exception {
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77);
        gitHub.install(77, new GitHubRepo(1, "octocat/solutions", "main", false));
        String otherToken = tokenFor("other");

        callback("code-1", 77, stateFor(otherToken), token).andExpect(status().isUnauthorized());
        callback("code-1", 77, "not-a-state", token).andExpect(status().isUnauthorized());
    }

    @Test
    void linkingAgainReplacesTheCurrentLink() throws Exception {
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77, 78);
        gitHub.install(77, new GitHubRepo(1, "octocat/old-solutions", "main", false));
        gitHub.install(78, new GitHubRepo(2, "octocat/new-solutions", "main", false));
        callback("code-1", 77, stateFor(token), token).andExpect(status().isOk());

        callback("code-1", 78, stateFor(token), token).andExpect(status().isOk());

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(jsonPath("$.repositoryFullName").value("octocat/new-solutions"))
                .andExpect(jsonPath("$.importState").value("AVAILABLE"));
    }

    @Test
    void unlinkMarksTheLinkUnlinkedAndKeepsTheRow() throws Exception {
        linkOneRepository("octocat/codebite-solutions");

        unlink(token).andExpect(status().isNoContent());

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isNoContent());
        Long userId = userRepository.findByUsername("linker").orElseThrow().getId();
        assertThat(linkRepository.findByActiveUserId(userId)).isEmpty();
        assertThat(linkRepository.findAll())
                .filteredOn(link -> link.getUserId().equals(userId))
                .singleElement()
                .satisfies(link -> {
                    assertThat(link.getStatus()).isEqualTo(GitHubLinkStatus.UNLINKED);
                    assertThat(link.getUnlinkedAt()).isNotNull();
                    assertThat(link.getRepositoryFullName()).isEqualTo("octocat/codebite-solutions");
                });
    }

    @Test
    void unlinkMakesNoGitHubCall() throws Exception {
        linkOneRepository("octocat/codebite-solutions");
        // Any gateway call now fails, so a 204 proves unlink never reached GitHub.
        gitHub.failAlways(() -> new GitHubTransientException("GitHub must not be called on unlink"));

        unlink(token).andExpect(status().isNoContent());

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isNoContent());
    }

    @Test
    void unlinkWithoutALinkIsANoOp() throws Exception {
        unlink(token).andExpect(status().isNoContent());
    }

    @Test
    void unlinkRequiresAuth() throws Exception {
        mockMvc.perform(delete("/api/github/link")).andExpect(status().isUnauthorized());
    }

    @Test
    void relinkingAfterUnlinkCreatesAFreshActiveLink() throws Exception {
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77, 78);
        gitHub.install(77, new GitHubRepo(1, "octocat/old-solutions", "main", false));
        gitHub.install(78, new GitHubRepo(2, "octocat/new-solutions", "main", false));
        callback("code-1", 77, stateFor(token), token).andExpect(status().isOk());
        unlink(token).andExpect(status().isNoContent());

        callback("code-1", 78, stateFor(token), token).andExpect(status().isOk());

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.repositoryFullName").value("octocat/new-solutions"))
                .andExpect(jsonPath("$.status").value("ACTIVE"))
                .andExpect(jsonPath("$.importState").value("AVAILABLE"));
        Long userId = userRepository.findByUsername("linker").orElseThrow().getId();
        assertThat(linkRepository.findAll())
                .filteredOn(link -> link.getUserId().equals(userId))
                .extracting(GitHubLink::getRepositoryFullName, GitHubLink::getStatus)
                .containsExactlyInAnyOrder(
                        tuple("octocat/old-solutions", GitHubLinkStatus.UNLINKED),
                        tuple("octocat/new-solutions", GitHubLinkStatus.ACTIVE));
    }

    @Test
    void relinkingTheSameRepositoryAfterUnlinkWorks() throws Exception {
        linkOneRepository("octocat/codebite-solutions");
        unlink(token).andExpect(status().isNoContent());

        callback("code-1", 77, stateFor(token), token).andExpect(status().isOk());

        mockMvc.perform(get("/api/github/link").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.repositoryFullName").value("octocat/codebite-solutions"))
                .andExpect(jsonPath("$.status").value("ACTIVE"));
    }

    @Test
    void callbackRequiresAuth() throws Exception {
        mockMvc.perform(post("/api/github/link/callback")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"code\":\"c\",\"installationId\":1,\"state\":\"s\"}"))
                .andExpect(status().isUnauthorized());
    }

    private void linkOneRepository(String fullName) throws Exception {
        gitHub.authorize("code-1", new GitHubAccount(583231, "octocat"), 77);
        gitHub.install(77, new GitHubRepo(1296269, fullName, "main", false));
        callback("code-1", 77, stateFor(token), token).andExpect(status().isOk());
    }

    private ResultActions unlink(String bearer) throws Exception {
        return mockMvc.perform(delete("/api/github/link").header("Authorization", "Bearer " + bearer));
    }

    private ResultActions callback(String code, long installationId, String state, String bearer) throws Exception {
        return mockMvc.perform(post("/api/github/link/callback")
                .header("Authorization", "Bearer " + bearer)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                        Map.of("code", code, "installationId", installationId, "state", state))));
    }

    /** The state GitHub would hand back: the one in the install URL issued to that user. */
    private String stateFor(String bearer) throws Exception {
        String body = mockMvc.perform(get("/api/github/link/install").header("Authorization", "Bearer " + bearer))
                .andReturn().getResponse().getContentAsString();
        String installUrl = objectMapper.readTree(body).get("installUrl").asText();
        return UriComponentsBuilder.fromUriString(installUrl).build().getQueryParams().getFirst("state");
    }

    private String tokenFor(String username) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(username + "@test.com");
        user.setRole(Role.USER);
        return jwtTokenProvider.generateToken(userRepository.save(user));
    }
}
