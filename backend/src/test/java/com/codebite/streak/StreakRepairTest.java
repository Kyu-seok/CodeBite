package com.codebite.streak;

import com.codebite.common.exception.DuplicateResourceException;
import com.codebite.streak.dto.StreakSummary;
import com.codebite.streak.entity.StreakDay;
import com.codebite.streak.entity.UserStreak;
import com.codebite.streak.repository.StreakDayRepository;
import com.codebite.streak.repository.UserStreakRepository;
import com.codebite.streak.service.StreakService;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DataJpaTest
@ActiveProfiles("test")
@Import(StreakService.class)
@Sql(statements = {
        "DELETE FROM streak_days",
        "DELETE FROM user_streaks",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class StreakRepairTest {

    private static final LocalDate TODAY = LocalDate.of(2026, 10, 23);

    @Autowired private StreakService streakService;
    @Autowired private StreakDayRepository streakDayRepository;
    @Autowired private UserStreakRepository userStreakRepository;
    @Autowired private TestEntityManager entityManager;

    private Long userId;

    @BeforeEach
    void setUp() {
        User user = new User();
        user.setUsername("repair-user");
        user.setEmail("repair@test.com");
        user.setPasswordHash("hash");
        userId = entityManager.persistAndFlush(user).getId();
    }

    /** Real Streak Days, as days before TODAY. */
    private void solvedDaysAgo(int... offsets) {
        for (int offset : offsets) {
            streakDayRepository.save(new StreakDay(userId, TODAY.minusDays(offset), false));
        }
    }

    private void holdRepairs(int count) {
        UserStreak streak = new UserStreak(userId);
        for (int i = 0; i < count; i++) {
            streak.grantRepair();
        }
        userStreakRepository.saveAndFlush(streak);
    }

    @Test
    void repairingYesterdayRestoresTheStreak() {
        // Solved 2..11 days ago, missed yesterday, solved today.
        solvedDaysAgo(0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
        holdRepairs(2);
        assertEquals(1, streakService.getSummary(userId, TODAY).currentStreak());

        StreakSummary after = streakService.repair(userId, TODAY.minusDays(1), TODAY);

        assertEquals(12, after.currentStreak());
        assertEquals(12, after.bestStreak(), "Repaired Days count toward Best Streak");
        assertEquals(1, after.repairs());
        assertTrue(streakDayRepository.findByUserIdAndStreakDate(userId, TODAY.minusDays(1))
                .orElseThrow().isRepaired());
    }

    @Test
    void anyMissedDayCanBeRepairedNotJustTheLatest() {
        solvedDaysAgo(40, 38, 0);
        holdRepairs(1);

        StreakSummary after = streakService.repair(userId, TODAY.minusDays(39), TODAY);

        assertEquals(3, after.bestStreak());
        assertEquals(1, after.currentStreak(), "the old run is still disconnected from today");
    }

    @Test
    void repairingDoesNotAdvanceRepairProgress() {
        solvedDaysAgo(3);
        holdRepairs(1);

        assertEquals(0, streakService.repair(userId, TODAY.minusDays(2), TODAY).repairProgress());
    }

    @Test
    void todayCannotBeRepaired() {
        solvedDaysAgo(3);
        holdRepairs(1);

        assertThrows(IllegalArgumentException.class, () -> streakService.repair(userId, TODAY, TODAY));
        assertThrows(IllegalArgumentException.class,
                () -> streakService.repair(userId, TODAY.plusDays(1), TODAY));
    }

    @Test
    void daysUpToTheFirstStreakDayCannotBeRepaired() {
        solvedDaysAgo(3);
        holdRepairs(1);

        assertThrows(IllegalArgumentException.class,
                () -> streakService.repair(userId, TODAY.minusDays(4), TODAY));
        assertThrows(IllegalArgumentException.class,
                () -> streakService.repair(userId, TODAY.minusDays(3), TODAY));
    }

    @Test
    void cannotRepairWithoutRepairs() {
        solvedDaysAgo(3);

        assertThrows(IllegalArgumentException.class,
                () -> streakService.repair(userId, TODAY.minusDays(2), TODAY));

        holdRepairs(0);
        assertThrows(IllegalArgumentException.class,
                () -> streakService.repair(userId, TODAY.minusDays(2), TODAY));
    }

    @Test
    void aCountedDayCannotBeRepairedAgain() {
        solvedDaysAgo(3, 1);
        holdRepairs(2);
        streakService.repair(userId, TODAY.minusDays(2), TODAY);

        assertThrows(DuplicateResourceException.class,
                () -> streakService.repair(userId, TODAY.minusDays(2), TODAY));
        assertThrows(DuplicateResourceException.class,
                () -> streakService.repair(userId, TODAY.minusDays(1), TODAY));
        assertEquals(1, userStreakRepository.findById(userId).orElseThrow().getRepairs(),
                "a rejected Repair is not spent");
    }

    @Test
    void summaryForAUserWithNoHistory() {
        StreakSummary summary = streakService.getSummary(userId, TODAY);

        assertEquals(0, summary.currentStreak());
        assertEquals(0, summary.bestStreak());
        assertFalse(summary.solvedToday());
        assertEquals(0, summary.repairs());
    }
}
