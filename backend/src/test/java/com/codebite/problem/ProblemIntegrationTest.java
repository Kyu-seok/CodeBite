package com.codebite.problem;

import com.codebite.problem.dto.CreateProblemRequest;
import com.codebite.problem.dto.CreateTestCaseRequest;
import com.codebite.problem.dto.UpdateProblemRequest;
import com.codebite.problem.entity.Difficulty;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import com.codebite.auth.jwt.JwtTokenProvider;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class ProblemIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    private String adminToken;
    private String userToken;

    @BeforeEach
    void setUp() {
        User admin = new User();
        admin.setUsername("problemadmin");
        admin.setEmail("problemadmin@test.com");
        admin.setRole(Role.ADMIN);
        admin = userRepository.save(admin);
        adminToken = jwtTokenProvider.generateToken(admin);

        User user = new User();
        user.setUsername("problemuser");
        user.setEmail("problemuser@test.com");
        user.setRole(Role.USER);
        user = userRepository.save(user);
        userToken = jwtTokenProvider.generateToken(user);
    }

    // --- Public endpoints ---

    @Test
    void listProblems_returnsSeededProblems() throws Exception {
        mockMvc.perform(get("/api/problems"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content.length()").value(20))
                .andExpect(jsonPath("$.content[0].title").isNotEmpty())
                .andExpect(jsonPath("$.content[0].slug").isNotEmpty())
                .andExpect(jsonPath("$.content[0].difficulty").isNotEmpty());
    }

    @Test
    void listProblems_filterByDifficulty() throws Exception {
        mockMvc.perform(get("/api/problems?difficulty=EASY"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content").isNotEmpty())
                .andExpect(jsonPath("$.totalElements").isNumber());
    }

    @Test
    void listProblems_pagination() throws Exception {
        mockMvc.perform(get("/api/problems?page=0&size=2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content.length()").value(2))
                .andExpect(jsonPath("$.totalElements").isNumber())
                .andExpect(jsonPath("$.totalPages").isNumber());
    }

    @Test
    void getProblemBySlug_returnsDetail() throws Exception {
        mockMvc.perform(get("/api/problems/snack-drawer-pair"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Snack Drawer Pair"))
                .andExpect(jsonPath("$.slug").value("snack-drawer-pair"))
                .andExpect(jsonPath("$.description").isNotEmpty())
                .andExpect(jsonPath("$.difficulty").value("EASY"))
                .andExpect(jsonPath("$.starterCode.java").isNotEmpty())
                .andExpect(jsonPath("$.starterCode.python").isNotEmpty())
                .andExpect(jsonPath("$.starterCode.javascript").isNotEmpty())
                .andExpect(jsonPath("$.starterCode.cpp").isNotEmpty())
                .andExpect(jsonPath("$.sampleTestCases").isArray())
                .andExpect(jsonPath("$.sampleTestCases.length()").value(2));
    }

    @Test
    void getProblemBySlug_unknownSlug_returns404() throws Exception {
        mockMvc.perform(get("/api/problems/nonexistent"))
                .andExpect(status().isNotFound());
    }

    // --- Admin endpoints ---

    @Test
    void adminCreateProblem_withAdminToken_returns201() throws Exception {
        CreateProblemRequest request = new CreateProblemRequest(
                "Binary Search", "Find target in sorted array", Difficulty.MEDIUM,
                "1 <= n <= 10^5", true);

        mockMvc.perform(post("/api/admin/problems")
                        .header("Authorization", "Bearer " + adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.title").value("Binary Search"))
                .andExpect(jsonPath("$.slug").value("binary-search"))
                .andExpect(jsonPath("$.difficulty").value("MEDIUM"));
    }

    @Test
    void adminCreateProblem_withoutToken_returns401() throws Exception {
        CreateProblemRequest request = new CreateProblemRequest(
                "Test", "Desc", Difficulty.EASY, null, false);

        mockMvc.perform(post("/api/admin/problems")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void adminCreateProblem_withUserToken_returns403() throws Exception {
        CreateProblemRequest request = new CreateProblemRequest(
                "Test", "Desc", Difficulty.EASY, null, false);

        mockMvc.perform(post("/api/admin/problems")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isForbidden());
    }

    @Test
    void adminCreateProblem_invalidInput_returns400() throws Exception {
        CreateProblemRequest request = new CreateProblemRequest(
                "", "", null, null, null);

        mockMvc.perform(post("/api/admin/problems")
                        .header("Authorization", "Bearer " + adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void adminUpdateProblem_withAdminToken_returns200() throws Exception {
        // First create a problem
        CreateProblemRequest create = new CreateProblemRequest(
                "To Update", "Original desc", Difficulty.EASY, null, false);
        MvcResult createResult = mockMvc.perform(post("/api/admin/problems")
                        .header("Authorization", "Bearer " + adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(create)))
                .andExpect(status().isCreated())
                .andReturn();

        Long id = objectMapper.readTree(createResult.getResponse().getContentAsString())
                .get("id").asLong();

        UpdateProblemRequest update = new UpdateProblemRequest(
                null, "Updated desc", null, null, true);

        mockMvc.perform(put("/api/admin/problems/" + id)
                        .header("Authorization", "Bearer " + adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(update)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.description").value("Updated desc"))
                .andExpect(jsonPath("$.published").value(true))
                .andExpect(jsonPath("$.title").value("To Update"));
    }

    @Test
    void adminAddTestCase_withAdminToken_returns201() throws Exception {
        // First create a problem
        CreateProblemRequest create = new CreateProblemRequest(
                "TC Problem", "Desc", Difficulty.EASY, null, true);
        MvcResult createResult = mockMvc.perform(post("/api/admin/problems")
                        .header("Authorization", "Bearer " + adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(create)))
                .andExpect(status().isCreated())
                .andReturn();

        Long id = objectMapper.readTree(createResult.getResponse().getContentAsString())
                .get("id").asLong();

        CreateTestCaseRequest tcRequest = new CreateTestCaseRequest(
                "{\"x\": 1}", "1", true, 1);

        mockMvc.perform(post("/api/admin/problems/" + id + "/test-cases")
                        .header("Authorization", "Bearer " + adminToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(tcRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.input").value("{\"x\": 1}"))
                .andExpect(jsonPath("$.expectedOutput").value("1"))
                .andExpect(jsonPath("$.sample").value(true));
    }
}
