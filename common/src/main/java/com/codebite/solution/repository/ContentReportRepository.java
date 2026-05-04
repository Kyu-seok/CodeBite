package com.codebite.solution.repository;

import com.codebite.solution.entity.ContentReport;
import com.codebite.solution.entity.ReportStatus;
import com.codebite.solution.entity.ReportTargetType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContentReportRepository extends JpaRepository<ContentReport, Long> {

    Page<ContentReport> findByStatus(ReportStatus status, Pageable pageable);

    Page<ContentReport> findByStatusAndTargetType(ReportStatus status, ReportTargetType targetType, Pageable pageable);

    long countByStatusAndReporterIdAndCreatedAtAfter(ReportStatus status, Long reporterId, java.time.Instant after);
}
