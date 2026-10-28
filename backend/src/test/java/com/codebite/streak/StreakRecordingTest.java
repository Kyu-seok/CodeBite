package com.codebite.streak;

import com.codebite.judge.grader.Verdict;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.streak.entity.StreakDay;
import com.codebite.streak.entity.UserStreak;
import com.codebite.streak.repository.StreakDayRepository;
import com.codebite.streak.repository.UserStreakRepository;
import com.codebite.streak.service.StreakService;
import com.codebite.submission.entity.Submission;
import com.codebite.user.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Runs against the real schema: the upsert and the row lock are native/dialect-sensitive, and the
 * unique (user, date) constraint is what makes redelivery safe.
 */
@DataJpaTest
@ActiveProfiles("test")
@Import(StreakService.class)
@Sql(statements = {
        "DELETE FROM streak_days",
        "DELETE FROM user_streaks",
        "DELETE FROM submission_results",
        "DELETE FROM submissions",
        "DELETE FROM problems",
        "DELETE FROM users"
}, executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
class StreakRecordingTest {

    private static final LocalDate MONDAY = LocalDate.of(2026, 10, 19);

    @Autowired private StreakService streakService;
    @Autowired private StreakDayRepository streakDayRepository;
    @Autowired private UserStreakRepository userStreakRepository;
    @Autowired private TestEntityManager entityManager;

    private User user;
    private Problem problem;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUsername("streak-user");
        user.setEmail("streak@test.com");
        user.setPasswordHash("hash");
        user = entityManager.persist(user);

        problem = new Problem();
        problem.setTitle("streak-problem");
        problem.setSlug("streak-problem");
        problem.setDescription("d");
        problem.setDifficulty(Difficulty.EASY);
        problem.setPublished(true);
        problem = entityManager.persist(problem);
        entityManager.flush();
    }

    /** An Accepted submission made at noon UTC on the given day. */
    private Long acceptedOn(LocalDate day) {
        Submission submission = Submission.pending(user, problem, "python", "x");
        submission.grade(Verdict.empty(), List.of());
        submission = entityManager.persistAndFlush(submission);

        // created_at is set by @CreationTimestamp on insert, so backdate it afterwards.
        submission.setCreatedAt(day.atTime(12, 0).toInstant(ZoneOffset.UTC));
        entityManager.getEntityManager()
                .createQuery("UPDATE Submission s SET s.createdAt = :at WHERE s.id = :id")
                .setParameter("at", submission.getCreatedAt())
                .setParameter("id", submission.getId())
                .executeUpdate();
        entityManager.clear();
        return submission.getId();
    }

    private UserStreak streak() {
        entityManager.flush();
        entityManager.clear();
        return userStreakRepository.findById(user.getId()).orElseThrow();
    }

    @Test
    void firstSolveRecordsTheDayAndAdvancesProgress() {
        streakService.recordSolve(user.getId(), acceptedOn(MONDAY));

        assertEquals(1, streakDayRepository.findByUserIdOrderByStreakDateAsc(user.getId()).size());
        assertEquals(1, streak().getRepairProgress());
        assertEquals(0, streak().getRepairs());
    }

    @Test
    void replaysAndSecondSolvesOnTheSameDayChangeNothing() {
        Long first = acceptedOn(MONDAY);
        Long second = acceptedOn(MONDAY);

        streakService.recordSolve(user.getId(), first);
        streakService.recordSolve(user.getId(), first);
        streakService.recordSolve(user.getId(), second);

        assertEquals(1, streakDayRepository.findByUserIdOrderByStreakDateAsc(user.getId()).size());
        assertEquals(1, streak().getRepairProgress(), "progress counts days, not events");
    }

    @Test
    void fiveStreakDaysEarnARepairEvenWithMissedDaysBetween() {
        for (int i = 0; i < 5; i++) {
            // Every other day: Repair Progress is never reset by a Missed Day.
            streakService.recordSolve(user.getId(), acceptedOn(MONDAY.plusDays(i * 2L)));
        }

        assertEquals(1, streak().getRepairs());
        assertEquals(0, streak().getRepairProgress());
    }

    @Test
    void solvingARepairedDayLeavesItRepaired() {
        streakService.recordSolve(user.getId(), acceptedOn(MONDAY));
        streakDayRepository.save(new StreakDay(user.getId(), MONDAY.plusDays(1), true));

        // A submission from the repaired day comes back Accepted after the Repair was spent.
        streakService.recordSolve(user.getId(), acceptedOn(MONDAY.plusDays(1)));

        StreakDay tuesday = streakDayRepository
                .findByUserIdAndStreakDate(user.getId(), MONDAY.plusDays(1)).orElseThrow();
        assertTrue(tuesday.isRepaired(), "the day stays repaired");
        assertEquals(0, streak().getRepairs(), "the spent Repair is not refunded");
        assertEquals(1, streak().getRepairProgress(), "only Monday advanced Repair Progress");
    }

    @Test
    void unknownSubmissionIsIgnored() {
        streakService.recordSolve(user.getId(), 999_999L);

        assertEquals(0, streakDayRepository.count());
    }

    @Test
    void theDayIsWhenTheSubmissionWasMadeInUtc() {
        Long late = acceptedOn(MONDAY);
        entityManager.getEntityManager()
                .createQuery("UPDATE Submission s SET s.createdAt = :at WHERE s.id = :id")
                .setParameter("at", Instant.parse("2026-10-19T23:59:00Z"))
                .setParameter("id", late)
                .executeUpdate();
        entityManager.clear();

        streakService.recordSolve(user.getId(), late);

        assertEquals(MONDAY, streakDayRepository.findByUserIdOrderByStreakDateAsc(user.getId())
                .get(0).getStreakDate());
    }
}
