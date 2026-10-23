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
    private final List<RecordedPush> pushes = new ArrayList<>();
    private Supplier<? extends RuntimeException> alwaysFailure;
    private long shaSequence;
    /** Paths whose next commit lands on GitHub but whose response never comes back. */
    private final Set<String> lostResponses = new HashSet<>();
    private int calls;
    /** Every commit in the order made, whether by {@link #addFile} or {@link #pushCommits}. */
    private final List<RecordedBatchCommit> history = new ArrayList<>();
    /** Runs once, just before the next commit or push is applied. */
    private Runnable beforeNextCommit;

    /** A commit that reached the fake, in the order made. */
    public record RecordedCommit(long installationId, String repositoryFullName, String branch, String path,
                                 String content, String message, String authorName, String authorEmail,
                                 Instant authorDate, String sha) {
    }

    /** One batch push and the commits it made, in order. */
    public record RecordedPush(long installationId, String repositoryFullName, String branch,
                               List<RecordedBatchCommit> commits) {
    }

    /** A commit made by a batch push, with only the files it actually added. */
    public record RecordedBatchCommit(Map<String, String> files, String message, String authorName,
                                      String authorEmail, Instant authorDate, String sha) {
    }

    /** Forgets all GitHub state and injected failures. */
    public synchronized void reset() {
        accountsByCode.clear();
        installationsByAccount.clear();
        reposByInstallation.clear();
        commits.clear();
        pushes.clear();
        filesByRepo.clear();
        nextFailures.clear();
        alwaysFailure = null;
        lostResponses.clear();
        history.clear();
        beforeNextCommit = null;
        calls = 0;
    }

    /** How many gateway operations have been called since {@link #reset}, failed ones included. */
    public synchronized int calls() {
        return calls;
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

    /** The user uninstalled the App: every operation on {@code installationId} now reports it gone. */
    public synchronized void uninstall(long installationId) {
        reposByInstallation.remove(installationId);
    }

    /**
     * The user deleted {@code repositoryFullName} on GitHub: no installation grants it any more and
     * its files are gone.
     */
    public synchronized void deleteRepository(String repositoryFullName) {
        reposByInstallation.replaceAll((id, repos) -> repos.stream()
                .filter(r -> !r.fullName().equals(repositoryFullName)).toList());
        filesByRepo.remove(repositoryFullName);
    }

    /** The next gateway calls throw these, in order, one per call. */
    public synchronized void failNext(RuntimeException... failures) {
        nextFailures.addAll(List.of(failures));
    }

    /** Every gateway call throws a fresh exception from {@code failure} until {@link #reset}. */
    public synchronized void failAlways(Supplier<? extends RuntimeException> failure) {
        this.alwaysFailure = failure;
    }

    /** GitHub works again: forgets injected failures but keeps all GitHub state. */
    public synchronized void recover() {
        nextFailures.clear();
        alwaysFailure = null;
    }

    /**
     * The next commit of {@code path} lands, but the caller gets a transient error instead of the
     * response, as when a connection drops after GitHub has written the file.
     */
    public synchronized void loseResponseTo(String path) {
        lostResponses.add(path);
    }

    /**
     * Runs {@code action} once, just before the next {@link #addFile} or {@link #pushCommits} is
     * applied: for example another writer landing the same file while a commit is in flight.
     */
    public synchronized void beforeNextCommit(Runnable action) {
        this.beforeNextCommit = action;
    }

    /** Every commit made, oldest first, with the files each one added, whichever way it was made. */
    public synchronized List<RecordedBatchCommit> history() {
        return List.copyOf(history);
    }

    private void runBeforeNextCommit() {
        Runnable action = beforeNextCommit;
        beforeNextCommit = null;
        if (action != null) {
            action.run();
        }
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
        runBeforeNextCommit();
        requireGranted(installationId, repositoryFullName);
        Map<String, String> files = filesByRepo.computeIfAbsent(repositoryFullName, k -> new LinkedHashMap<>());
        if (files.containsKey(file.path())) {
            throw new GitHubFileExistsException(repositoryFullName + " already has " + file.path());
        }
        files.put(file.path(), file.content());
        String sha = nextSha();
        commits.add(new RecordedCommit(installationId, repositoryFullName, branch, file.path(), file.content(),
                file.message(), file.author().login(), file.author().noreplyEmail(), file.authorDate(), sha));
        history.add(new RecordedBatchCommit(Map.of(file.path(), file.content()), file.message(),
                file.author().login(), file.author().noreplyEmail(), file.authorDate(), sha));
        if (lostResponses.remove(file.path())) {
            throw new GitHubTransientException("connection reset after committing " + file.path());
        }
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
        maybeFail();
        runBeforeNextCommit();
        requireGranted(installationId, repositoryFullName);
        Map<String, String> files = filesByRepo.computeIfAbsent(repositoryFullName, k -> new LinkedHashMap<>());
        List<RecordedBatchCommit> recorded = new ArrayList<>();
        List<CommittedFile> result = new ArrayList<>();
        for (BatchCommit commit : batch) {
            // Like the real push: files already in the repository are left alone.
            Map<String, String> added = new LinkedHashMap<>();
            commit.files().stream()
                    .filter(f -> !files.containsKey(f.path()) && !added.containsKey(f.path()))
                    .forEach(f -> added.put(f.path(), f.content()));
            if (added.isEmpty()) {
                result.add(new CommittedFile(null, null));
                continue;
            }
            files.putAll(added);
            String sha = nextSha();
            recorded.add(new RecordedBatchCommit(added, commit.message(), commit.author().login(),
                    commit.author().noreplyEmail(), commit.authorDate(), sha));
            result.add(new CommittedFile(sha, "https://github.com/" + repositoryFullName + "/commit/" + sha));
        }
        pushes.add(new RecordedPush(installationId, repositoryFullName, branch, List.copyOf(recorded)));
        history.addAll(recorded);
        return result;
    }

    /** Every batch push that reached the fake, oldest first. */
    public synchronized List<RecordedPush> pushes() {
        return List.copyOf(pushes);
    }

    private void requireGranted(long installationId, String repositoryFullName) {
        boolean granted = reposByInstallation.getOrDefault(installationId, List.of()).stream()
                .anyMatch(r -> r.fullName().equals(repositoryFullName));
        if (!granted) {
            throw new GitHubInstallationGoneException(
                    "installation " + installationId + " does not grant " + repositoryFullName);
        }
    }

    private String nextSha() {
        return String.format("%040x", ++shaSequence);
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

    @Override
    public synchronized boolean isRepositoryReachable(long installationId, long repositoryId) {
        maybeFail();
        return reposByInstallation.getOrDefault(installationId, List.of()).stream()
                .anyMatch(r -> r.id() == repositoryId);
    }

    private void maybeFail() {
        calls++;
        if (alwaysFailure != null) {
            throw alwaysFailure.get();
        }
        RuntimeException next = nextFailures.poll();
        if (next != null) {
            throw next;
        }
    }
}
