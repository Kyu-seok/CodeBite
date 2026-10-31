package com.codebite.user.repository;

import com.codebite.user.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.List;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    // Admin users page. Solved is UserProgress's rule (Accepted, non-admin), counted live here rather
    // than read from user_stats because that table was never backfilled: a user with no submission
    // since it was added has no row and would read 0.
    @Query(value = "SELECT new com.codebite.user.repository.UserOverview("
           + "u.id, u.username, u.email, u.role, u.avatarUrl, u.createdAt, "
           + "COUNT(DISTINCT CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED "
           + "AND s.adminSubmission = false THEN s.problem.id END), "
           + "MAX(s.createdAt)) "
           + "FROM User u LEFT JOIN Submission s ON u.id = s.user.id "
           + "GROUP BY u.id, u.username, u.email, u.role, u.avatarUrl, u.createdAt",
           countQuery = "SELECT COUNT(u) FROM User u")
    Page<UserOverview> findAllOverviews(Pageable pageable);

    // Admin dashboard, onboarding success: every non-admin user who signed up since then, with
    // their first Accepted, non-admin submission (null when there is none).
    @Query("SELECT new com.codebite.user.repository.SignUp(u.createdAt, MIN(s.createdAt)) "
           + "FROM User u LEFT JOIN Submission s ON s.user.id = u.id "
           + "AND s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED "
           + "AND s.adminSubmission = false "
           + "WHERE u.createdAt >= :since AND u.role <> com.codebite.user.entity.Role.ADMIN "
           + "GROUP BY u.id, u.createdAt")
    List<SignUp> findSignUpsSince(@Param("since") Instant since);
}
