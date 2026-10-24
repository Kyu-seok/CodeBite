package com.codebite.github.service;

import com.codebite.common.exception.DuplicateResourceException;
import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.github.dto.GitHubLinkResponse;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.event.GitHubImportRequestedEvent;
import com.codebite.github.repository.GitHubLinkRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

/** Starting the one Import a GitHub Link offers (GLOSSARY.md). The work itself is {@link GitHubImporter}. */
@Service
public class GitHubImportService {

    private final GitHubLinkRepository linkRepository;
    private final GitHubImportPublisher publisher;
    private final TransactionTemplate tx;

    public GitHubImportService(GitHubLinkRepository linkRepository, GitHubImportPublisher publisher,
                               PlatformTransactionManager transactionManager) {
        this.linkRepository = linkRepository;
        this.publisher = publisher;
        this.tx = new TransactionTemplate(transactionManager);
    }

    /**
     * Starts the Import of the user's current link: allowed while its import state is AVAILABLE or
     * FAILED. The state becomes RUNNING and is committed before the request is published, so the
     * consumer always sees it.
     *
     * @return the link as it is now, with import state RUNNING
     * @throws ResourceNotFoundException  if the user has no GitHub Link
     * @throws DuplicateResourceException if the link is BROKEN, or its Import is RUNNING or DONE
     */
    public GitHubLinkResponse start(Long userId) {
        GitHubLink started = tx.execute(status -> {
            GitHubLink link = linkRepository.findCurrentByUserId(userId)
                    .orElseThrow(() -> new ResourceNotFoundException("error.github.link.notFound"));
            if (link.getStatus() != GitHubLinkStatus.ACTIVE) {
                throw new DuplicateResourceException("The GitHub Link is broken; link again before importing");
            }
            if (linkRepository.claimImport(link.getId()) == 0) {
                throw new DuplicateResourceException("The Import is already running or done");
            }
            return linkRepository.findById(link.getId()).orElseThrow();
        });
        GitHubLinkResponse response = GitHubLinkResponse.from(started);
        publisher.publish(new GitHubImportRequestedEvent(started.getId()));
        return response;
    }
}
