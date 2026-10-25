package com.codebite.github.service;

import com.codebite.common.exception.UnsupportedValueException;
import com.codebite.config.GitHubAppProperties;
import com.codebite.github.dto.GitHubLinkPagesResponse;
import com.codebite.github.dto.GitHubLinkCallbackRequest;
import com.codebite.github.dto.GitHubLinkResponse;
import com.codebite.github.entity.GitHubLink;
import com.codebite.github.entity.GitHubLinkStatus;
import com.codebite.github.gateway.GitHubAccount;
import com.codebite.github.gateway.GitHubAppNotConfiguredException;
import com.codebite.github.gateway.GitHubGateway;
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
import java.util.regex.Pattern;

/** Creating and reading a user's GitHub Link (GLOSSARY.md, ADR 0003). */
@Service
public class GitHubLinkService {

    private static final Logger log = LoggerFactory.getLogger(GitHubLinkService.class);
    /** What GitHub accepts as a repository name, apart from "." and "..". */
    private static final Pattern REPOSITORY_NAME = Pattern.compile("[A-Za-z0-9._-]{1,100}");

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

    /**
     * The two GitHub pages of linking the Solution Repository named {@code repositoryName}: one to
     * create it in the user's own account, prefilled from the template, and one to install the
     * App, whose state remembers the name for {@link #completeInstall}.
     */
    public GitHubLinkPagesResponse linkPages(Long userId, String repositoryName, String visibility) {
        if (!properties.isConfigured()) {
            throw new GitHubAppNotConfiguredException();
        }
        if (!REPOSITORY_NAME.matcher(repositoryName).matches() || repositoryName.matches("\\.{1,2}")) {
            throw new UnsupportedValueException("error.github.link.repositoryNameInvalid");
        }
        if (!visibility.equals("public") && !visibility.equals("private")) {
            throw new UnsupportedValueException("error.github.link.visibilityInvalid");
        }
        String installUrl = UriComponentsBuilder.fromUriString(properties.resolvedInstallUrl())
                .queryParam("state", stateService.issue(userId, repositoryName))
                .build()
                .toUriString();
        UriComponentsBuilder create = UriComponentsBuilder.fromUriString(properties.getWebBaseUrl())
                .path("/new")
                .queryParam("owner", "@me");
        if (properties.hasSolutionRepositoryTemplate()) {
            create.queryParam("template_owner", properties.solutionRepositoryTemplateOwner())
                    .queryParam("template_name", properties.solutionRepositoryTemplateName());
        }
        String createRepositoryUrl = create.queryParam("name", repositoryName)
                .queryParam("visibility", visibility)
                .queryParam("description", "Solutions to CodeBite problems")
                .encode()
                .build()
                .toUriString();
        return new GitHubLinkPagesResponse(installUrl, createRepositoryUrl);
    }

    /**
     * Finishes an App install. The state must be the one issued to this user, and GitHub must
     * confirm the authorising account can access the installation. The granted repository named as
     * the user chose in CodeBite becomes the Solution Repository, or the only granted one when none
     * has that name (it was renamed on GitHub's page). It replaces any current link (relinking
     * offers Import again).
     *
     * @throws UnsupportedValueException when several repositories were granted and none has the name
     */
    @Transactional
    public GitHubLinkResponse completeInstall(Long userId, GitHubLinkCallbackRequest request) {
        String repositoryName = stateService.verify(request.state(), userId);
        ResolvedInstallation installation = gitHub.resolveInstallCallback(request.code(), request.installationId());
        List<GitHubRepo> granted = installation.repositories();
        GitHubRepo repo = granted.stream()
                .filter(r -> r.name().equalsIgnoreCase(repositoryName))
                .findFirst()
                .or(() -> granted.size() == 1 ? Optional.of(granted.get(0)) : Optional.empty())
                .orElseThrow(() -> new UnsupportedValueException("error.github.repositoryNotGranted", repositoryName));
        return GitHubLinkResponse.from(link(userId, installation.account(), installation.installationId(), repo));
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
