package com.codebite.streak.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;

/**
 * A user's Repairs held and Repair Progress, the parts of streak state that cannot be read back
 * from {@code streak_days}.
 *
 * <p>Keyed by user id: one row per user, and the row doubles as the lock that serialises every
 * streak mutation for that user.
 */
@Entity
@Table(name = "user_streaks")
public class UserStreak {

    /** A user never holds more than this many Repairs; any earned beyond it are forfeited. */
    public static final int MAX_REPAIRS = 5;

    /** Streak Days needed to earn one Repair. */
    public static final int DAYS_PER_REPAIR = 5;

    @Id
    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false)
    private int repairs;

    @Column(name = "repair_progress", nullable = false)
    private int repairProgress;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected UserStreak() {
    }

    public UserStreak(Long userId) {
        this.userId = userId;
    }

    public Long getUserId() {
        return userId;
    }

    public int getRepairs() {
        return repairs;
    }

    public int getRepairProgress() {
        return repairProgress;
    }

    /**
     * Counts one new real Streak Day. Every {@value #DAYS_PER_REPAIR}th earns a Repair, which is
     * forfeited if the user already holds {@value #MAX_REPAIRS}; Progress resets either way.
     */
    public void advanceProgress() {
        repairProgress++;
        if (repairProgress == DAYS_PER_REPAIR) {
            repairProgress = 0;
            grantRepair();
        }
    }

    /** Adds a Repair unless the user is already at the cap. */
    public void grantRepair() {
        repairs = Math.min(MAX_REPAIRS, repairs + 1);
    }

    public void spendRepair() {
        if (repairs == 0) {
            throw new IllegalStateException("No Repairs left for user " + userId);
        }
        repairs--;
    }
}
