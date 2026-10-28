package com.codebite.github.service;

import com.codebite.github.entity.GitHubImportState;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.gateway.CommittedFile;
import com.codebite.github.gateway.GitHubGateway;
import com.codebite.github.gateway.PushedCommit;
import com.codebite.github.repository.GitHubLinkRepository;
import com.codebite.github.repository.SolutionCommitRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.List;
import java.util.Optional;

/**
 * Runs a started Import (GLOSSARY.md, ADR 0002): every Accepted submission made before the GitHub
 * Link was created and not yet COMMITTED through it becomes its own Solution Commit, dated at its
 * Accepted time, and all of them go up in one batch push. Same layout, README rule, message and
 * author as live Solution Commits, through the same {@link SolutionCommitRecorder}.
 *
 * <p>Like live commits, no transaction is held across the call to GitHub: {@link #prepare} checks
 * the link and finds the submissions, the recorder plans the Solution Commits, the push runs, then
 * the recorder records the outcome together with the Import's DONE or FAILED. The push is
 * all-or-nothing, so the Import ends DONE or FAILED (and can be started again).
 */
@Service
public class GitHubImporter {

    private static final Logger log = LoggerFactory.getLogger(GitHubImporter.class);

    private final GitHubLinkRepository linkRepository;
    private final SolutionCommitRepository solutionCommitRepository;
    private final SubmissionRepository submissionRepository;
    private final GitHubGateway gitHub;
    private final SolutionCommitRecorder recorder;
    private final TransactionTemplate tx;

    public GitHubImporter(GitHubLinkRepository linkRepository,
                          SolutionCommitRepository solutionCommitRepository,
                          SubmissionRepository submissionRepository,
                          GitHubGateway gitHub,
                          SolutionCommitRecorder recorder,
                          PlatformTransactionManager transactionManager) {
        this.linkRepository = linkRepository;
        this.solutionCommitRepository = solutionCommitRepository;
        this.submissionRepository = submissionRepository;
        this.gitHub = gitHub;
        this.recorder = recorder;
        this.tx = new TransactionTemplate(transactionManager);
    }

    /**
     * Runs the Import of link {@code linkId} if it is RUNNING. Anything else (already DONE, a
     * redelivered request) is ignored, so running it twice is harmless.
     */
    public void run(Long linkId) {
        Optional<Importable> prepared = tx.execute(status -> prepare(linkId));
        if (prepared == null || prepared.isEmpty()) {
            return;
        }
        Plan plan = recorder.plan(prepared.get().link(), prepared.get().submissions());
        if (plan.isEmpty()) {
            // Everything was COMMITTED live between the two transactions; nothing to push.
            recorder.record(plan, plan.commits(), new Outcome.Committed(List.of()), GitHubLink::finishImport);
            return;
        }
        try {
            List<PushedCommit> pushed = gitHub.pushCommits(plan.installationId(), plan.repositoryFullName(),
                    plan.branch(), plan.commits().stream().map(PlannedCommit::commit).toList());
            // A commit with nothing left to add (the file was already there) has no sha or URL;
            // the recorder then links the row to the file, so COMMITTED always has a link.
            recorder.record(plan, plan.commits(), new Outcome.Committed(pushed.stream()
                    .map(p -> new CommittedFile(p.sha(), p.url())).toList()), GitHubLink::finishImport);
            log.info("Import for link {} pushed {} Solution Commits", linkId, plan.commits().size());
        } catch (RuntimeException e) {
            // A gone installation or repository is Broken: the link is BROKEN until the user
            // relinks, which offers a fresh Import. Anything else leaves the Import FAILED to retry.
            log.warn("Import for link {} failed: {}", linkId, e.getMessage());
            recorder.record(plan, plan.commits(), Outcome.failure(e), GitHubLink::failImport);
        }
    }

    /** Marks a RUNNING Import FAILED, e.g. when its request could not be published. */
    public void markFailed(Long linkId) {
        tx.executeWithoutResult(status -> linkRepository.findById(linkId).ifPresent(GitHubLink::failImport));
    }

    private Optional<Importable> prepare(Long linkId) {
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
        return Optional.of(new Importable(link, submissions));
    }

    /** The RUNNING link and what its Import covers, problems fetched, read before the transaction closes. */
    private record Importable(GitHubLink link, List<Submission> submissions) {
    }
}
