package com.codebite.admin.service;

import com.codebite.admin.dto.AdminRecentSubmission;
import com.codebite.admin.dto.AdminUserDto;
import com.codebite.admin.dto.DailySubmissionDto;
import com.codebite.admin.dto.OverviewStats;
import com.codebite.admin.dto.ProblemAnalyticsDto;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.Role;
import com.codebite.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminAnalyticsService {

    private final UserRepository userRepository;
    private final ProblemRepository problemRepository;
    private final SubmissionRepository submissionRepository;

    public AdminAnalyticsService(UserRepository userRepository,
                                  ProblemRepository problemRepository,
                                  SubmissionRepository submissionRepository) {
        this.userRepository = userRepository;
        this.problemRepository = problemRepository;
        this.submissionRepository = submissionRepository;
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
        // Build acceptance rate map: problemId -> [total, accepted]
        Map<Long, long[]> acceptanceMap = new HashMap<>();
        for (Object[] row : submissionRepository.findAcceptanceRates()) {
            Long problemId = (Long) row[0];
            long total = (Long) row[1];
            long accepted = (Long) row[2];
            acceptanceMap.put(problemId, new long[]{total, accepted});
        }

        // Get all problems and merge with acceptance data
        return problemRepository.findAll().stream()
                .map(p -> {
                    long[] stats = acceptanceMap.getOrDefault(p.getId(), new long[]{0, 0});
                    double rate = stats[0] > 0 ? Math.round(stats[1] * 1000.0 / stats[0]) / 10.0 : 0.0;
                    return new ProblemAnalyticsDto(
                            p.getId(), p.getTitle(), p.getSlug(), p.getDifficulty(),
                            stats[0], stats[1], rate
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
        Page<Object[]> page = userRepository.findUsersWithStats(pageable);
        List<AdminUserDto> users = page.getContent().stream()
                .map(row -> new AdminUserDto(
                        (Long) row[0],
                        (String) row[1],
                        (String) row[2],
                        (Role) row[3],
                        (String) row[4],
                        (Instant) row[5],
                        row[6] != null ? (Long) row[6] : 0L,
                        (Instant) row[7]
                ))
                .toList();
        return new PageImpl<>(users, pageable, page.getTotalElements());
    }
}
