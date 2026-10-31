package com.codebite.onboarding;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/** The Tutorial's milestone counters: anyone may report a milestone, and each known one has its own counter. */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class TutorialMilestoneIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private MeterRegistry meterRegistry;
    @Autowired private UserRepository userRepository;
    @Autowired private JwtTokenProvider jwtTokenProvider;

    @ParameterizedTest
    @ValueSource(strings = {"started", "ran", "submitted", "accepted", "skipped"})
    void aKnownMilestone_fromAnAnonymousVisitor_isCounted(String milestone) throws Exception {
        double before = count(milestone);

        mockMvc.perform(post("/api/tutorial/milestones/{milestone}", milestone)).andExpect(status().isNoContent());

        assertThat(count(milestone)).isEqualTo(before + 1);
    }

    @Test
    void aSignedInUser_isCountedToo() throws Exception {
        User user = new User();
        user.setUsername("tutorialmilestoneuser");
        user.setEmail("tutorialmilestoneuser@test.com");
        user.setRole(Role.USER);
        String token = jwtTokenProvider.generateToken(userRepository.save(user));
        double before = count("ran");

        mockMvc.perform(post("/api/tutorial/milestones/ran").header("Authorization", "Bearer " + token))
                .andExpect(status().isNoContent());

        assertThat(count("ran")).isEqualTo(before + 1);
    }

    @Test
    void anUnknownMilestone_isABadRequest_andCountsNothing() throws Exception {
        mockMvc.perform(post("/api/tutorial/milestones/finished")).andExpect(status().isBadRequest());

        assertThat(meterRegistry.find("codebite.tutorial.milestones").tag("milestone", "finished").counter()).isNull();
    }

    private double count(String milestone) {
        Counter counter = meterRegistry.find("codebite.tutorial.milestones").tag("milestone", milestone).counter();
        return counter == null ? 0 : counter.count();
    }
}
