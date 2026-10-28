package com.codebite.github.service;

import com.codebite.config.GitHubAppProperties;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubFileExistsException;
import com.codebite.github.gateway.GitHubGateway;
import com.codebite.github.gateway.GitHubGatewayException;
import com.codebite.github.gateway.GitHubInstallationGoneException;
import com.codebite.github.gateway.GitHubTransientException;
import com.codebite.github.gateway.PushedCommit;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import org.hibernate.Hibernate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.List;
import java.util.Optional;

/**
 * Turns an Accepted submission into a Solution Commit in the user's Solution Repository
 * (GLOSSARY.md).
 *
 * <p>Each attempt runs in three steps, and no database transaction is held open across the call to
 * GitHub:
 * <ol>
 *   <li>{@link #prepare}: find the user's ACTIVE GitHub Link and the submission, then have the
 *       {@link SolutionCommitRecorder} plan the Solution Commit (a PENDING row, or the one a
 *       redelivered event already created). Nothing happens without a link, or when this
 *       submission is already COMMITTED to it.</li>
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
    private final SubmissionRepository submissionRepository;
    private final GitHubGateway gitHub;
    private final SolutionCommitRecorder recorder;
    private final GitHubAppProperties properties;
    private final TransactionTemplate tx;

    public SolutionCommitService(GitHubLinkRepository linkRepository,
                                 SubmissionRepository submissionRepository,
                                 GitHubGateway gitHub,
                                 SolutionCommitRecorder recorder,
                                 GitHubAppProperties properties,
                                 PlatformTransactionManager transactionManager) {
        this.linkRepository = linkRepository;
        this.submissionRepository = submissionRepository;
        this.gitHub = gitHub;
        this.recorder = recorder;
        this.properties = properties;
        this.tx = new TransactionTemplate(transactionManager);
    }

    /** Commits Accepted submission {@code submissionId} if {@code userId} has an ACTIVE GitHub Link. */
    public void commitAccepted(Long userId, Long submissionId) {
        Optional<Accepted> accepted = tx.execute(status -> prepare(userId, submissionId));
        if (accepted == null || accepted.isEmpty()) {
            return;
        }
        Plan plan = recorder.plan(accepted.get().link(), List.of(accepted.get().submission()));
        if (plan.isEmpty()) {
            return;
        }
        push(plan, plan.commits().get(0));
    }

    private Optional<Accepted> prepare(Long userId, Long submissionId) {
        Optional<GitHubLink> current = linkRepository.findCurrentByUserId(userId)
                .filter(link -> link.getStatus() == GitHubLinkStatus.ACTIVE);
        if (current.isEmpty()) {
            return Optional.empty();
        }
        Optional<Submission> found = submissionRepository.findById(submissionId);
        if (found.isEmpty()) {
            log.warn("Submission {} not found; no Solution Commit for user {}", submissionId, userId);
            return Optional.empty();
        }
        Submission submission = found.get();
        // The recorder plans in its own transaction, after this one, and lays the file out by problem.
        Hibernate.initialize(submission.getProblem());
        return Optional.of(new Accepted(current.get(), submission));
    }

    /**
     * Pushes the planned commit, retrying transient GitHub errors with doubling back-off. Once the
     * tries run out, or on any other gateway error, the Solution Commit is FAILED; when the
     * installation or repository is gone, the GitHub Link also becomes BROKEN. Nothing is thrown.
     *
     * <p>When GitHub reports the solution's file already there, there are three cases: an Import
     * COMMITTED it meanwhile (its record stands), an earlier try landed with its response lost
     * (counted as committed), or the path is taken by a file that is not this one's (the solution
     * moves to its own disambiguated file and is committed there straight away).
     */
    private void push(Plan plan, PlannedCommit pc) {
        int maxTries = Math.max(1, properties.getCommitMaxTries());
        long backoffMs = properties.getCommitRetryBackoffMs();
        // True once a call adding the solution may have landed on GitHub with its response lost.
        boolean solutionMayHaveLanded = pc.attemptedBefore();
        int tryNumber = 1;
        while (true) {
            try {
                recordCommitted(plan, pc, commitOnce(plan, pc));
                return;
            } catch (GitHubTransientException e) {
                solutionMayHaveLanded = true;
                if (!retryAfter(plan, pc, e, tryNumber, maxTries, backoffMs)) {
                    return;
                }
                tryNumber++;
                backoffMs *= 2;
            } catch (GitHubFileExistsException e) {
                if (committedMeanwhile(pc)) {
                    return;
                }
                if (solutionMayHaveLanded) {
                    recordCommitted(plan, pc, landedEarlier(pc));
                    return;
                }
                if (pc.disambiguated()) {
                    recordFailed(plan, pc, e);
                    return;
                }
                pc = moveToOwnFile(pc);
            } catch (GitHubInstallationGoneException e) {
                // Permanent: never retried. The recorder marks the link BROKEN with the row, so
                // later submissions are skipped until the user relinks.
                log.warn("GitHub Link {} is BROKEN: {}", plan.linkId(), e.getMessage());
                recorder.record(plan, List.of(pc), new Outcome.Broken(e));
                return;
            } catch (GitHubGatewayException e) {
                recordFailed(plan, pc, e);
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
    private CommittedFile commitOnce(Plan plan, PlannedCommit pc) {
        if (!pc.hasReadme()) {
            return gitHub.addFile(plan.installationId(), plan.repositoryFullName(), plan.branch(),
                    pc.asSingleFile());
        }
        PushedCommit pushed = gitHub.pushCommits(plan.installationId(), plan.repositoryFullName(),
                plan.branch(), List.of(pc.commit())).get(0);
        if (!pushed.added(pc.solutionPath())) {
            // The solution's path was already on the branch; at most the README went up.
            throw new GitHubFileExistsException(plan.repositoryFullName() + " already has " + pc.solutionPath());
        }
        return new CommittedFile(pushed.sha(), pushed.url());
    }

    /**
     * Moves the Solution Commit to its disambiguated path ({@link SolutionLayout#disambiguatedPath})
     * because its plain path is taken on GitHub by a file that is not its own.
     */
    private PlannedCommit moveToOwnFile(PlannedCommit pc) {
        String path = pc.disambiguatedPath();
        log.info("Solution Commit {}: {} is taken; committing to {} instead",
                pc.solutionCommitId(), pc.solutionPath(), path);
        recorder.moveTo(pc.solutionCommitId(), path);
        // The README needs no second try: the push found the plain path taken, so the folder exists.
        return pc.movedTo(path);
    }

    /**
     * Whether something else (an Import) COMMITTED this Solution Commit while this attempt was in
     * flight. Its record, with its sha and URL, stands.
     */
    private boolean committedMeanwhile(PlannedCommit pc) {
        if (recorder.isCommitted(pc.solutionCommitId())) {
            log.info("Solution Commit {} was committed meanwhile (by an Import); keeping that record",
                    pc.solutionCommitId());
            return true;
        }
        return false;
    }

    /**
     * The solution file is already there and an earlier call for it may have landed, so it did.
     * The sha was in the lost response; the recorder links to the file at the row's path instead.
     */
    private CommittedFile landedEarlier(PlannedCommit pc) {
        log.info("Solution Commit {}: {} is already there from an earlier try; counting it as committed",
                pc.solutionCommitId(), pc.solutionPath());
        return new CommittedFile(null, null);
    }

    /** Waits before the next try, or records FAILED and returns false when tries have run out. */
    private boolean retryAfter(Plan plan, PlannedCommit pc, GitHubTransientException e, int tryNumber,
                               int maxTries, long backoffMs) {
        if (tryNumber >= maxTries) {
            recordFailed(plan, pc, e);
            return false;
        }
        log.info("Solution Commit {} try {}/{} failed ({}); retrying in {} ms",
                pc.solutionCommitId(), tryNumber, maxTries, e.getMessage(), backoffMs);
        try {
            Thread.sleep(backoffMs);
            return true;
        } catch (InterruptedException interrupted) {
            Thread.currentThread().interrupt();
            recordFailed(plan, pc, e);
            return false;
        }
    }

    private void recordCommitted(Plan plan, PlannedCommit pc, CommittedFile commit) {
        recorder.record(plan, List.of(pc), new Outcome.Committed(List.of(commit)));
    }

    private void recordFailed(Plan plan, PlannedCommit pc, GitHubGatewayException e) {
        log.warn("Solution Commit {} failed: {}", pc.solutionCommitId(), e.getMessage());
        recorder.record(plan, List.of(pc), new Outcome.Failed(e));
    }

    /** An ACTIVE link and the Accepted submission to commit through it, problem loaded. */
    private record Accepted(GitHubLink link, Submission submission) {
    }
}
