package com.codebite.progress;

import com.codebite.stats.entity.ProblemStats;
import com.codebite.stats.repository.ProblemStatsRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
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
 *
 * <p>{@link #recount} is the other side of that seam: the same numbers live from
 * {@code submissions} for one problem, which is what the consumer writes into the row.
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

        /** The same rounding as {@link ProblemStats#acceptanceRate()}. */
        static Rate of(long total, long accepted) {
            return new Rate(total, accepted,
                    total == 0 ? 0.0 : Math.round(accepted * 1000.0 / total) / 10.0);
        }

        /** The percentage, or null while nothing has been graded, so a list shows a dash, not 0%. */
        public Double percentIfGraded() {
            return total == 0 ? null : percent;
        }
    }

    /** (total, accepted) as Hibernate hands the two columns back. */
    public record Recount(Long total, Long accepted) {
    }

    private final ProblemStatsRepository problemStatsRepository;

    @PersistenceContext
    private EntityManager entityManager;

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

    /**
     * The rate live from {@code submissions}: graded, non-admin. What {@code StatsService} writes
     * to {@code problem_stats} after each graded submission; never read on a page.
     */
    @Transactional(readOnly = true)
    public Rate recount(Long problemId) {
        Recount counts = entityManager.createQuery(
                        "SELECT COUNT(s), "
                                + "COALESCE(SUM(CASE WHEN s.status = com.codebite.submission.entity.SubmissionStatus.ACCEPTED THEN 1 ELSE 0 END), 0L) "
                                + "FROM Submission s WHERE s.problem.id = :problemId AND s.adminSubmission = false "
                                + "AND s.status <> com.codebite.submission.entity.SubmissionStatus.PENDING",
                        Recount.class)
                .setParameter("problemId", problemId)
                .getSingleResult();
        return Rate.of(counts.total(), counts.accepted());
    }

    /** Every problem with a row; a problem absent here reads {@link Rate#NONE}. Admin analytics. */
    @Transactional(readOnly = true)
    public Map<Long, Rate> acceptanceRatesForAll() {
        return problemStatsRepository.findAll().stream()
                .collect(Collectors.toMap(ProblemStats::getProblemId, Rate::of));
    }
}
