package com.codebite.github.service;

import com.codebite.config.GitHubAppProperties;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.entity.SolutionCommit;
import com.codebite.github.entity.SolutionCommitStatus;
import com.codebite.github.gateway.BatchCommit;
import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubFileExistsException;
import com.codebite.github.gateway.GitHubGateway;
import com.codebite.github.gateway.GitHubGatewayException;
import com.codebite.github.gateway.GitHubInstallationGoneException;
import com.codebite.github.gateway.GitHubTransientException;
import com.codebite.github.gateway.NewFile;
import com.codebite.github.gateway.PushedCommit;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.Instant;
import java.util.List;
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
 *   <li>{@link #push}: add the file through the {@link GitHubGateway}, together with the problem
 *       folder's README in one commit if this link has not committed to that folder yet.</li>
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
    private final SolutionCommitRecorder recorder;
    private final GitHubAppProperties properties;
    private final TransactionTemplate tx;

    public SolutionCommitService(GitHubLinkRepository linkRepository,
                                 SolutionCommitRepository solutionCommitRepository,
                                 SubmissionRepository submissionRepository,
                                 GitHubGateway gitHub,
                                 SolutionCommitRecorder recorder,
                                 GitHubAppProperties properties,
                                 PlatformTransactionManager transactionManager) {
        this.linkRepository = linkRepository;
        this.solutionCommitRepository = solutionCommitRepository;
        this.submissionRepository = submissionRepository;
        this.gitHub = gitHub;
        this.recorder = recorder;
        this.properties = properties;
        this.tx = new TransactionTemplate(transactionManager);
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
        Optional<GitHubLink> current = linkRepository.findCurrentByUserId(userId)
                .filter(link -> link.getStatus() == GitHubLinkStatus.ACTIVE);
        if (current.isEmpty()) {
            return Optional.empty();
        }
        GitHubLink link = current.get();
        Optional<Submission> found = submissionRepository.findById(submissionId);
        if (found.isEmpty()) {
            log.warn("Submission {} not found; no Solution Commit for user {}", submissionId, userId);
            return Optional.empty();
        }
        Submission submission = found.get();
        Problem problem = submission.getProblem();
        Instant acceptedAt = submission.getCreatedAt();

        SolutionCommit solutionCommit = recorder.findOrCreate(link, submission);
        if (solutionCommit.getStatus() == SolutionCommitStatus.COMMITTED) {
            return Optional.empty();
        }

        GitHubAccount author = GitHubAccount.of(link);
        NewFile solution = new NewFile(solutionCommit.getPath(), submission.getSourceCode(),
                SolutionLayout.commitMessage(problem, submission), author, acceptedAt);
        // The folder's README rides in its first Solution Commit through this link. If it is
        // already there anyway (an earlier link to the same repository), it is left as it is.
        BatchCommit.File readme = recorder.needsReadme(link, problem) ? recorder.readme(problem) : null;
        return Optional.of(new Attempt(solutionCommit.getId(), link.getId(), link.getInstallationId(),
                link.getRepositoryFullName(), link.getDefaultBranch(), readme, solution,
                SolutionLayout.disambiguatedPath(submission), solutionCommit.getAttempts() > 0));
    }

    /**
     * Pushes the attempt, retrying transient GitHub errors with doubling back-off. Once the tries
     * run out, or on any other gateway error, the Solution Commit is FAILED; when the installation
     * or repository is gone, the GitHub Link also becomes BROKEN. Nothing is thrown.
     *
     * <p>When GitHub reports the solution's file already there, there are three cases: an Import
     * COMMITTED it meanwhile (its record stands), an earlier try landed with its response lost
     * (counted as committed), or the path is taken by a file that is not this one's (the solution
     * moves to its own disambiguated file and is committed there straight away).
     */
    private void push(Attempt attempt) {
        int maxTries = Math.max(1, properties.getCommitMaxTries());
        long backoffMs = properties.getCommitRetryBackoffMs();
        // True once a call adding the solution may have landed on GitHub with its response lost.
        boolean solutionMayHaveLanded = attempt.attemptedBefore();
        int tryNumber = 1;
        while (true) {
            try {
                recordCommitted(attempt, commitOnce(attempt));
                return;
            } catch (GitHubTransientException e) {
                solutionMayHaveLanded = true;
                if (!retryAfter(attempt, e, tryNumber, maxTries, backoffMs)) {
                    return;
                }
                tryNumber++;
                backoffMs *= 2;
            } catch (GitHubFileExistsException e) {
                if (committedMeanwhile(attempt)) {
                    return;
                }
                if (solutionMayHaveLanded) {
                    recordCommitted(attempt, landedEarlier(attempt));
                    return;
                }
                if (attempt.disambiguated()) {
                    recordFailed(attempt, e);
                    return;
                }
                attempt = moveToOwnFile(attempt);
            } catch (GitHubInstallationGoneException e) {
                // Permanent: never retried. Later submissions are skipped until the user relinks.
                log.warn("GitHub Link {} is BROKEN: {}", attempt.linkId(), e.getMessage());
                markLinkBroken(attempt);
                record(attempt, sc -> sc.markFailed(e.getMessage()));
                recorder.countBroken(1);
                return;
            } catch (GitHubGatewayException e) {
                recordFailed(attempt, e);
                return;
            }
        }
    }

    /**
     * One call to GitHub. A folder's first Solution Commit adds its README and the solution
     * together, as one commit through a one-commit batch push (the Contents API adds one file per
     * commit), so a first solve is a single contribution, just as in an Import. Otherwise the
     * solution is added alone through the Contents API.
     *
     * @throws GitHubFileExistsException if the solution's path is already there
     */
    private CommittedFile commitOnce(Attempt attempt) {
        NewFile solution = attempt.solution();
        if (attempt.readme() == null) {
            return gitHub.addFile(attempt.installationId(), attempt.repositoryFullName(), attempt.branch(),
                    solution);
        }
        BatchCommit commit = new BatchCommit(
                List.of(attempt.readme(), new BatchCommit.File(solution.path(), solution.content())),
                solution.message(), solution.author(), solution.authorDate());
        PushedCommit pushed = gitHub.pushCommits(attempt.installationId(), attempt.repositoryFullName(),
                attempt.branch(), List.of(commit)).get(0);
        if (!pushed.added(solution.path())) {
            // The solution's path was already on the branch; at most the README went up.
            throw new GitHubFileExistsException(attempt.repositoryFullName() + " already has " + solution.path());
        }
        return new CommittedFile(pushed.sha(), pushed.url());
    }

    /**
     * Moves the Solution Commit to its disambiguated path ({@link SolutionLayout#disambiguatedPath})
     * because its plain path is taken on GitHub by a file that is not its own.
     */
    private Attempt moveToOwnFile(Attempt attempt) {
        String path = attempt.disambiguatedPath();
        log.info("Solution Commit {}: {} is taken; committing to {} instead",
                attempt.solutionCommitId(), attempt.solution().path(), path);
        tx.executeWithoutResult(status -> solutionCommitRepository.findById(attempt.solutionCommitId())
                .ifPresent(sc -> sc.moveTo(path)));
        NewFile solution = attempt.solution();
        // The README needs no second try: the push found the plain path taken, so the folder exists.
        return attempt.withSolution(new NewFile(path, solution.content(), solution.message(), solution.author(),
                solution.authorDate()));
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
        return new CommittedFile(null, recorder.commitUrl(null, attempt.repositoryFullName(), attempt.branch(),
                attempt.solution().path()));
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
        recorder.countCommitted(1);
    }

    private void recordFailed(Attempt attempt, GitHubGatewayException e) {
        log.warn("Solution Commit {} failed: {}", attempt.solutionCommitId(), e.getMessage());
        record(attempt, sc -> sc.markFailed(e.getMessage()));
        recorder.countFailed(1);
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
     * Everything one attempt needs, read before the transaction closes. {@code readme} is the
     * folder's README for its first Solution Commit, or null when the folder is already started. {@code attemptedBefore} is true when an earlier
     * delivery already tried this Solution Commit, so its solution file may be on GitHub already.
     */
    private record Attempt(Long solutionCommitId, Long linkId, long installationId, String repositoryFullName,
                           String branch, BatchCommit.File readme, NewFile solution, String disambiguatedPath,
                           boolean attemptedBefore) {

        boolean disambiguated() {
            return solution.path().equals(disambiguatedPath);
        }

        Attempt withSolution(NewFile newSolution) {
            return new Attempt(solutionCommitId, linkId, installationId, repositoryFullName, branch, null,
                    newSolution, disambiguatedPath, attemptedBefore);
        }
    }
}
