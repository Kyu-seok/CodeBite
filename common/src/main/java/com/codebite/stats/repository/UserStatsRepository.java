package com.codebite.stats.repository;

import com.codebite.stats.entity.UserStats;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface UserStatsRepository extends JpaRepository<UserStats, Long> {

    /**
     * Leaderboard page. Ties on solved count break by who reached it first, so the ordering is
     * stable across requests rather than arbitrary.
     */
    @Query("SELECT s FROM UserStats s WHERE s.solvedCount > 0 "
            + "ORDER BY s.solvedCount DESC, s.lastSolvedAt ASC")
    List<UserStats> findLeaderboard(Pageable pageable);

    /** Rank is 1 + the number of users strictly ahead, so equal scores share a rank. */
    @Query("SELECT COUNT(s) FROM UserStats s WHERE s.solvedCount > :solvedCount")
    long countAhead(int solvedCount);
}
