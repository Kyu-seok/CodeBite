package com.codebite.github.service;

import com.codebite.config.GitHubAppProperties;
import com.codebite.github.dto.GitHubInstallUrlResponse;
import com.codebite.github.dto.GitHubLinkCallbackRequest;
import com.codebite.github.dto.GitHubLinkCallbackResponse;
import com.codebite.github.dto.GitHubLinkResponse;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubAppNotConfiguredException;
import com.codebite.github.gateway.GitHubGateway;
import com.codebite.github.gateway.GitHubRepo;
import com.codebite.github.gateway.ResolvedInstallation;
import com.codebite.github.repository.GitHubLinkRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.util.UriComponentsBuilder;

import java.time.Instant;
import java.util.Optional;

/** Creating and reading a user's GitHub Link (GLOSSARY.md, ADR 0003). */
@Service
public class GitHubLinkService {

    private final GitHubLinkRepository linkRepository;
    private final GitHubGateway gitHub;
    private final GitHubLinkStateService stateService;
    private final GitHubAppProperties properties;

    public GitHubLinkService(GitHubLinkRepository linkRepository, GitHubGateway gitHub,
                             GitHubLinkStateService stateService, GitHubAppProperties properties) {
        this.linkRepository = linkRepository;
        this.gitHub = gitHub;
        this.stateService = stateService;
        this.properties = properties;
    }

    @Transactional(readOnly = true)
    public Optional<GitHubLinkResponse> getLink(Long userId) {
        return linkRepository.findByActiveUserId(userId).map(GitHubLinkResponse::from);
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
            return GitHubLinkCallbackResponse.choose(installation.repositories());
        }
        GitHubLink link = link(userId, installation.account(), installation.installationId(),
                installation.repositories().get(0));
        return GitHubLinkCallbackResponse.linked(GitHubLinkResponse.from(link));
    }

    private GitHubLink link(Long userId, GitHubAccount account, long installationId, GitHubRepo repo) {
        linkRepository.findByActiveUserId(userId).ifPresent(current -> {
            current.unlink(Instant.now());
            // Flush before the insert: Hibernate orders inserts first, which would trip the
            // one-current-link constraint.
            linkRepository.saveAndFlush(current);
        });
        return linkRepository.save(new GitHubLink(userId, account.id(), account.login(), installationId,
                repo.id(), repo.fullName(), repo.defaultBranch(), repo.isPrivate()));
    }
}
