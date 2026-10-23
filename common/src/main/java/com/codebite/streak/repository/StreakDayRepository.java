package com.codebite.streak.repository;

import com.codebite.streak.entity.StreakDay;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface StreakDayRepository extends JpaRepository<StreakDay, Long> {

    Optional<StreakDay> findByUserIdAndStreakDate(Long userId, LocalDate streakDate);

    /** Every day counting toward the Streak, oldest first. */
    List<StreakDay> findByUserIdOrderByStreakDateAsc(Long userId);

    List<StreakDay> findByUserIdAndStreakDateBetweenOrderByStreakDateAsc(
            Long userId, LocalDate from, LocalDate to);

    /** The user's first real Streak Day; no earlier day can be a Missed Day. */
    @Query("SELECT MIN(d.streakDate) FROM StreakDay d WHERE d.userId = :userId AND d.repaired = false")
    Optional<LocalDate> findFirstStreakDate(@Param("userId") Long userId);
}
