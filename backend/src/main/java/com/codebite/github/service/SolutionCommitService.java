package com.codebite.github.service;

import com.codebite.config.GitHubAppProperties;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubFileExistsException;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubGateway;
import com.codebite.github.gateway.GitHubGatewayException;
import com.codebite.github.gateway.GitHubInstallationGoneException;
import com.codebite.github.gateway.NewFile;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.github.gateway.GitHubTransientException;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.Instant;
import java.util.Optional;
import java.util.function.Consumer;

/**
 * Turns an Accepted submission into a Solution Commit in the user's Solution Repository
 * (GLOSSARY.md).
 *
 * <p>Each attempt runs in three steps, and no database transaction is held open across the call to
 * GitHub:
 * <ol>
 *   <li>{@link #prepare}: find the user's ACTIVE GitHub Link and record a PENDING Solution Commit
 *       (or reuse the one a redelivered event already created). Nothing happens without a link,
 *       or when this submission is already COMMITTED to it.</li>
 *   <li>{@link #push}: add the file through the {@link GitHubGateway}, after the problem
 *       folder's README if this link has not committed to that folder yet.</li>
 *   <li>Record the outcome: COMMITTED with the sha and URL, or FAILED with the error, and count it
 *       in {@code codebite.solution.commits}. Transient GitHub errors are retried with doubling
 *       back-off ({@code app.github.commit-max-tries}, {@code commit-retry-backoff-ms}) first.</li>
 * </ol>
 */
@Service
public class SolutionCommitService {

    private static final Logger log = LoggerFactory.getLogger(SolutionCommitService.class);

    private final GitHubLinkRepository linkRepository;
    private final SolutionCommitRepository solutionCommitRepository;
    private final SubmissionRepository submissionRepository;
    private final GitHubGateway gitHub;
    private final GitHubAppProperties properties;
    private final TransactionTemplate tx;
    private final Counter committedCounter;
    private final Counter failedCounter;
    private final Counter brokenCounter;

    public SolutionCommitService(GitHubLinkRepository linkRepository,
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

    /** Commits Accepted submission {@code submissionId} if {@code userId} has an ACTIVE GitHub Link. */
    public void commitAccepted(Long userId, Long submissionId) {
        Optional<Attempt> attempt = tx.execute(status -> prepare(userId, submissionId));
        if (attempt == null || attempt.isEmpty()) {
            return;
        }
        push(attempt.get());
    }

    private Optional<Attempt> prepare(Long userId, Long submissionId) {
        Optional<GitHubLink> link = linkRepository.findByActiveUserId(userId)
                .filter(l -> l.getStatus() == GitHubLinkStatus.ACTIVE);
        if (link.isEmpty()) {
            return Optional.empty();
        }
        Optional<Submission> found = submissionRepository.findById(submissionId);
        if (found.isEmpty()) {
            log.warn("Submission {} not found; no Solution Commit for user {}", submissionId, userId);
            return Optional.empty();
        }
        Submission submission = found.get();
        Problem problem = submission.getProblem();
        Instant acceptedAt = submission.getCreatedAt();

        SolutionCommit solutionCommit = solutionCommitRepository
                .findBySubmissionIdAndGithubLinkId(submissionId, link.get().getId())
                .orElseGet(() -> solutionCommitRepository.saveAndFlush(new SolutionCommit(
                        submissionId, link.get().getId(),
                        SolutionLayout.solutionPath(problem, submission.getLanguage(), acceptedAt))));
        if (solutionCommit.getStatus() == SolutionCommitStatus.COMMITTED) {
            return Optional.empty();
        }

        GitHubLink l = link.get();
        GitHubAccount author = new GitHubAccount(l.getGithubAccountId(), l.getGithubLogin());
        NewFile solution = new NewFile(solutionCommit.getPath(), submission.getSourceCode(),
                SolutionLayout.commitMessage(problem, submission), author, acceptedAt);
        // README-first is decided from CodeBite's own records: no COMMITTED Solution Commit for
        // this problem through this link yet. If the README is already there anyway (an earlier
        // link to the same repository, or a failed attempt that got that far), GitHub refuses to
        // add it again and push() carries on.
        NewFile readme = solutionCommitRepository.existsForProblem(
                l.getId(), problem.getId(), SolutionCommitStatus.COMMITTED)
                ? null
                : new NewFile(SolutionLayout.readmePath(problem),
                        SolutionLayout.readme(problem, properties.getCodebiteBaseUrl()),
                        SolutionLayout.readmeMessage(problem), author, acceptedAt);
        return Optional.of(new Attempt(solutionCommit.getId(), l.getId(), l.getInstallationId(),
                l.getRepositoryFullName(), l.getDefaultBranch(), readme, solution,
                solutionCommit.getAttempts() > 0));
    }

    /**
     * Pushes the attempt, retrying transient GitHub errors with doubling back-off. Once the tries
     * run out, or on any other gateway error, the Solution Commit is FAILED; when the installation
     * or repository is gone, the GitHub Link also becomes BROKEN. Nothing is thrown.
     */
    private void push(Attempt attempt) {
        int maxTries = Math.max(1, properties.getCommitMaxTries());
        long backoffMs = properties.getCommitRetryBackoffMs();
        // True once a call adding the solution may have landed on GitHub with its response lost.
        boolean solutionMayHaveLanded = attempt.attemptedBefore();
        for (int tryNumber = 1; ; tryNumber++) {
            try {
                if (attempt.readme() != null) {
                    addUnlessPresent(attempt, attempt.readme());
                }
                CommittedFile commit;
                try {
                    commit = gitHub.addFile(attempt.installationId(), attempt.repositoryFullName(),
                            attempt.branch(), attempt.solution());
                } catch (GitHubTransientException e) {
                    solutionMayHaveLanded = true;
                    throw e;
                } catch (GitHubFileExistsException e) {
                    if (committedMeanwhile(attempt)) {
                        return;
                    }
                    if (!solutionMayHaveLanded) {
                        throw e;
                    }
                    commit = landedEarlier(attempt);
                }
                recordCommitted(attempt, commit);
                return;
            } catch (GitHubTransientException e) {
                if (!retryAfter(attempt, e, tryNumber, maxTries, backoffMs)) {
                    return;
                }
            } catch (GitHubInstallationGoneException e) {
                // Permanent: never retried. Later submissions are skipped until the user relinks.
                log.warn("GitHub Link {} is BROKEN: {}", attempt.linkId(), e.getMessage());
                markLinkBroken(attempt);
                record(attempt, sc -> sc.markFailed(e.getMessage()));
                brokenCounter.increment();
                return;
            } catch (GitHubGatewayException e) {
                recordFailed(attempt, e);
                return;
            }
            backoffMs *= 2;
        }
    }

    /**
     * Whether something else (an Import) COMMITTED this Solution Commit while this attempt was in
     * flight. Its record, with its sha and URL, stands.
     */
    private boolean committedMeanwhile(Attempt attempt) {
        Boolean committed = tx.execute(status -> solutionCommitRepository.findById(attempt.solutionCommitId())
                .map(sc -> sc.getStatus() == SolutionCommitStatus.COMMITTED)
                .orElse(false));
        if (Boolean.TRUE.equals(committed)) {
            log.info("Solution Commit {} was committed meanwhile (by an Import); keeping that record",
                    attempt.solutionCommitId());
            return true;
        }
        return false;
    }

    /**
     * The solution file is already there and an earlier call for it may have landed, so it did.
     * The sha was in the lost response; link to the file instead.
     */
    private CommittedFile landedEarlier(Attempt attempt) {
        log.info("Solution Commit {}: {} is already there from an earlier try; counting it as committed",
                attempt.solutionCommitId(), attempt.solution().path());
        return new CommittedFile(null, properties.getWebBaseUrl() + "/" + attempt.repositoryFullName()
                + "/blob/" + attempt.branch() + "/" + attempt.solution().path());
    }

    /** Waits before the next try, or records FAILED and returns false when tries have run out. */
    private boolean retryAfter(Attempt attempt, GitHubTransientException e, int tryNumber, int maxTries,
                               long backoffMs) {
        if (tryNumber >= maxTries) {
            recordFailed(attempt, e);
            return false;
        }
        log.info("Solution Commit {} try {}/{} failed ({}); retrying in {} ms",
                attempt.solutionCommitId(), tryNumber, maxTries, e.getMessage(), backoffMs);
        try {
            Thread.sleep(backoffMs);
            return true;
        } catch (InterruptedException interrupted) {
            Thread.currentThread().interrupt();
            recordFailed(attempt, e);
            return false;
        }
    }

    private void recordCommitted(Attempt attempt, CommittedFile commit) {
        record(attempt, sc -> sc.markCommitted(commit.sha(), commit.url(), Instant.now()));
        committedCounter.increment();
    }

    private void recordFailed(Attempt attempt, GitHubGatewayException e) {
        log.warn("Solution Commit {} failed: {}", attempt.solutionCommitId(), e.getMessage());
        record(attempt, sc -> sc.markFailed(e.getMessage()));
        failedCounter.increment();
    }

    private void addUnlessPresent(Attempt attempt, NewFile file) {
        try {
            gitHub.addFile(attempt.installationId(), attempt.repositoryFullName(), attempt.branch(), file);
        } catch (GitHubFileExistsException e) {
            log.debug("{} already present; left as it is", file.path());
        }
    }

    private void markLinkBroken(Attempt attempt) {
        tx.executeWithoutResult(status -> linkRepository.findById(attempt.linkId())
                .ifPresent(GitHubLink::markBroken));
    }

    /** Applies {@code outcome} unless the Solution Commit is already COMMITTED, which is final. */
    private void record(Attempt attempt, Consumer<SolutionCommit> outcome) {
        tx.executeWithoutResult(status -> solutionCommitRepository.findById(attempt.solutionCommitId())
                .filter(sc -> sc.getStatus() != SolutionCommitStatus.COMMITTED)
                .ifPresent(outcome));
    }

    /**
     * Everything one attempt needs, read before the transaction closes. {@code readme} is null
     * when the problem folder is already started. {@code attemptedBefore} is true when an earlier
     * delivery already tried this Solution Commit, so its solution file may be on GitHub already.
     */
    private record Attempt(Long solutionCommitId, Long linkId, long installationId, String repositoryFullName,
                           String branch, NewFile readme, NewFile solution, boolean attemptedBefore) {
    }
}
