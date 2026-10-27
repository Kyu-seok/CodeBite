package com.codebite.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
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
        String token = issueToken(post("/api/auth/test-token")
                .param("username", "dev-admin")
                .param("role", "ADMIN"));

        mockMvc.perform(get("/api/admin/problems").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    @Test
    void defaultToken_isForbiddenOnAdminEndpoint() throws Exception {
        String token = issueToken(post("/api/auth/test-token").param("username", "dev-default"));

        mockMvc.perform(get("/api/admin/problems").header("Authorization", "Bearer " + token))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/api/auth/me").header("Authorization", "Bearer " + token))
                .andExpect(jsonPath("$.role").value("USER"));
    }

    @Test
    void roleForExistingUser_switchesTheirRoleBothWays() throws Exception {
        String asUser = issueToken(post("/api/auth/test-token").param("username", "dev-switch"));
        assertRole(asUser, "USER");

        String asAdmin = issueToken(post("/api/auth/test-token")
                .param("username", "dev-switch").param("role", "ADMIN"));
        assertRole(asAdmin, "ADMIN");
        mockMvc.perform(get("/api/admin/problems").header("Authorization", "Bearer " + asAdmin))
                .andExpect(status().isOk());

        String backToUser = issueToken(post("/api/auth/test-token")
                .param("username", "dev-switch").param("role", "USER"));
        assertRole(backToUser, "USER");
        mockMvc.perform(get("/api/admin/problems").header("Authorization", "Bearer " + backToUser))
                .andExpect(status().isForbidden());
    }

    @Test
    void noRole_leavesAnExistingAdminAsAdmin() throws Exception {
        issueToken(post("/api/auth/test-token").param("username", "dev-keep").param("role", "ADMIN"));

        String again = issueToken(post("/api/auth/test-token").param("username", "dev-keep"));

        assertRole(again, "ADMIN");
    }

    private void assertRole(String token, String role) throws Exception {
        mockMvc.perform(get("/api/auth/me").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.role").value(role));
    }

    private String issueToken(MockHttpServletRequestBuilder request) throws Exception {
        String body = mockMvc.perform(request)
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(body).get("token").asText();
    }
}
