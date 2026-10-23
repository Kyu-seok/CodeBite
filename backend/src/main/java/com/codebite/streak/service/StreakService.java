package com.codebite.streak.service;

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
 * row is created (or a Repaired Day becomes real), never on the event itself, so replaying a
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
        Optional<StreakDay> existing = streakDayRepository.findByUserIdAndStreakDate(userId, day);
        if (existing.isEmpty()) {
            streakDayRepository.save(new StreakDay(userId, day, false));
            streak.advanceProgress();
        } else if (existing.get().isRepaired()) {
            // The user repaired a day they turn out to have solved, e.g. the submission was still
            // being judged. The day was never missed, so it becomes real and the Repair comes back.
            existing.get().setRepaired(false);
            streak.grantRepair();
            streak.advanceProgress();
        }
        // Otherwise the day is already a real Streak Day: nothing to do.
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
