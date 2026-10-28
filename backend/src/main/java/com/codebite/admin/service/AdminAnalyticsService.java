package com.codebite.admin.service;

import com.codebite.admin.dto.AdminRecentSubmission;
import com.codebite.admin.dto.AdminUserDto;
import com.codebite.admin.dto.DailySubmissionDto;
import com.codebite.admin.dto.OverviewStats;
import com.codebite.admin.dto.ProblemAnalyticsDto;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.progress.ProblemPopularity;
import com.codebite.progress.ProblemPopularity.Rate;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Map;

@Service
public class AdminAnalyticsService {

    private final UserRepository userRepository;
    private final ProblemRepository problemRepository;
    private final SubmissionRepository submissionRepository;
    private final ProblemPopularity problemPopularity;

    public AdminAnalyticsService(UserRepository userRepository,
                                  ProblemRepository problemRepository,
                                  SubmissionRepository submissionRepository,
                                  ProblemPopularity problemPopularity) {
        this.userRepository = userRepository;
        this.problemRepository = problemRepository;
        this.submissionRepository = submissionRepository;
        this.problemPopularity = problemPopularity;
    }

    @Transactional(readOnly = true)
    public OverviewStats getOverviewStats() {
        long totalUsers = userRepository.count();
        long totalProblems = problemRepository.count();
        long totalSubmissions = submissionRepository.count();

        Instant startOfToday = LocalDate.now().atStartOfDay(ZoneOffset.UTC).toInstant();
        long submissionsToday = submissionRepository.countSince(startOfToday);

        return new OverviewStats(totalUsers, totalProblems, totalSubmissions, submissionsToday);
    }

    @Transactional(readOnly = true)
    public List<DailySubmissionDto> getDailySubmissions(int days) {
        Instant since = LocalDate.now().minusDays(days).atStartOfDay(ZoneOffset.UTC).toInstant();
        return submissionRepository.countDailySubmissions(since).stream()
                .map(row -> new DailySubmissionDto((LocalDate) row[0], (Long) row[1]))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<ProblemAnalyticsDto> getProblemAnalytics() {
        Map<Long, Rate> rates = problemPopularity.acceptanceRatesForAll();
        return problemRepository.findAll().stream()
                .map(p -> {
                    Rate rate = rates.getOrDefault(p.getId(), Rate.NONE);
                    return new ProblemAnalyticsDto(
                            p.getId(), p.getTitle(), p.getSlug(), p.getDifficulty(),
                            rate.total(), rate.accepted(), rate.percent()
                    );
                })
                .sorted((a, b) -> Long.compare(b.totalSubmissions(), a.totalSubmissions()))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<AdminRecentSubmission> getRecentSubmissions(int limit) {
        return submissionRepository.findRecentGlobal(PageRequest.of(0, limit)).stream()
                .map(s -> new AdminRecentSubmission(
                        s.getId(),
                        s.getUser().getUsername(),
                        s.getProblem().getTitle(),
                        s.getProblem().getSlug(),
                        s.getStatus(),
                        s.getLanguage(),
                        s.getRuntimeMs(),
                        s.getCreatedAt()
                ))
                .toList();
    }

    @Transactional(readOnly = true)
    public Page<AdminUserDto> getUsers(Pageable pageable) {
        return userRepository.findAllOverviews(pageable)
                .map(u -> new AdminUserDto(u.id(), u.username(), u.email(), u.role(), u.avatarUrl(),
                        u.createdAt(), u.solvedCount(), u.lastSubmittedAt()));
    }
}
