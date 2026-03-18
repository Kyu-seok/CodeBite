package com.codebite.auth;

import com.codebite.auth.dto.OAuthCallbackRequest;
import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class AuthIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Test
    void getOAuthUrl_google_returnsUrl() throws Exception {
        mockMvc.perform(get("/api/auth/oauth/google"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.authorizationUrl").isNotEmpty());
    }

    @Test
    void getOAuthUrl_github_returnsUrl() throws Exception {
        mockMvc.perform(get("/api/auth/oauth/github"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.authorizationUrl").isNotEmpty());
    }

    @Test
    void getOAuthUrl_invalidProvider_returns400() throws Exception {
        mockMvc.perform(get("/api/auth/oauth/invalid"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void oauthCallback_invalidState_returns401() throws Exception {
        OAuthCallbackRequest request = new OAuthCallbackRequest("some-code", "invalid-state");

        mockMvc.perform(post("/api/auth/oauth/google/callback")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void me_withValidToken_returnsProfile() throws Exception {
        User user = new User();
        user.setUsername("oauthuser");
        user.setEmail("oauth@test.com");
        user.setRole(Role.USER);
        user = userRepository.save(user);

        String token = jwtTokenProvider.generateToken(user);

        mockMvc.perform(get("/api/auth/me")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username").value("oauthuser"))
                .andExpect(jsonPath("$.email").value("oauth@test.com"));
    }

    @Test
    void me_withoutToken_returns401() throws Exception {
        mockMvc.perform(get("/api/auth/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void oldEndpoints_noLongerExist() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"a\",\"email\":\"a@b.com\",\"password\":\"12345678\"}"))
                .andExpect(status().isUnauthorized());

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"a\",\"password\":\"12345678\"}"))
                .andExpect(status().isUnauthorized());
    }
}
