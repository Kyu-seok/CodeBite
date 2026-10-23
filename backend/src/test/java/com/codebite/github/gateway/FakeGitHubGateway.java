package com.codebite.github.gateway;

import java.time.Instant;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Supplier;

/**
 * In-memory stand-in for GitHub, registered as the primary {@link GitHubGateway} in tests.
 *
 * <p>It models GitHub's state, not CodeBite's rules: which authorization codes belong to which
 * account, which installations each account can access, and which repositories each installation
 * grants. Tests set that state up, drive CodeBite through its API, then assert on what reached
 * the fake.
 *
 * <p>Failures can be injected for any operation: {@link #failNext} queues one-shot errors and
 * {@link #failAlways} fails every call until {@link #reset}. The application context is shared
 * across tests, so call {@link #reset} in {@code @BeforeEach}.
 */
public class FakeGitHubGateway implements GitHubGateway {

    private final Map<String, GitHubAccount> accountsByCode = new HashMap<>();
    private final Map<Long, Set<Long>> installationsByAccount = new HashMap<>();
    private final Map<Long, List<GitHubRepo>> reposByInstallation = new HashMap<>();
    private final Deque<RuntimeException> nextFailures = new ArrayDeque<>();
    private final List<RecordedCommit> commits = new ArrayList<>();
    /** File contents by repository full name, then path. */
    private final Map<String, Map<String, String>> filesByRepo = new HashMap<>();
    private Supplier<? extends RuntimeException> alwaysFailure;

    /** A commit that reached the fake, in the order made. */
    public record RecordedCommit(long installationId, String repositoryFullName, String branch, String path,
                                 String content, String message, String authorName, String authorEmail,
                                 Instant authorDate, String sha) {
    }

    /** Forgets all GitHub state and injected failures. */
    public synchronized void reset() {
        accountsByCode.clear();
        installationsByAccount.clear();
        reposByInstallation.clear();
        commits.clear();
        filesByRepo.clear();
        nextFailures.clear();
        alwaysFailure = null;
    }

    /** GitHub will exchange {@code code} for {@code account}, which can access those installations. */
    public synchronized void authorize(String code, GitHubAccount account, long... accessibleInstallationIds) {
        accountsByCode.put(code, account);
        Set<Long> ids = installationsByAccount.computeIfAbsent(account.id(), k -> new HashSet<>());
        Arrays.stream(accessibleInstallationIds).forEach(ids::add);
    }

    /** Installation {@code installationId} exists and grants exactly these repositories. */
    public synchronized void install(long installationId, GitHubRepo... repositories) {
        reposByInstallation.put(installationId, List.of(repositories));
    }

    /** The next gateway calls throw these, in order, one per call. */
    public synchronized void failNext(RuntimeException... failures) {
        nextFailures.addAll(List.of(failures));
    }

    /** Every gateway call throws a fresh exception from {@code failure} until {@link #reset}. */
    public synchronized void failAlways(Supplier<? extends RuntimeException> failure) {
        this.alwaysFailure = failure;
    }

    @Override
    public synchronized ResolvedInstallation resolveInstallCallback(String authorizationCode, long installationId) {
        maybeFail();
        GitHubAccount account = accountsByCode.get(authorizationCode);
        if (account == null) {
            throw new GitHubInstallationNotAccessibleException("unknown authorization code");
        }
        boolean accessible = installationsByAccount.getOrDefault(account.id(), Set.of()).contains(installationId);
        if (!accessible || !reposByInstallation.containsKey(installationId)) {
            throw new GitHubInstallationNotAccessibleException(
                    "account " + account.id() + " cannot access installation " + installationId);
        }
        return new ResolvedInstallation(account, installationId, reposByInstallation.get(installationId));
    }

    @Override
    public synchronized CommittedFile addFile(long installationId, String repositoryFullName, String branch,
                                              NewFile file) {
        maybeFail();
        boolean granted = reposByInstallation.getOrDefault(installationId, List.of()).stream()
                .anyMatch(r -> r.fullName().equals(repositoryFullName));
        if (!granted) {
            throw new GitHubInstallationGoneException(
                    "installation " + installationId + " does not grant " + repositoryFullName);
        }
        Map<String, String> files = filesByRepo.computeIfAbsent(repositoryFullName, k -> new LinkedHashMap<>());
        if (files.containsKey(file.path())) {
            throw new GitHubFileExistsException(repositoryFullName + " already has " + file.path());
        }
        files.put(file.path(), file.content());
        String sha = String.format("%040x", commits.size() + 1);
        commits.add(new RecordedCommit(installationId, repositoryFullName, branch, file.path(), file.content(),
                file.message(), file.author().login(), file.author().noreplyEmail(), file.authorDate(), sha));
        return new CommittedFile(sha, "https://github.com/" + repositoryFullName + "/commit/" + sha);
    }

    /** Every commit made through {@link #addFile}, oldest first. */
    public synchronized List<RecordedCommit> commits() {
        return List.copyOf(commits);
    }

    /** The repository already contains {@code path}, as if the user or an earlier link added it. */
    public synchronized void seedFile(String repositoryFullName, String path, String content) {
        filesByRepo.computeIfAbsent(repositoryFullName, k -> new LinkedHashMap<>()).put(path, content);
    }

    @Override
    public synchronized List<CommittedFile> pushCommits(long installationId, String repositoryFullName,
                                                        String branch, List<BatchCommit> batch) {
        throw new UnsupportedOperationException("not yet");
    }

    @Override
    public synchronized List<GitHubRepo> listInstallationRepositories(long installationId) {
        maybeFail();
        List<GitHubRepo> repositories = reposByInstallation.get(installationId);
        if (repositories == null) {
            throw new GitHubInstallationGoneException("installation " + installationId + " is gone");
        }
        return repositories;
    }

    private void maybeFail() {
        if (alwaysFailure != null) {
            throw alwaysFailure.get();
        }
        RuntimeException next = nextFailures.poll();
        if (next != null) {
            throw next;
        }
    }
}
