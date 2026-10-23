package com.codebite.streak.entity;

import com.codebite.common.base.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

import java.time.LocalDate;

/**
 * A day that counts toward a user's Streak: either a real Streak Day (at least one Accepted
 * submission on that UTC date) or a Repaired Day (a Missed Day filled by spending a Repair).
 *
 * <p>At most one row per user per date, enforced by a unique constraint.
 */
@Entity
@Table(name = "streak_days")
public class StreakDay extends BaseEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "streak_date", nullable = false)
    private LocalDate streakDate;

    @Column(nullable = false)
    private boolean repaired;

    protected StreakDay() {
    }

    public StreakDay(Long userId, LocalDate streakDate, boolean repaired) {
        this.userId = userId;
        this.streakDate = streakDate;
        this.repaired = repaired;
    }

    public Long getUserId() {
        return userId;
    }

    public LocalDate getStreakDate() {
        return streakDate;
    }

    public boolean isRepaired() {
        return repaired;
    }

    public void setRepaired(boolean repaired) {
        this.repaired = repaired;
    }
}
