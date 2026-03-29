package com.codebite.user.repository;

import com.codebite.user.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    @Query("SELECT u.id, u.username, u.email, u.role, u.avatarUrl, u.createdAt, " +
           "COUNT(DISTINCT CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED THEN s.problem.id END), " +
           "MAX(s.createdAt) " +
           "FROM User u LEFT JOIN Submission s ON u.id = s.user.id " +
           "GROUP BY u.id, u.username, u.email, u.role, u.avatarUrl, u.createdAt")
    Page<Object[]> findUsersWithStats(Pageable pageable);
}
