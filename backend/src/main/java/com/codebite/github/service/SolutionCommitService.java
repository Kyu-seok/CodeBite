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
import com.codebite.github.gateway.NewFile;
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
 *   <li>Record the outcome: COMMITTED with the sha and URL, or FAILED with the error.</li>
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

    public SolutionCommitService(GitHubLinkRepository linkRepository,
                                 SolutionCommitRepository solutionCommitRepository,
                                 SubmissionRepository submissionRepository,
                                 GitHubGateway gitHub,
                                 GitHubAppProperties properties,
                                 PlatformTransactionManager transactionManager) {
        this.linkRepository = linkRepository;
        this.solutionCommitRepository = solutionCommitRepository;
        this.submissionRepository = submissionRepository;
        this.gitHub = gitHub;
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
        return Optional.of(new Attempt(solutionCommit.getId(), l.getInstallationId(),
                l.getRepositoryFullName(), l.getDefaultBranch(), readme, solution));
    }

    private void push(Attempt attempt) {
        try {
            if (attempt.readme() != null) {
                addUnlessPresent(attempt, attempt.readme());
            }
            CommittedFile commit = gitHub.addFile(attempt.installationId(), attempt.repositoryFullName(),
                    attempt.branch(), attempt.solution());
            record(attempt, sc -> sc.markCommitted(commit.sha(), commit.url(), Instant.now()));
        } catch (GitHubGatewayException e) {
            log.warn("Solution Commit {} failed: {}", attempt.solutionCommitId(), e.getMessage());
            record(attempt, sc -> sc.markFailed(e.getMessage()));
        }
    }

    private void addUnlessPresent(Attempt attempt, NewFile file) {
        try {
            gitHub.addFile(attempt.installationId(), attempt.repositoryFullName(), attempt.branch(), file);
        } catch (GitHubFileExistsException e) {
            log.debug("{} already present; left as it is", file.path());
        }
    }

    private void record(Attempt attempt, Consumer<SolutionCommit> outcome) {
        tx.executeWithoutResult(status -> solutionCommitRepository.findById(attempt.solutionCommitId())
                .ifPresent(outcome));
    }

    /**
     * Everything one attempt needs, read before the transaction closes. {@code readme} is null
     * when the problem folder is already started.
     */
    private record Attempt(Long solutionCommitId, long installationId, String repositoryFullName,
                           String branch, NewFile readme, NewFile solution) {
    }
}
