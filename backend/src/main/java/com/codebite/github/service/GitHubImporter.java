package com.codebite.github.service;

import com.codebite.config.GitHubAppProperties;
import com.codebite.github.entity.GitHubImportState;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.gateway.BatchCommit;
import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubGateway;
import com.codebite.github.gateway.GitHubInstallationGoneException;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;

/**
 * Runs a started Import (GLOSSARY.md, ADR 0002): every Accepted submission made before the GitHub
 * Link was created and not yet COMMITTED through it becomes its own Solution Commit, dated at its
 * Accepted time, and all of them go up in one batch push. Same layout, README rule, message and
 * author as live Solution Commits.
 *
 * <p>Like live commits, no transaction is held across the call to GitHub: {@link #prepare} records
 * PENDING Solution Commits and builds the batch, the push runs, then the outcome is recorded. The
 * push is all-or-nothing, so the Import ends DONE or FAILED (and can be started again).
 */
@Service
public class GitHubImporter {

    private static final Logger log = LoggerFactory.getLogger(GitHubImporter.class);

    private final GitHubLinkRepository linkRepository;
    private final SolutionCommitRepository solutionCommitRepository;
    private final SubmissionRepository submissionRepository;
    private final GitHubGateway gitHub;
    private final GitHubAppProperties properties;
    private final TransactionTemplate tx;
    private final Counter committedCounter;
    private final Counter failedCounter;
    private final Counter brokenCounter;

    public GitHubImporter(GitHubLinkRepository linkRepository,
                          SolutionCommitRepository solutionCommitRepository,
                          SubmissionRepository submissionRepository,
                          GitHubGateway gitHub,
                          GitHubAppProperties properties,
                          PlatformTransactionManager transactionManager,
                          MeterRegistry meterRegistry) {
        this.linkRepository = linkRepository;
        this.solutionCommitRepository = solutionCommitRepository;
        this.submissionRepository = submissionRepository;
        this.gitHub = gitHub;
        this.properties = properties;
        this.tx = new TransactionTemplate(transactionManager);
        // Imported commits are Solution Commits too: the same counter as live ones, one count per
        // commit in the batch (the push is all-or-nothing, so they share an outcome).
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
     * Runs the Import of link {@code linkId} if it is RUNNING. Anything else (already DONE, a
     * redelivered request) is ignored, so running it twice is harmless.
     */
    public void run(Long linkId) {
        Optional<Batch> prepared = tx.execute(status -> prepare(linkId));
        if (prepared == null || prepared.isEmpty()) {
            return;
        }
        Batch batch = prepared.get();
        try {
            List<CommittedFile> pushed = gitHub.pushCommits(batch.installationId(), batch.repositoryFullName(),
                    batch.branch(), batch.commits());
            Instant now = Instant.now();
            tx.executeWithoutResult(status -> {
                for (int i = 0; i < batch.solutionCommitIds().size(); i++) {
                    CommittedFile commit = pushed.get(i);
                    solutionCommitRepository.findById(batch.solutionCommitIds().get(i))
                            .filter(sc -> sc.getStatus() != SolutionCommitStatus.COMMITTED)
                            .ifPresent(sc -> sc.markCommitted(commit.sha(), commit.url(), now));
                }
                linkRepository.findById(linkId).ifPresent(GitHubLink::finishImport);
            });
            committedCounter.increment(batch.commits().size());
            log.info("Import for link {} pushed {} Solution Commits", linkId, batch.commits().size());
        } catch (GitHubInstallationGoneException e) {
            // Same as a live Solution Commit: the link is BROKEN until the user relinks, which
            // offers a fresh Import.
            log.warn("Import for link {} found the installation or repository gone: {}", linkId, e.getMessage());
            recordFailure(linkId, batch, e, GitHubLink::markBroken);
            brokenCounter.increment(batch.commits().size());
        } catch (RuntimeException e) {
            log.warn("Import for link {} failed: {}", linkId, e.getMessage());
            recordFailure(linkId, batch, e, link -> { });
            failedCounter.increment(batch.commits().size());
        }
    }

    private void recordFailure(Long linkId, Batch batch, RuntimeException e, Consumer<GitHubLink> alsoToLink) {
        tx.executeWithoutResult(status -> {
            batch.solutionCommitIds().forEach(id -> solutionCommitRepository.findById(id)
                    .filter(sc -> sc.getStatus() != SolutionCommitStatus.COMMITTED)
                    .ifPresent(sc -> sc.markFailed(e.getMessage())));
            linkRepository.findById(linkId).ifPresent(link -> {
                link.failImport();
                alsoToLink.accept(link);
            });
        });
    }

    /** Marks a RUNNING Import FAILED, e.g. when its request could not be published. */
    public void markFailed(Long linkId) {
        tx.executeWithoutResult(status -> linkRepository.findById(linkId).ifPresent(GitHubLink::failImport));
    }

    private Optional<Batch> prepare(Long linkId) {
        GitHubLink link = linkRepository.findById(linkId).orElse(null);
        if (link == null || link.getImportState() != GitHubImportState.RUNNING) {
            return Optional.empty();
        }
        if (link.getStatus() != GitHubLinkStatus.ACTIVE) {
            link.failImport();
            return Optional.empty();
        }
        List<Submission> submissions = submissionRepository.findImportable(
                link.getUserId(), link.getCreatedAt(), link.getId());
        if (submissions.isEmpty()) {
            link.finishImport();
            return Optional.empty();
        }

        GitHubAccount author = new GitHubAccount(link.getGithubAccountId(), link.getGithubLogin());
        // A problem folder gets its README once, from the first commit that touches it, unless this
        // link already COMMITTED to that folder (the same rule as live Solution Commits).
        Map<Long, Boolean> folderStarted = new HashMap<>();
        List<Long> solutionCommitIds = new ArrayList<>();
        List<BatchCommit> commits = new ArrayList<>();
        for (Submission submission : submissions) {
            Problem problem = submission.getProblem();
            Instant acceptedAt = submission.getCreatedAt();
            SolutionCommit solutionCommit = solutionCommitRepository
                    .findBySubmissionIdAndGithubLinkId(submission.getId(), link.getId())
                    .orElseGet(() -> solutionCommitRepository.saveAndFlush(new SolutionCommit(
                            submission.getId(), link.getId(),
                            SolutionLayout.solutionPath(problem, submission.getLanguage(), acceptedAt))));

            List<BatchCommit.File> files = new ArrayList<>();
            boolean started = folderStarted.computeIfAbsent(problem.getId(), id ->
                    solutionCommitRepository.existsForProblem(link.getId(), id, SolutionCommitStatus.COMMITTED));
            if (!started) {
                files.add(new BatchCommit.File(SolutionLayout.readmePath(problem),
                        SolutionLayout.readme(problem, properties.getCodebiteBaseUrl())));
                folderStarted.put(problem.getId(), true);
            }
            files.add(new BatchCommit.File(solutionCommit.getPath(), submission.getSourceCode()));
            commits.add(new BatchCommit(files, SolutionLayout.commitMessage(problem, submission), author, acceptedAt));
            solutionCommitIds.add(solutionCommit.getId());
        }
        return Optional.of(new Batch(link.getInstallationId(), link.getRepositoryFullName(),
                link.getDefaultBranch(), solutionCommitIds, commits));
    }

    /** Everything the push needs, read before the transaction closes; ids line up with commits. */
    private record Batch(long installationId, String repositoryFullName, String branch,
                         List<Long> solutionCommitIds, List<BatchCommit> commits) {
    }
}
