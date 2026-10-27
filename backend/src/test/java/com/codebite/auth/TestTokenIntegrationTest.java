package com.codebite.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultMatcher;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Local sign-in without OAuth: the dev-profile test-token endpoint, optionally with a role.
 * "test" comes last so its H2 datasource wins over dev's PostgreSQL one.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles({"dev", "test"})
@Transactional
class TestTokenIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void adminRoleToken_isAllowedOnAdminEndpoint() throws Exception {
        String token = issueToken("dev-admin", "ADMIN");

        expectAdminEndpoint(token, status().isOk());
    }

    @Test
    void defaultToken_isForbiddenOnAdminEndpoint() throws Exception {
        String token = issueToken("dev-default", null);

        expectAdminEndpoint(token, status().isForbidden());
        assertRole(token, "USER");
    }

    @Test
    void roleForExistingUser_switchesTheirRoleBothWays() throws Exception {
        String asUser = issueToken("dev-switch", null);
        assertRole(asUser, "USER");

        String asAdmin = issueToken("dev-switch", "ADMIN");
        assertRole(asAdmin, "ADMIN");
        expectAdminEndpoint(asAdmin, status().isOk());

        String backToUser = issueToken("dev-switch", "USER");
        assertRole(backToUser, "USER");
        expectAdminEndpoint(backToUser, status().isForbidden());
    }

    @Test
    void noRole_leavesAnExistingAdminAsAdmin() throws Exception {
        issueToken("dev-keep", "ADMIN");

        String again = issueToken("dev-keep", null);

        assertRole(again, "ADMIN");
    }

    private void assertRole(String token, String role) throws Exception {
        mockMvc.perform(get("/api/auth/me").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.role").value(role));
    }

    private void expectAdminEndpoint(String token, ResultMatcher expected) throws Exception {
        mockMvc.perform(get("/api/admin/problems").header("Authorization", "Bearer " + token))
                .andExpect(expected);
    }

    /** Issues a test token for {@code username}, passing {@code role} only when non-null. */
    private String issueToken(String username, String role) throws Exception {
        MockHttpServletRequestBuilder request = post("/api/auth/test-token").param("username", username);
        if (role != null) {
            request.param("role", role);
        }
        String body = mockMvc.perform(request)
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(body).get("token").asText();
    }
}
