package com.codebite.streak;

import com.codebite.streak.entity.UserStreak;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class UserStreakTest {

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
