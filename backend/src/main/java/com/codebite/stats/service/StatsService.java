package com.codebite.stats.service;

import com.codebite.stats.dto.LeaderboardEntry;
import com.codebite.stats.entity.ProblemStats;
import com.codebite.stats.entity.UserStats;
import com.codebite.stats.repository.ProblemStatsRepository;
import com.codebite.stats.repository.UserStatsRepository;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
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
 */
@Service
public class StatsService {

    private static final Logger log = LoggerFactory.getLogger(StatsService.class);

    private final SubmissionRepository submissionRepository;
    private final UserStatsRepository userStatsRepository;
    private final ProblemStatsRepository problemStatsRepository;
    private final UserRepository userRepository;

    public StatsService(SubmissionRepository submissionRepository,
                        UserStatsRepository userStatsRepository,
                        ProblemStatsRepository problemStatsRepository,
                        UserRepository userRepository) {
        this.submissionRepository = submissionRepository;
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
        Object[] row = unwrap(submissionRepository.aggregateForUser(userId));
        if (row == null) {
            return;
        }

        UserStats stats = userStatsRepository.findById(userId).orElseGet(() -> new UserStats(userId));
        stats.setSolvedCount(toInt(row[0]));
        stats.setAttemptedCount(toInt(row[1]));
        stats.setTotalSubmissions(toInt(row[2]));
        stats.setAcceptedSubmissions(toInt(row[3]));
        stats.setLastSolvedAt((Instant) row[4]);
        userStatsRepository.save(stats);

        log.debug("Recomputed user {}: solved={} accepted={}/{}",
                userId, stats.getSolvedCount(), stats.getAcceptedSubmissions(),
                stats.getTotalSubmissions());
    }

    private void recomputeProblem(Long problemId) {
        Object[] row = unwrap(submissionRepository.aggregateForProblem(problemId));
        if (row == null) {
            return;
        }

        ProblemStats stats = problemStatsRepository.findById(problemId)
                .orElseGet(() -> new ProblemStats(problemId));
        stats.setTotalSubmissions(toInt(row[0]));
        stats.setAcceptedSubmissions(toInt(row[1]));
        problemStatsRepository.save(stats);
    }

    /**
     * A JPA aggregate projection with several columns arrives as Object[], but some providers wrap
     * it in a single-element Object[] holding that array. Normalise both shapes.
     */
    private static Object[] unwrap(Object[] row) {
        if (row == null || row.length == 0) {
            return null;
        }
        if (row.length == 1 && row[0] instanceof Object[] inner) {
            return inner;
        }
        return row;
    }

    /** COUNT yields Long and SUM yields Long or null when no rows matched. */
    private static int toInt(Object value) {
        return value == null ? 0 : ((Number) value).intValue();
    }
}
