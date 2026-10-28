package com.codebite.github.service;

import com.codebite.config.GitHubAppProperties;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.gateway.BatchCommit;
import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.Instant;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.function.Consumer;

/**
 * The rules live Solution Commits and Imports share (GLOSSARY.md), owned here so both write the
 * same rows and the same repository layout:
 * <ul>
 *   <li>one Solution Commit row per (submission, link), found or created with its file path, which
 *       never repeats another submission's path through the same link (two Accepted in the same
 *       UTC second: the second gets {@link SolutionLayout#disambiguatedPath});</li>
 *   <li>a problem folder's README goes in the first commit that touches that folder through the
 *       link, decided from COMMITTED rows plus the plan being built;</li>
 *   <li>COMMITTED is final: a later outcome never touches a COMMITTED row;</li>
 *   <li>a COMMITTED Solution Commit always has a link, falling back to the file's page;</li>
 *   <li>every outcome is counted in {@code codebite.solution.commits}, tagged committed, failed or
 *       broken, once per Solution Commit (an Import counts its batch size).</li>
 * </ul>
 * {@link #plan} and {@link #record} each run in their own transaction, so no database transaction
 * is open across the GitHub call between them.
 */
@Component
class SolutionCommitRecorder {

    private final SolutionCommitRepository solutionCommitRepository;
    private final GitHubLinkRepository linkRepository;
    private final GitHubAppProperties properties;
    private final TransactionTemplate tx;
    private final Counter committedCounter;
    private final Counter failedCounter;
    private final Counter brokenCounter;

    SolutionCommitRecorder(SolutionCommitRepository solutionCommitRepository, GitHubLinkRepository linkRepository,
                           GitHubAppProperties properties, MeterRegistry meterRegistry,
                           PlatformTransactionManager transactionManager) {
        this.solutionCommitRepository = solutionCommitRepository;
        this.linkRepository = linkRepository;
        this.properties = properties;
        this.tx = new TransactionTemplate(transactionManager);
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
     * Plans one Solution Commit per submission through {@code link}, in its own transaction: each
     * gets its row (created PENDING if there is none yet). Submissions already COMMITTED through
     * the link are dropped. The problem folder's README is added to the first planned commit of
     * each folder not yet COMMITTED through the link. Commits come back in submission order.
     */
    Plan plan(GitHubLink link, List<Submission> submissions) {
        return tx.execute(status -> {
            GitHubAccount author = GitHubAccount.of(link);
            // Folders this plan has already given a README to, or checked and found started.
            Set<Long> foldersDecided = new HashSet<>();
            List<PlannedCommit> commits = new ArrayList<>();
            for (Submission submission : submissions) {
                SolutionCommit row = findOrCreate(link, submission);
                if (row.getStatus() == SolutionCommitStatus.COMMITTED) {
                    continue;
                }
                Problem problem = submission.getProblem();
                List<BatchCommit.File> files = new ArrayList<>();
                if (foldersDecided.add(problem.getId()) && needsReadme(link, problem)) {
                    files.add(readme(problem));
                }
                files.add(new BatchCommit.File(row.getPath(), submission.getSourceCode()));
                BatchCommit commit = new BatchCommit(files, SolutionLayout.commitMessage(problem, submission),
                        author, submission.getCreatedAt());
                commits.add(new PlannedCommit(row.getId(), commit, row.getPath(),
                        SolutionLayout.disambiguatedPath(submission), row.getAttempts() > 0));
            }
            return new Plan(link.getId(), link.getInstallationId(), link.getRepositoryFullName(),
                    link.getDefaultBranch(), commits);
        });
    }

    /** {@link #record(Plan, List, Outcome, Consumer)} with nothing else to do to the link. */
    void record(Plan plan, List<PlannedCommit> planned, Outcome outcome) {
        record(plan, planned, outcome, link -> { });
    }

    /**
     * Records {@code outcome} on the planned Solution Commits, in its own transaction, with
     * {@code linkEffect} applied to the GitHub Link in that same transaction. Rows already
     * COMMITTED are untouched. {@link Outcome.Committed}: entry {@code i} applies to
     * {@code planned.get(i)}; a null URL is replaced by the file's page on the branch, at the
     * row's current path. {@link Outcome.Broken} also marks the link BROKEN. Once the transaction
     * commits, {@code planned.size()} is counted under the outcome's tag.
     *
     * @throws IllegalArgumentException if a Committed outcome does not have one file per planned commit
     */
    void record(Plan plan, List<PlannedCommit> planned, Outcome outcome, Consumer<GitHubLink> linkEffect) {
        if (outcome instanceof Outcome.Committed committed && committed.files().size() != planned.size()) {
            throw new IllegalArgumentException("Committed outcome has " + committed.files().size()
                    + " files for " + planned.size() + " planned commits");
        }
        Instant now = Instant.now();
        tx.executeWithoutResult(status -> {
            for (int i = 0; i < planned.size(); i++) {
                int index = i;
                solutionCommitRepository.findById(planned.get(i).solutionCommitId())
                        .filter(sc -> sc.getStatus() != SolutionCommitStatus.COMMITTED)
                        .ifPresent(sc -> apply(sc, outcome, index, plan, now));
            }
            linkRepository.findById(plan.linkId()).ifPresent(link -> {
                if (outcome instanceof Outcome.Broken) {
                    link.markBroken();
                }
                linkEffect.accept(link);
            });
        });
        counterFor(outcome).increment(planned.size());
    }

    private void apply(SolutionCommit sc, Outcome outcome, int index, Plan plan, Instant now) {
        if (outcome instanceof Outcome.Committed committed) {
            CommittedFile file = committed.files().get(index);
            sc.markCommitted(file.sha(), commitUrl(file.url(), plan.repositoryFullName(), plan.branch(),
                    sc.getPath()), now);
        } else if (outcome instanceof Outcome.Failed failed) {
            sc.markFailed(failed.cause().getMessage());
        } else if (outcome instanceof Outcome.Broken broken) {
            sc.markFailed(broken.cause().getMessage());
        }
    }

    private Counter counterFor(Outcome outcome) {
        if (outcome instanceof Outcome.Committed) {
            return committedCounter;
        }
        return outcome instanceof Outcome.Broken ? brokenCounter : failedCounter;
    }

    /** Whether the Solution Commit is COMMITTED now, e.g. by an Import while a live push was in flight. */
    boolean isCommitted(Long solutionCommitId) {
        return Boolean.TRUE.equals(tx.execute(status -> solutionCommitRepository.findById(solutionCommitId)
                .map(sc -> sc.getStatus() == SolutionCommitStatus.COMMITTED)
                .orElse(false)));
    }

    /** Moves the Solution Commit to {@code ownPath} ({@link SolutionCommit#moveTo}), in its own transaction. */
    void moveTo(Long solutionCommitId, String ownPath) {
        tx.executeWithoutResult(status -> solutionCommitRepository.findById(solutionCommitId)
                .ifPresent(sc -> sc.moveTo(ownPath)));
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
                    if (solutionCommitRepository.existsByGithubLinkIdAndPath(link.getId(), path)) {
                        path = SolutionLayout.disambiguatedPath(submission);
                    }
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
