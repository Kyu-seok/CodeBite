-- One-off backfill of problem_stats from submissions.
--
-- V188 created problem_stats empty and left it to the codebite-stats consumer, so only problems
-- with a submission since then have a row. The problem list is about to read Acceptance Rate
-- from this table instead of a group-by over the whole submissions table on every page view,
-- and without this backfill every older problem would show no rate where it shows a real one today.
--
-- The numbers are exactly what StatsService.recomputeProblem writes from the live per-problem
-- recount (ProblemPopularity.recount): graded (not PENDING), non-admin submissions, counted and
-- summed per problem. A backfilled row is therefore indistinguishable from a consumer-written
-- one, and the next graded submission to the problem recomputes it from the same source anyway.
-- A problem with no graded non-admin submission gets no row, as today's group-by gives it none.
--
-- Delete-and-reinsert rather than an upsert: every row is derivable from submissions, so nothing
-- in the table is worth keeping, and this form runs unchanged on PostgreSQL 15 and on H2 in
-- PostgreSQL mode (the backend test suite runs it). If the stats consumer writes a row while this
-- runs, it recomputes the same row from the same source; a primary-key conflict makes its
-- transaction fail, which SubmissionStatsListener logs and skips, and the row is correct either
-- way because this statement wrote the same numbers.
-- ProblemStatsBackfillTest re-runs these statements over seeded submissions and checks them
-- against StatsService.recompute.

DELETE FROM problem_stats;

INSERT INTO problem_stats (problem_id, total_submissions, accepted_submissions)
SELECT problem_id,
       COUNT(*),
       SUM(CASE WHEN status = 'ACCEPTED' THEN 1 ELSE 0 END)
FROM submissions
WHERE status <> 'PENDING'
  AND admin_submission = FALSE
GROUP BY problem_id;
