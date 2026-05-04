package com.codebite.solution.repository;

import com.codebite.solution.entity.Solution;
import jakarta.persistence.LockModeType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface SolutionRepository extends JpaRepository<Solution, Long>, JpaSpecificationExecutor<Solution> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT s FROM Solution s WHERE s.id = :id")
    Optional<Solution> findByIdForUpdate(@Param("id") Long id);

    Page<Solution> findByProblemSlugAndPublishedTrue(String problemSlug, Pageable pageable);
}
