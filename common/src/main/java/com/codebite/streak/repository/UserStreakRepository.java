package com.codebite.streak.repository;

import com.codebite.streak.entity.UserStreak;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserStreakRepository extends JpaRepository<UserStreak, Long> {

    /**
     * Creates the row if it does not exist. Plain SQL rather than {@code ON CONFLICT}, which the
     * H2 test database does not parse. Two first-ever events for the same user racing here fail
     * one of them on the primary key; that caller's transaction rolls back and its Kafka record is
     * retried, by which time the row exists.
     */
    @Modifying
    @Query(value = "INSERT INTO user_streaks (user_id) SELECT :userId "
            + "WHERE NOT EXISTS (SELECT 1 FROM user_streaks WHERE user_id = :userId)",
            nativeQuery = true)
    void insertIfAbsent(@Param("userId") Long userId);

    /** Row lock that serialises every streak mutation (solve or Repair) for one user. */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT s FROM UserStreak s WHERE s.userId = :userId")
    Optional<UserStreak> findByIdForUpdate(@Param("userId") Long userId);
}
