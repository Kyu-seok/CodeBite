package com.codebite.admin.controller;

import com.codebite.admin.dto.AdminRecentSubmission;
import com.codebite.admin.dto.AdminUserDto;
import com.codebite.admin.dto.DailySubmissionDto;
import com.codebite.admin.dto.OverviewStats;
import com.codebite.admin.dto.ProblemAnalyticsDto;
import com.codebite.admin.service.AdminAnalyticsService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/admin/analytics")
@PreAuthorize("hasRole('ADMIN')")
public class AdminAnalyticsController {

    private final AdminAnalyticsService analyticsService;

    public AdminAnalyticsController(AdminAnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    @GetMapping("/overview")
    public OverviewStats getOverview() {
        return analyticsService.getOverviewStats();
    }

    @GetMapping("/submissions")
    public List<DailySubmissionDto> getDailySubmissions(@RequestParam(defaultValue = "30") int days) {
        return analyticsService.getDailySubmissions(days);
    }

    @GetMapping("/problems")
    public List<ProblemAnalyticsDto> getProblemAnalytics() {
        return analyticsService.getProblemAnalytics();
    }

    @GetMapping("/recent-submissions")
    public List<AdminRecentSubmission> getRecentSubmissions(@RequestParam(defaultValue = "10") int limit) {
        return analyticsService.getRecentSubmissions(limit);
    }

    @GetMapping("/users")
    public Page<AdminUserDto> getUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        return analyticsService.getUsers(PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt")));
    }
}
