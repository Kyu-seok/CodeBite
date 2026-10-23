package com.codebite.github.repository;

import com.codebite.github.entity.GitHubLink;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface GitHubLinkRepository extends JpaRepository<GitHubLink, Long> {

    /** The user's current (ACTIVE or BROKEN) GitHub Link, if any. UNLINKED rows never match. */
    Optional<GitHubLink> findByActiveUserId(Long userId);

    /**
     * Moves the link's Import to RUNNING if it is AVAILABLE or FAILED, atomically, so two requests
     * racing to start an Import cannot both win.
     *
     * @return 1 if this call started the Import, 0 if it was already RUNNING or DONE
     */
    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("""
            UPDATE GitHubLink l SET l.importState = com.codebite.github.entity.GitHubImportState.RUNNING
            WHERE l.id = :id
              AND l.importState IN (com.codebite.github.entity.GitHubImportState.AVAILABLE,
                                    com.codebite.github.entity.GitHubImportState.FAILED)
            """)
    int claimImport(@Param("id") Long id);
}
