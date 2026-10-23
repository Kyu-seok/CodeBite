package com.codebite.streak;

import com.codebite.streak.entity.UserStreak;
import com.codebite.streak.service.StreakService;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class StreakComputationTest {

    private static final LocalDate TODAY = LocalDate.of(2026, 10, 23);

    private static List<LocalDate> daysAgo(int... offsets) {
        return Arrays.stream(offsets).mapToObj(TODAY::minusDays).toList();
    }

    @Test
    void currentStreakCountsBackFromToday() {
        assertEquals(3, StreakService.currentStreak(daysAgo(0, 1, 2, 4), TODAY));
    }

    @Test
    void currentStreakSurvivesUntilTodayIsOver() {
        // Today not solved yet: the Streak still reads from yesterday.
        assertEquals(2, StreakService.currentStreak(daysAgo(1, 2), TODAY));
    }

    @Test
    void currentStreakIsZeroOnceYesterdayIsMissed() {
        assertEquals(0, StreakService.currentStreak(daysAgo(2, 3), TODAY));
    }

    @Test
    void bestStreakFindsTheLongestRunAnywhere() {
        assertEquals(3, StreakService.bestStreak(daysAgo(0, 5, 6, 7, 10)));
        assertEquals(0, StreakService.bestStreak(List.of()));
    }

    @Test
    void everyFifthDayEarnsARepair() {
        UserStreak streak = new UserStreak(1L);
        for (int i = 0; i < 4; i++) {
            streak.advanceProgress();
        }
        assertEquals(0, streak.getRepairs());
        assertEquals(4, streak.getRepairProgress());

        streak.advanceProgress();
        assertEquals(1, streak.getRepairs());
        assertEquals(0, streak.getRepairProgress());
    }

    @Test
    void repairsBeyondTheCapAreForfeitedAndProgressStillResets() {
        UserStreak streak = new UserStreak(1L);
        for (int i = 0; i < 30; i++) {
            streak.advanceProgress();
        }
        assertEquals(UserStreak.MAX_REPAIRS, streak.getRepairs());
        assertEquals(0, streak.getRepairProgress());
    }

    @Test
    void cannotSpendARepairYouDoNotHave() {
        assertThrows(IllegalStateException.class, () -> new UserStreak(1L).spendRepair());
    }
}
