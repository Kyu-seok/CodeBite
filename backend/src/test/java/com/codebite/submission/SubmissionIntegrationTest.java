package com.codebite.submission;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import com.codebite.submission.dto.SubmitRequest;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class SubmissionIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @MockBean
    private JudgeClient judgeClient;

    private String userToken;
    private String otherUserToken;

    @BeforeEach
    void setUp() {
        User user = new User();
        user.setUsername("submitter");
        user.setEmail("submitter@test.com");
        user.setPasswordHash(passwordEncoder.encode("password123"));
        user.setRole(Role.USER);
        user = userRepository.save(user);
        userToken = jwtTokenProvider.generateToken(user);

        User other = new User();
        other.setUsername("otheruser");
        other.setEmail("other@test.com");
        other.setPasswordHash(passwordEncoder.encode("password123"));
        other.setRole(Role.USER);
        other = userRepository.save(other);
        otherUserToken = jwtTokenProvider.generateToken(other);
    }

    // Map test case inputs to their expected outputs for Two Sum
    private static final Map<String, String> TWO_SUM_EXPECTED = Map.of(
            "[2,7,11,15]\n9", "[0,1]",
            "[3,2,4]\n6", "[1,2]",
            "[3,3]\n6", "[0,1]",
            "[1,5,3,7,2]\n9", "[1,4]"
    );

    private void mockJudgeAccepted() {
        when(judgeClient.submit(any())).thenAnswer(inv -> {
            JudgeRequest req = inv.getArgument(0);
            String expectedOutput = TWO_SUM_EXPECTED.getOrDefault(req.stdin(), "unknown");
            return new JudgeResponse(
                    null, new JudgeResponse.Status(3, "Accepted"), expectedOutput + "\n", null, null, "0.012", 9400);
        });
    }

    private void mockJudgeWrongAnswer() {
        when(judgeClient.submit(any())).thenReturn(new JudgeResponse(
                null, new JudgeResponse.Status(3, "Accepted"), "WRONG\n", null, null, "0.010", 9200));
    }

    // --- Submit: accepted ---

    @Test
    void submit_accepted_returns201() throws Exception {
        mockJudgeAccepted();

        SubmitRequest request = new SubmitRequest("java",
                "class Solution { public int[] twoSum(int[] nums, int target) { return new int[]{0,1}; } }");

        mockMvc.perform(post("/api/problems/two-sum/submit")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status").value("ACCEPTED"))
                .andExpect(jsonPath("$.problemSlug").value("two-sum"))
                .andExpect(jsonPath("$.language").value("java"))
                .andExpect(jsonPath("$.results").isArray());
    }

    // --- Submit: wrong answer ---

    @Test
    void submit_wrongAnswer_returns201WithWrongAnswer() throws Exception {
        mockJudgeWrongAnswer();

        SubmitRequest request = new SubmitRequest("java", "class Solution { public int[] twoSum(int[] nums, int target) { return new int[]{1,2}; } }");

        mockMvc.perform(post("/api/problems/two-sum/submit")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status").value("WRONG_ANSWER"));
    }

    // --- Submit: 401 without token ---

    @Test
    void submit_withoutToken_returns401() throws Exception {
        SubmitRequest request = new SubmitRequest("java", "code");

        mockMvc.perform(post("/api/problems/two-sum/submit")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    // --- Submit: 404 unknown problem ---

    @Test
    void submit_unknownProblem_returns404() throws Exception {
        SubmitRequest request = new SubmitRequest("java", "code");

        mockMvc.perform(post("/api/problems/nonexistent/submit")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isNotFound());
    }

    // --- Submit: 400 bad language ---

    @Test
    void submit_unsupportedLanguage_returns400() throws Exception {
        SubmitRequest request = new SubmitRequest("rust", "fn main() {}");

        mockMvc.perform(post("/api/problems/two-sum/submit")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    // --- Get submission ---

    @Test
    void getSubmission_afterSubmit_returns200() throws Exception {
        mockJudgeAccepted();

        SubmitRequest request = new SubmitRequest("java", "class Solution { public int[] twoSum(int[] nums, int target) { return new int[]{0,1}; } }");

        MvcResult submitResult = mockMvc.perform(post("/api/problems/two-sum/submit")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andReturn();

        Long submissionId = objectMapper.readTree(submitResult.getResponse().getContentAsString())
                .get("id").asLong();

        mockMvc.perform(get("/api/submissions/" + submissionId)
                        .header("Authorization", "Bearer " + userToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(submissionId))
                .andExpect(jsonPath("$.status").value("ACCEPTED"));
    }

    // --- Get submission: ownership enforcement ---

    @Test
    void getSubmission_otherUser_returns404() throws Exception {
        mockJudgeAccepted();

        SubmitRequest request = new SubmitRequest("java", "class Solution { public int[] twoSum(int[] nums, int target) { return new int[]{0,1}; } }");

        MvcResult submitResult = mockMvc.perform(post("/api/problems/two-sum/submit")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andReturn();

        Long submissionId = objectMapper.readTree(submitResult.getResponse().getContentAsString())
                .get("id").asLong();

        // Other user tries to view
        mockMvc.perform(get("/api/submissions/" + submissionId)
                        .header("Authorization", "Bearer " + otherUserToken))
                .andExpect(status().isNotFound());
    }

    // --- List submissions ---

    @Test
    void listSubmissions_returns200() throws Exception {
        mockJudgeAccepted();

        SubmitRequest request = new SubmitRequest("java", "class Solution { public int[] twoSum(int[] nums, int target) { return new int[]{0,1}; } }");

        mockMvc.perform(post("/api/problems/two-sum/submit")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/api/problems/two-sum/submissions")
                        .header("Authorization", "Bearer " + userToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].status").value("ACCEPTED"));
    }

    // --- List submissions: 401 without token ---

    @Test
    void listSubmissions_withoutToken_returns401() throws Exception {
        mockMvc.perform(get("/api/problems/two-sum/submissions"))
                .andExpect(status().isUnauthorized());
    }

    // --- GET problem detail still works publicly ---

    @Test
    void getProblemsSlug_remainsPublic() throws Exception {
        mockMvc.perform(get("/api/problems/two-sum"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.slug").value("two-sum"));
    }

    // --- GET problems list still works publicly ---

    @Test
    void listProblems_remainsPublic() throws Exception {
        mockMvc.perform(get("/api/problems"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }
}
