package com.codebite.progress;

import com.codebite.stats.entity.ProblemStats;
import com.codebite.stats.repository.ProblemStatsRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Acceptance Rate per problem: Accepted graded non-admin submissions over all graded non-admin
 * submissions, as a percentage to one decimal ({@link ProblemStats#acceptanceRate()}).
 *
 * <p>Reads {@code problem_stats}, which the {@code codebite-stats} consumer recomputes from
 * {@code submissions} after every graded non-admin submission and V195 backfilled once, so a read
 * never aggregates the {@code submissions} table. The rate therefore lags a submission by the
 * consumer's latency, and a recompute the consumer logged and skipped stays stale until the
 * problem's next graded submission. A problem with no row reads {@link Rate#NONE}.
 */
@Service
public class ProblemPopularity {

    /** Graded, non-admin submissions to one problem and the share of them Accepted. */
    public record Rate(long total, long accepted, double percent) {

        /** What a problem nobody has been graded on reads. */
        public static final Rate NONE = new Rate(0, 0, 0.0);

        static Rate of(ProblemStats stats) {
            return new Rate(stats.getTotalSubmissions(), stats.getAcceptedSubmissions(),
                    stats.acceptanceRate());
        }

        /** The percentage, or null while nothing has been graded, so a list shows a dash, not 0%. */
        public Double percentIfGraded() {
            return total == 0 ? null : percent;
        }
    }

    private final ProblemStatsRepository problemStatsRepository;

    public ProblemPopularity(ProblemStatsRepository problemStatsRepository) {
        this.problemStatsRepository = problemStatsRepository;
    }

    /** One entry per requested problem, {@link Rate#NONE} for a problem without a row. */
    @Transactional(readOnly = true)
    public Map<Long, Rate> acceptanceRates(Collection<Long> problemIds) {
        Map<Long, Rate> rates = new HashMap<>();
        if (problemIds.isEmpty()) {
            return rates;
        }
        for (ProblemStats stats : problemStatsRepository.findAllById(problemIds)) {
            rates.put(stats.getProblemId(), Rate.of(stats));
        }
        for (Long problemId : problemIds) {
            rates.putIfAbsent(problemId, Rate.NONE);
        }
        return rates;
    }

    /** Every problem with a row; a problem absent here reads {@link Rate#NONE}. Admin analytics. */
    @Transactional(readOnly = true)
    public Map<Long, Rate> acceptanceRatesForAll() {
        return problemStatsRepository.findAll().stream()
                .collect(Collectors.toMap(ProblemStats::getProblemId, Rate::of));
    }
}
