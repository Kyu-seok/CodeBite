package com.codebite.streak;

import com.codebite.auth.jwt.JwtTokenProvider;
import com.codebite.streak.entity.StreakDay;
import com.codebite.streak.entity.UserStreak;
import com.codebite.streak.repository.StreakDayRepository;
import com.codebite.streak.repository.UserStreakRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneOffset;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class StreakIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private UserRepository userRepository;
    @Autowired private StreakDayRepository streakDayRepository;
    @Autowired private UserStreakRepository userStreakRepository;
    @Autowired private JwtTokenProvider jwtTokenProvider;

    private final LocalDate today = LocalDate.now(ZoneOffset.UTC);
    private Long userId;
    private String token;

    @BeforeEach
    void setUp() {
        User user = new User();
        user.setUsername("streaker");
        user.setEmail("streaker@test.com");
        user.setRole(Role.USER);
        user = userRepository.save(user);
        userId = user.getId();
        token = jwtTokenProvider.generateToken(user);

        // Solved three days ago and today; missed the two days between. One Repair held.
        streakDayRepository.save(new StreakDay(userId, today.minusDays(3), false));
        streakDayRepository.save(new StreakDay(userId, today, false));
        UserStreak streak = new UserStreak(userId);
        streak.grantRepair();
        userStreakRepository.save(streak);
    }

    @Test
    void summaryRequiresAuth() throws Exception {
        mockMvc.perform(get("/api/streak")).andExpect(status().isUnauthorized());
    }

    @Test
    void summaryReturnsTheOwnersStreak() throws Exception {
        mockMvc.perform(get("/api/streak").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.currentStreak").value(1))
                .andExpect(jsonPath("$.solvedToday").value(true))
                .andExpect(jsonPath("$.repairs").value(1));
    }

    @Test
    void calendarReturnsTheMonthsDays() throws Exception {
        mockMvc.perform(get("/api/streak/days")
                        .param("month", YearMonth.from(today).toString())
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.firstStreakDate").value(today.minusDays(3).toString()))
                .andExpect(jsonPath("$.today").value(today.toString()));
    }

    @Test
    void repairSpendsARepairOnTheChosenDay() throws Exception {
        mockMvc.perform(post("/api/streak/repairs")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"date\":\"" + today.minusDays(1) + "\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.currentStreak").value(2))
                .andExpect(jsonPath("$.repairs").value(0));
    }

    @Test
    void repairingTodayIsABadRequest() throws Exception {
        mockMvc.perform(post("/api/streak/repairs")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"date\":\"" + today + "\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void repairingTheFirstStreakDayIsABadRequest() throws Exception {
        mockMvc.perform(post("/api/streak/repairs")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"date\":\"" + today.minusDays(3) + "\"}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void repairWithoutADateIsABadRequest() throws Exception {
        mockMvc.perform(post("/api/streak/repairs")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isBadRequest());
    }
}
