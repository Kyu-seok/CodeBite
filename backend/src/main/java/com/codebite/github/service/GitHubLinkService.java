package com.codebite.github.service;

import com.codebite.common.exception.UnsupportedValueException;
import com.codebite.config.GitHubAppProperties;
import com.codebite.github.dto.GitHubInstallUrlResponse;
import com.codebite.github.dto.GitHubLinkCallbackRequest;
import com.codebite.github.dto.GitHubLinkCallbackResponse;
import com.codebite.github.dto.GitHubLinkResponse;
import com.codebite.github.dto.GitHubRepositoryChoiceRequest;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubAppNotConfiguredException;
import com.codebite.github.gateway.GitHubGateway;
import com.codebite.github.gateway.GitHubInstallationGoneException;
import com.codebite.github.gateway.GitHubInstallationNotAccessibleException;
import com.codebite.github.gateway.GitHubRepo;
import com.codebite.github.gateway.ResolvedInstallation;
import com.codebite.github.repository.GitHubLinkRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

/** Creating and reading a user's GitHub Link (GLOSSARY.md, ADR 0003). */
@Service
public class GitHubLinkService {

    private static final Logger log = LoggerFactory.getLogger(GitHubLinkService.class);

    private final GitHubLinkRepository linkRepository;
    private final GitHubGateway gitHub;
    private final GitHubLinkStateService stateService;
    private final GitHubAppProperties properties;
    private final TransactionTemplate tx;

    public GitHubLinkService(GitHubLinkRepository linkRepository, GitHubGateway gitHub,
                             GitHubLinkStateService stateService, GitHubAppProperties properties,
                             PlatformTransactionManager transactionManager) {
        this.linkRepository = linkRepository;
        this.gitHub = gitHub;
        this.stateService = stateService;
        this.properties = properties;
        this.tx = new TransactionTemplate(transactionManager);
    }

    /**
     * The user's current GitHub Link, or empty. An ACTIVE link is returned without calling GitHub.
     * A BROKEN link is checked first: if GitHub can reach its repository again it is recovered to
     * ACTIVE, otherwise it stays BROKEN. When GitHub cannot answer, it is returned unchanged.
     * No transaction is held open across the call to GitHub.
     */
    public Optional<GitHubLinkResponse> getLink(Long userId) {
        Optional<GitHubLink> current = linkRepository.findCurrentByUserId(userId);
        if (current.isPresent() && current.get().getStatus() == GitHubLinkStatus.BROKEN
                && reachable(current.get())) {
            Long id = current.get().getId();
            current = tx.execute(status -> linkRepository.findById(id).map(link -> {
                link.recover();
                return link;
            }));
        }
        return current.map(GitHubLinkResponse::from);
    }

    private boolean reachable(GitHubLink link) {
        try {
            return gitHub.isRepositoryReachable(link.getInstallationId(), link.getRepositoryId());
        } catch (RuntimeException e) {
            log.warn("Could not check GitHub Link {}; left BROKEN: {}", link.getId(), e.getMessage());
            return false;
        }
    }

    public GitHubInstallUrlResponse installUrl(Long userId) {
        if (!properties.isConfigured()) {
            throw new GitHubAppNotConfiguredException();
        }
        String url = UriComponentsBuilder.fromUriString(properties.resolvedInstallUrl())
                .queryParam("state", stateService.issue(userId))
                .build()
                .toUriString();
        return new GitHubInstallUrlResponse(url);
    }

    /**
     * Finishes an App install. The state must be the one issued to this user, and GitHub must
     * confirm the authorising account can access the installation. With exactly one granted
     * repository that repository becomes the Solution Repository, replacing any current link
     * (relinking offers Import again). Otherwise nothing is linked and the granted repositories
     * are returned.
     */
    @Transactional
    public GitHubLinkCallbackResponse completeInstall(Long userId, GitHubLinkCallbackRequest request) {
        stateService.verify(request.state(), userId);
        ResolvedInstallation installation = gitHub.resolveInstallCallback(request.code(), request.installationId());
        if (installation.repositories().size() != 1) {
            return GitHubLinkCallbackResponse.choose(installation.repositories(),
                    stateService.issueSelection(userId, installation.account(), installation.installationId()));
        }
        GitHubLink link = link(userId, installation.account(), installation.installationId(),
                installation.repositories().get(0));
        return GitHubLinkCallbackResponse.linked(GitHubLinkResponse.from(link));
    }

    /**
     * Links the repository the user chose after an install granted several. The account and
     * installation come from the signed selection token, never from the client, and the choice must
     * be one the installation grants right now.
     */
    @Transactional
    public GitHubLinkResponse chooseRepository(Long userId, GitHubRepositoryChoiceRequest request) {
        GitHubLinkStateService.Selection selection = stateService.verifySelection(request.selectionToken(), userId);
        List<GitHubRepo> granted;
        try {
            granted = gitHub.listInstallationRepositories(selection.installationId());
        } catch (GitHubInstallationGoneException e) {
            throw new GitHubInstallationNotAccessibleException(e.getMessage());
        }
        GitHubRepo repo = granted.stream()
                .filter(r -> r.id() == request.repositoryId())
                .findFirst()
                .orElseThrow(() -> new UnsupportedValueException("error.github.repositoryNotGranted"));
        return GitHubLinkResponse.from(link(userId, selection.account(), selection.installationId(), repo));
    }

    /**
     * Stops future Solution Commits. The link row is kept as UNLINKED so past Solution Commits
     * keep their link, and the Solution Repository is left exactly as it is: GitHub is not called.
     * Without a current link this does nothing.
     */
    @Transactional
    public void unlink(Long userId) {
        linkRepository.findCurrentByUserId(userId).ifPresent(current -> current.unlink(Instant.now()));
    }

    private GitHubLink link(Long userId, GitHubAccount account, long installationId, GitHubRepo repo) {
        linkRepository.findCurrentByUserId(userId).ifPresent(current -> {
            current.unlink(Instant.now());
            // Flush before the insert: Hibernate orders inserts first, which would trip the
            // one-current-link constraint.
            linkRepository.saveAndFlush(current);
        });
        return linkRepository.save(new GitHubLink(userId, account.id(), account.login(), installationId,
                repo.id(), repo.fullName(), repo.defaultBranch(), repo.isPrivate()));
    }
}
