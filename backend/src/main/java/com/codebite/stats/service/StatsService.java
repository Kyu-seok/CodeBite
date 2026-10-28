package com.codebite.stats.service;

import com.codebite.progress.ProblemPopularity;
import com.codebite.progress.ProblemPopularity.Rate;
import com.codebite.progress.UserProgress;
import com.codebite.progress.UserProgress.Aggregate;
import com.codebite.stats.dto.LeaderboardEntry;
import com.codebite.stats.entity.ProblemStats;
import com.codebite.stats.entity.UserStats;
import com.codebite.stats.repository.ProblemStatsRepository;
import com.codebite.stats.repository.UserStatsRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Maintains the precomputed aggregates in {@code user_stats} and {@code problem_stats}.
 *
 * <p><strong>Idempotent by construction.</strong> Kafka delivery is at-least-once, so this will see
 * the same result event more than once — on consumer rebalance, on a re-driven submission, on any
 * redelivery. Rather than track processed ids, each update <em>recomputes</em> the affected row
 * from {@code submissions}, which is the source of truth. Replaying an event therefore converges on
 * the same numbers instead of double-counting, and a corrupted row is repaired by replaying the
 * topic rather than by hand.
 *
 * <p>The cost is one aggregate query per graded submission — roughly 0.65/sec — in exchange for
 * removing a full table group-by from the problem-list read path.
 *
 * <p>The aggregates come from {@link UserProgress#aggregate} and {@link ProblemPopularity#recount},
 * so what this writes and what the pages read are one definition of Solved and Acceptance Rate.
 */
@Service
public class StatsService {

    private static final Logger log = LoggerFactory.getLogger(StatsService.class);

    private final UserProgress userProgress;
    private final ProblemPopularity problemPopularity;
    private final UserStatsRepository userStatsRepository;
    private final ProblemStatsRepository problemStatsRepository;
    private final UserRepository userRepository;

    public StatsService(UserProgress userProgress,
                        ProblemPopularity problemPopularity,
                        UserStatsRepository userStatsRepository,
                        ProblemStatsRepository problemStatsRepository,
                        UserRepository userRepository) {
        this.userProgress = userProgress;
        this.problemPopularity = problemPopularity;
        this.userStatsRepository = userStatsRepository;
        this.problemStatsRepository = problemStatsRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public void recompute(Long userId, Long problemId) {
        recomputeUser(userId);
        recomputeProblem(problemId);
    }

    /**
     * Leaderboard page. Reads only the precomputed table — no aggregate over {@code submissions}.
     * Equal solved counts share a rank, so the numbering matches what a reader expects.
     */
    @Transactional(readOnly = true)
    public List<LeaderboardEntry> leaderboard(int limit) {
        List<UserStats> top = userStatsRepository.findLeaderboard(PageRequest.of(0, limit));
        Map<Long, String> usernames = userRepository.findAllById(
                        top.stream().map(UserStats::getUserId).toList()).stream()
                .collect(Collectors.toMap(User::getId, User::getUsername));

        List<LeaderboardEntry> entries = new ArrayList<>(top.size());
        long rank = 0;
        int previousSolved = Integer.MIN_VALUE;
        for (int i = 0; i < top.size(); i++) {
            UserStats stats = top.get(i);
            if (stats.getSolvedCount() != previousSolved) {
                rank = i + 1L;
                previousSolved = stats.getSolvedCount();
            }
            entries.add(new LeaderboardEntry(
                    rank,
                    stats.getUserId(),
                    usernames.getOrDefault(stats.getUserId(), "unknown"),
                    stats.getSolvedCount(),
                    stats.getAttemptedCount(),
                    stats.acceptanceRate(),
                    stats.getLastSolvedAt()));
        }
        return entries;
    }

    private void recomputeUser(Long userId) {
        Aggregate aggregate = userProgress.aggregate(userId);

        UserStats stats = userStatsRepository.findById(userId).orElseGet(() -> new UserStats(userId));
        stats.setSolvedCount(aggregate.solved().intValue());
        stats.setAttemptedCount(aggregate.attempted().intValue());
        stats.setTotalSubmissions(aggregate.total().intValue());
        stats.setAcceptedSubmissions(aggregate.accepted().intValue());
        stats.setLastSolvedAt(aggregate.lastSolvedAt());
        userStatsRepository.save(stats);

        log.debug("Recomputed user {}: solved={} accepted={}/{}",
                userId, stats.getSolvedCount(), stats.getAcceptedSubmissions(),
                stats.getTotalSubmissions());
    }

    private void recomputeProblem(Long problemId) {
        Rate rate = problemPopularity.recount(problemId);

        ProblemStats stats = problemStatsRepository.findById(problemId)
                .orElseGet(() -> new ProblemStats(problemId));
        stats.setTotalSubmissions((int) rate.total());
        stats.setAcceptedSubmissions((int) rate.accepted());
        problemStatsRepository.save(stats);
    }
}
