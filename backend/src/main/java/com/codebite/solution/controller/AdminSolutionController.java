package com.codebite.solution.controller;

import com.codebite.solution.dto.ReportListItem;
import com.codebite.solution.dto.ResolveReportRequest;
import com.codebite.solution.entity.ReportStatus;
import com.codebite.solution.entity.ReportTargetType;
import com.codebite.solution.service.ReportService;
import com.codebite.solution.service.SolutionService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminSolutionController {

    private final ReportService reportService;
    private final SolutionService solutionService;

    public AdminSolutionController(ReportService reportService, SolutionService solutionService) {
        this.reportService = reportService;
        this.solutionService = solutionService;
    }

    @GetMapping("/reports")
    public Page<ReportListItem> listReports(
            @RequestParam(required = false) ReportStatus status,
            @RequestParam(required = false) ReportTargetType type,
            @PageableDefault(size = 50, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        return reportService.list(status, type, pageable);
    }

    @PostMapping("/reports/{id}/resolve")
    public ResponseEntity<Void> resolveReport(
            @PathVariable Long id,
            @Valid @RequestBody ResolveReportRequest request) {
        reportService.resolve(id, request);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/solutions/{id}/hide")
    public ResponseEntity<Void> hideSolution(@PathVariable Long id) {
        solutionService.setPublished(id, false);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/solutions/{id}/unhide")
    public ResponseEntity<Void> unhideSolution(@PathVariable Long id) {
        solutionService.setPublished(id, true);
        return ResponseEntity.noContent().build();
    }
}
