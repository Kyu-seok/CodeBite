package com.codebite.github.repository;

import com.codebite.github.entity.GitHubLink;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GitHubLinkRepository extends JpaRepository<GitHubLink, Long> {

    /** The user's current (ACTIVE or BROKEN) GitHub Link, if any. UNLINKED rows never match. */
    Optional<GitHubLink> findByActiveUserId(Long userId);
}
