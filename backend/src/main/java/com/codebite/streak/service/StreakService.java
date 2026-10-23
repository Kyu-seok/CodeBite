package com.codebite.streak.service;

import com.codebite.common.exception.DuplicateResourceException;
import com.codebite.streak.dto.StreakCalendar;
import com.codebite.streak.dto.StreakSummary;
import com.codebite.streak.entity.StreakDay;
import com.codebite.streak.entity.UserStreak;
import com.codebite.streak.repository.StreakDayRepository;
import com.codebite.streak.repository.UserStreakRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneOffset;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.TreeSet;

/**
 * Owns Streak Days, Repairs and Repair Progress. Vocabulary is defined in GLOSSARY.md; days are
 * UTC dates (ADR 0001).
 *
 * <p><strong>Idempotent under redelivery.</strong> Repair Progress only advances when a Streak Day
 * row is created, never on the event itself, so replaying a
 * submission result, or a second Accepted submission on the same day, changes nothing.
 *
 * <p><strong>Serialised per user.</strong> Every mutation first locks the user's
 * {@code user_streaks} row, so a solve and a Repair for the same day cannot interleave.
 */
@Service
public class StreakService {

    private static final Logger log = LoggerFactory.getLogger(StreakService.class);

    private final StreakDayRepository streakDayRepository;
    private final UserStreakRepository userStreakRepository;
    private final SubmissionRepository submissionRepository;

    public StreakService(StreakDayRepository streakDayRepository,
                         UserStreakRepository userStreakRepository,
                         SubmissionRepository submissionRepository) {
        this.streakDayRepository = streakDayRepository;
        this.userStreakRepository = userStreakRepository;
        this.submissionRepository = submissionRepository;
    }

    /**
     * Records the Streak Day earned by an Accepted submission. The day is the UTC date the
     * submission was made, not when its result arrived, so a submission judged after midnight
     * still counts for the day it was submitted.
     */
    @Transactional
    public void recordSolve(Long userId, Long submissionId) {
        Optional<Submission> submission = submissionRepository.findById(submissionId);
        if (submission.isEmpty()) {
            log.warn("Submission {} not found; no Streak Day recorded for user {}", submissionId, userId);
            return;
        }
        LocalDate day = LocalDate.ofInstant(submission.get().getCreatedAt(), ZoneOffset.UTC);

        UserStreak streak = lockStreak(userId);
        // A day already counted is left alone. That includes a Repaired Day later found to be
        // solved (its submission was still being judged): it stays repaired and the Repair stays
        // spent, so a spent Repair is never handed back.
        if (streakDayRepository.findByUserIdAndStreakDate(userId, day).isEmpty()) {
            streakDayRepository.save(new StreakDay(userId, day, false));
            streak.advanceProgress();
        }
    }

    @Transactional(readOnly = true)
    public StreakSummary getSummary(Long userId) {
        return getSummary(userId, LocalDate.now(ZoneOffset.UTC));
    }

    @Transactional(readOnly = true)
    public StreakSummary getSummary(Long userId, LocalDate today) {
        List<LocalDate> days = streakDayRepository.findByUserIdOrderByStreakDateAsc(userId).stream()
                .map(StreakDay::getStreakDate)
                .toList();
        Optional<UserStreak> streak = userStreakRepository.findById(userId);
        return new StreakSummary(
                currentStreak(days, today),
                bestStreak(days),
                days.contains(today),
                streak.map(UserStreak::getRepairs).orElse(0),
                streak.map(UserStreak::getRepairProgress).orElse(0));
    }

    @Transactional(readOnly = true)
    public StreakCalendar getCalendar(Long userId, YearMonth month) {
        List<StreakCalendar.Day> days = streakDayRepository
                .findByUserIdAndStreakDateBetweenOrderByStreakDateAsc(
                        userId, month.atDay(1), month.atEndOfMonth()).stream()
                .map(d -> new StreakCalendar.Day(d.getStreakDate(), d.isRepaired()))
                .toList();
        return new StreakCalendar(
                month.toString(),
                LocalDate.now(ZoneOffset.UTC),
                streakDayRepository.findFirstStreakDate(userId).orElse(null),
                days);
    }

    @Transactional
    public StreakSummary repair(Long userId, LocalDate date) {
        return repair(userId, date, LocalDate.now(ZoneOffset.UTC));
    }

    /**
     * Spends one Repair to turn {@code date} into a Repaired Day. The user picks any Missed Day: a
     * past day after their first real Streak Day that is not already counted. Today cannot be
     * repaired, since it is not over and can still be solved.
     */
    @Transactional
    public StreakSummary repair(Long userId, LocalDate date, LocalDate today) {
        if (!date.isBefore(today)) {
            throw new IllegalArgumentException("Only past days can be repaired");
        }
        Optional<LocalDate> first = streakDayRepository.findFirstStreakDate(userId);
        if (first.isEmpty() || !date.isAfter(first.get())) {
            throw new IllegalArgumentException("Days before your first Streak Day cannot be repaired");
        }

        // A user who has never earned a Repair has no row; there is nothing to lock or spend.
        UserStreak streak = userStreakRepository.findByIdForUpdate(userId)
                .filter(s -> s.getRepairs() > 0)
                .orElseThrow(() -> new IllegalArgumentException("No Repairs left"));
        if (streakDayRepository.findByUserIdAndStreakDate(userId, date).isPresent()) {
            throw new DuplicateResourceException("That day already counts toward your Streak");
        }

        streak.spendRepair();
        streakDayRepository.save(new StreakDay(userId, date, true));
        streakDayRepository.flush();
        return getSummary(userId, today);
    }

    /** Locks the user's streak row, creating it on their first Streak Day. */
    UserStreak lockStreak(Long userId) {
        userStreakRepository.insertIfAbsent(userId);
        return userStreakRepository.findByIdForUpdate(userId)
                .orElseThrow(() -> new IllegalStateException("user_streaks row missing for " + userId));
    }

    /**
     * The current Streak: consecutive days ending today, or yesterday if today is not done yet, so
     * the Streak does not read 0 all morning before the user solves.
     */
    public static int currentStreak(Collection<LocalDate> days, LocalDate today) {
        TreeSet<LocalDate> set = new TreeSet<>(days);
        LocalDate cursor = set.contains(today) ? today : today.minusDays(1);
        int streak = 0;
        while (set.contains(cursor)) {
            streak++;
            cursor = cursor.minusDays(1);
        }
        return streak;
    }

    /** The longest run of consecutive days anywhere in the history. */
    public static int bestStreak(Collection<LocalDate> days) {
        List<LocalDate> sorted = new TreeSet<>(days).stream().toList();
        int best = 0;
        int run = 0;
        LocalDate previous = null;
        for (LocalDate day : sorted) {
            run = previous != null && day.equals(previous.plusDays(1)) ? run + 1 : 1;
            best = Math.max(best, run);
            previous = day;
        }
        return best;
    }
}
