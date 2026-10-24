package com.codebite.github.service;

import com.codebite.config.GitHubAppProperties;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.gateway.BatchCommit;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

/**
 * The rules live Solution Commits and Imports share (GLOSSARY.md), so both write the same rows and
 * the same repository layout:
 * <ul>
 *   <li>one Solution Commit row per (submission, link), found or created with its file path, which
 *       never repeats another submission's path through the same link;</li>
 *   <li>a problem folder's README goes in the first commit that touches that folder through the
 *       link;</li>
 *   <li>a COMMITTED Solution Commit always has a link, falling back to the file's page;</li>
 *   <li>every outcome is counted in {@code codebite.solution.commits}, tagged committed, failed or
 *       broken.</li>
 * </ul>
 * Callers hold the transaction.
 */
@Component
class SolutionCommitRecorder {

    private final SolutionCommitRepository solutionCommitRepository;
    private final GitHubAppProperties properties;
    private final Counter committedCounter;
    private final Counter failedCounter;
    private final Counter brokenCounter;

    SolutionCommitRecorder(SolutionCommitRepository solutionCommitRepository, GitHubAppProperties properties,
                           MeterRegistry meterRegistry) {
        this.solutionCommitRepository = solutionCommitRepository;
        this.properties = properties;
        this.committedCounter = outcomeCounter(meterRegistry, "committed");
        this.failedCounter = outcomeCounter(meterRegistry, "failed");
        this.brokenCounter = outcomeCounter(meterRegistry, "broken");
    }

    private static Counter outcomeCounter(MeterRegistry registry, String outcome) {
        return Counter.builder("codebite.solution.commits")
                .description("Solution Commit attempts by outcome, after retries")
                .tag("outcome", outcome)
                .register(registry);
    }

    /**
     * The submission's Solution Commit through {@code link}, created PENDING if there is none yet.
     * A new row gets the plain path ({@link SolutionLayout#solutionPath}) unless another
     * submission's row for this link already has it (two Accepted in the same UTC second); then it
     * gets the disambiguated one ({@link SolutionLayout#disambiguatedPath}).
     */
    SolutionCommit findOrCreate(GitHubLink link, Submission submission) {
        return solutionCommitRepository.findBySubmissionIdAndGithubLinkId(submission.getId(), link.getId())
                .orElseGet(() -> {
                    String path = SolutionLayout.solutionPath(submission);
                    return solutionCommitRepository.saveAndFlush(
                            new SolutionCommit(submission.getId(), link.getId(), path));
                });
    }

    /**
     * Whether a commit for {@code problem} through {@code link} still has to add the folder's
     * README: true until this link has COMMITTED a solution to that folder. Decided from CodeBite's
     * own records; a README already in the repository anyway is left as it is.
     */
    boolean needsReadme(GitHubLink link, Problem problem) {
        return !solutionCommitRepository.existsForProblem(link.getId(), problem.getId(),
                SolutionCommitStatus.COMMITTED);
    }

    /** The problem folder's README file. */
    BatchCommit.File readme(Problem problem) {
        return new BatchCommit.File(SolutionLayout.readmePath(problem),
                SolutionLayout.readme(problem, properties.getCodebiteBaseUrl()));
    }

    /**
     * Where a COMMITTED Solution Commit links to: its commit page, or the file's page on the branch
     * when the commit is unknown (the file was already there, or the response was lost).
     */
    String commitUrl(String commitUrl, String repositoryFullName, String branch, String path) {
        if (commitUrl != null) {
            return commitUrl;
        }
        String base = properties.getWebBaseUrl();
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/" + repositoryFullName + "/blob/" + branch + "/" + path;
    }

    void countCommitted(int count) {
        committedCounter.increment(count);
    }

    void countFailed(int count) {
        failedCounter.increment(count);
    }

    void countBroken(int count) {
        brokenCounter.increment(count);
    }
}
