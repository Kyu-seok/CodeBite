package com.codebite.github.gateway;

import java.util.ArrayDeque;
import java.util.Arrays;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
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
    private Supplier<? extends RuntimeException> alwaysFailure;

    /** Forgets all GitHub state and injected failures. */
    public synchronized void reset() {
        accountsByCode.clear();
        installationsByAccount.clear();
        reposByInstallation.clear();
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
