package com.codebite.common.time;

import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class DayRunsTest {

    private static final LocalDate TODAY = LocalDate.of(2026, 10, 23);

    private static List<LocalDate> daysAgo(int... offsets) {
        return Arrays.stream(offsets).mapToObj(TODAY::minusDays).toList();
    }

    // ---- current ----

    @Test
    void current_noDays_isZero() {
        assertEquals(0, DayRuns.current(List.of(), TODAY));
    }

    @Test
    void current_onlyToday_isOne() {
        assertEquals(1, DayRuns.current(daysAgo(0), TODAY));
    }

    @Test
    void current_onlyYesterday_isOne() {
        assertEquals(1, DayRuns.current(daysAgo(1), TODAY));
    }

    @Test
    void current_countsBackFromToday() {
        assertEquals(3, DayRuns.current(daysAgo(0, 1, 2, 4), TODAY));
    }

    @Test
    void current_survivesUntilTodayIsOver() {
        // Today not done yet: the run still reads from yesterday.
        assertEquals(2, DayRuns.current(daysAgo(1, 2), TODAY));
    }

    @Test
    void current_isZeroOnceYesterdayIsMissed() {
        assertEquals(0, DayRuns.current(daysAgo(2, 3), TODAY));
    }

    @Test
    void current_gapOfOneDayStopsTheRun() {
        assertEquals(2, DayRuns.current(daysAgo(0, 1, 3), TODAY));
    }

    @Test
    void current_ignoresInputOrder() {
        assertEquals(3, DayRuns.current(daysAgo(2, 0, 1), TODAY));
    }

    @Test
    void current_ignoresDuplicates() {
        assertEquals(2, DayRuns.current(daysAgo(0, 0, 1, 1), TODAY));
    }

    @Test
    void current_ignoresDaysAfterToday() {
        // A day that has not begun in UTC cannot be counted.
        assertEquals(0, DayRuns.current(daysAgo(-1), TODAY));
        assertEquals(1, DayRuns.current(daysAgo(-1, 0), TODAY));
    }

    // ---- longest ----

    @Test
    void longest_noDays_isZero() {
        assertEquals(0, DayRuns.longest(List.of()));
    }

    @Test
    void longest_singleDay_isOne() {
        assertEquals(1, DayRuns.longest(daysAgo(0)));
    }

    @Test
    void longest_findsTheLongestRunAnywhere() {
        assertEquals(3, DayRuns.longest(daysAgo(0, 5, 6, 7, 10)));
    }

    @Test
    void longest_pickedFromTheMiddle() {
        List<LocalDate> days = List.of(
                LocalDate.parse("2026-01-01"),
                // gap
                LocalDate.parse("2026-02-10"),
                LocalDate.parse("2026-02-11"),
                LocalDate.parse("2026-02-12"),
                LocalDate.parse("2026-02-13"),  // 4-day run
                // gap
                LocalDate.parse("2026-03-05"),
                LocalDate.parse("2026-03-06"));  // 2-day run
        assertEquals(4, DayRuns.longest(days));
    }

    @Test
    void longest_ignoresInputOrder() {
        assertEquals(3, DayRuns.longest(daysAgo(1, 3, 2)));
    }

    @Test
    void longest_ignoresDuplicates() {
        assertEquals(2, DayRuns.longest(daysAgo(1, 1, 2, 2)));
    }

    @Test
    void longest_hasNoTodayAndCountsFutureDays() {
        // Only current knows today; longest counts whatever it is given.
        assertEquals(2, DayRuns.longest(daysAgo(-1, 0)));
    }
}
