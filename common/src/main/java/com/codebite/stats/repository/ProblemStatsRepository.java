package com.codebite.stats.repository;

import com.codebite.stats.entity.ProblemStats;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProblemStatsRepository extends JpaRepository<ProblemStats, Long> {
}
