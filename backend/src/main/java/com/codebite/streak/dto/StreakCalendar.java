package com.codebite.streak.dto;

import java.time.LocalDate;
import java.util.List;

/**
 * One month of the Streak calendar. Days absent from {@code days} that fall after
 * {@code firstStreakDate} and before {@code today} are Missed Days; the client derives them rather
 * than the server listing every gap.
 */
public record StreakCalendar(
        String month,
        LocalDate today,
        LocalDate firstStreakDate,
        List<Day> days
) {
    public record Day(LocalDate date, boolean repaired) {
    }
}
