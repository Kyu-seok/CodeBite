package com.codebite.common.time;

import java.time.LocalDate;
import java.util.Collection;
import java.util.TreeSet;

/**
 * Runs of consecutive UTC days (ADR 0001). Backs the Streak and the Review Streak (GLOSSARY.md),
 * which count the same way over different sets of days.
 *
 * <p>The order of the days and any duplicates among them are irrelevant. Days after {@code today}
 * are ignored by {@link #current}: a day that has not begun yet cannot be counted.
 */
public final class DayRuns {

    private DayRuns() {
    }

    /**
     * The run ending today, or yesterday if today is not done yet, so the count does not read 0
     * all morning before the user acts.
     */
    public static int current(Collection<LocalDate> days, LocalDate today) {
        TreeSet<LocalDate> set = new TreeSet<>(days);
        LocalDate cursor = set.contains(today) ? today : today.minusDays(1);
        int run = 0;
        while (set.contains(cursor)) {
            run++;
            cursor = cursor.minusDays(1);
        }
        return run;
    }

    /** The longest run anywhere in the history; 0 for no days. */
    public static int longest(Collection<LocalDate> days) {
        int best = 0;
        int run = 0;
        LocalDate previous = null;
        for (LocalDate day : new TreeSet<>(days)) {
            run = previous != null && day.equals(previous.plusDays(1)) ? run + 1 : 1;
            best = Math.max(best, run);
            previous = day;
        }
        return best;
    }
}
