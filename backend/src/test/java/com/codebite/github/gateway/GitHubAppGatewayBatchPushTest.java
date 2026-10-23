package com.codebite.github.gateway;

import com.codebite.config.GitHubAppProperties;
import com.sun.net.httpserver.HttpServer;
import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.ObjectReader;
import org.eclipse.jgit.lib.PersonIdent;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.revwalk.RevCommit;
import org.eclipse.jgit.revwalk.RevWalk;
import org.eclipse.jgit.transport.RefSpec;
import org.eclipse.jgit.treewalk.TreeWalk;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.web.client.RestClient;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * The real adapter's batch push (Import), against a bare git repository in a temp directory over
 * {@code file://}. Only the installation-token mint goes to a local HTTP server.
 */
class GitHubAppGatewayBatchPushTest {

    private static final GitHubAccount OCTOCAT = new GitHubAccount(583231, "octocat");
    private static final String REPO = "octocat/solutions";

    @TempDir
    Path temp;

    private HttpServer server;
    private String apiBaseUrl;
    private final AtomicInteger tokenMints = new AtomicInteger();
    private Path remote;

    @BeforeEach
    void setUp() throws Exception {
        server = HttpServer.create(new InetSocketAddress(0), 0);
        server.createContext("/app/installations/77/access_tokens", exchange -> {
            tokenMints.incrementAndGet();
            byte[] bytes = "{\"token\":\"installation-token\"}".getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(201, bytes.length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(bytes);
            }
        });
        server.start();
        apiBaseUrl = "http://localhost:" + server.getAddress().getPort();

        remote = temp.resolve("remotes").resolve(REPO + ".git");
        Files.createDirectories(remote);
        Git.init().setBare(true).setDirectory(remote.toFile()).setInitialBranch("main").call().close();
    }

    @AfterEach
    void tearDown() {
        server.stop(0);
    }

    @Test
    void pushesOneCommitPerSubmissionOnTopOfTheTip() throws Exception {
        ObjectId initial = commitToRemote("main", Map.of("README.md", "# My solutions\n"), "Initial commit");

        List<CommittedFile> pushed = gateway().pushCommits(77, REPO, "main", List.of(
                commit("2026-03-01T23:59:59Z", "Accepted: Two Sum (python) · 12 ms, 1.5 MB",
                        "two-sum/README.md", "# Two Sum\n",
                        "two-sum/python/2026-03-01T235959Z.py", "print(1)\n"),
                commit("2026-03-02T00:00:01Z", "Accepted: Two Sum (java) · 40 ms, 20.0 MB",
                        "two-sum/java/2026-03-02T000001Z.java", "class A {}\n"),
                commit("2026-05-10T08:30:00Z", "Accepted: LRU Cache (cpp) · 3 ms, 2.0 MB",
                        "lru-cache/README.md", "# LRU Cache\n",
                        "lru-cache/cpp/2026-05-10T083000Z.cpp", "int main() {}\n")));

        List<RevCommit> log = log("main");
        assertThat(log).hasSize(4);
        assertThat(log.get(0).getId()).isEqualTo(initial);
        List<RevCommit> imported = log.subList(1, 4);

        assertThat(imported).extracting(RevCommit::getFullMessage).containsExactly(
                "Accepted: Two Sum (python) · 12 ms, 1.5 MB",
                "Accepted: Two Sum (java) · 40 ms, 20.0 MB",
                "Accepted: LRU Cache (cpp) · 3 ms, 2.0 MB");
        assertThat(imported).extracting(c -> c.getAuthorIdent().getWhen().toInstant()).containsExactly(
                Instant.parse("2026-03-01T23:59:59Z"),
                Instant.parse("2026-03-02T00:00:01Z"),
                Instant.parse("2026-05-10T08:30:00Z"));
        for (RevCommit c : imported) {
            PersonIdent author = c.getAuthorIdent();
            assertThat(author.getName()).isEqualTo("octocat");
            assertThat(author.getEmailAddress()).isEqualTo("583231+octocat@users.noreply.github.com");
            assertThat(author.getTimeZoneOffset()).isZero();
            assertThat(c.getParentCount()).isEqualTo(1);
        }

        assertThat(addedFiles(imported.get(0))).isEqualTo(Map.of(
                "two-sum/README.md", "# Two Sum\n",
                "two-sum/python/2026-03-01T235959Z.py", "print(1)\n"));
        assertThat(addedFiles(imported.get(1))).isEqualTo(Map.of(
                "two-sum/java/2026-03-02T000001Z.java", "class A {}\n"));
        assertThat(addedFiles(imported.get(2))).isEqualTo(Map.of(
                "lru-cache/README.md", "# LRU Cache\n",
                "lru-cache/cpp/2026-05-10T083000Z.cpp", "int main() {}\n"));
        assertThat(files(log.get(3))).containsEntry("README.md", "# My solutions\n");

        assertThat(pushed).extracting(CommittedFile::sha)
                .containsExactlyElementsOf(imported.stream().map(RevCommit::name).toList());
        assertThat(pushed.get(0).url()).isEqualTo("https://github.test/octocat/solutions/commit/" + imported.get(0).name());
        assertThat(tokenMints).hasValue(1);
    }

    @Test
    void pushRejectedBecauseTheTipMovedIsRebuiltOnTheNewTip() throws Exception {
        ObjectId initial = commitToRemote("main", Map.of("README.md", "# My solutions\n"), "Initial commit");
        GitHubAppGateway gateway = gateway();
        List<Integer> attempts = new ArrayList<>();
        // A live Solution Commit lands between Import's fetch and its push, and it already started
        // the two-sum folder with its README.
        gateway.beforePush(attempt -> {
            attempts.add(attempt);
            if (attempt == 1) {
                commitToRemoteUnchecked(Map.of(
                        "two-sum/README.md", "# Two Sum (live)\n",
                        "two-sum/python/2026-10-24T090000Z.py", "print('live')\n"), "Accepted: Two Sum (live)");
            }
        });

        List<CommittedFile> pushed = gateway.pushCommits(77, REPO, "main", List.of(
                commit("2026-03-01T10:00:00Z", "Accepted: Two Sum (java) · 40 ms, 20.0 MB",
                        "two-sum/README.md", "# Two Sum\n",
                        "two-sum/java/2026-03-01T100000Z.java", "class A {}\n"),
                commit("2026-03-02T10:00:00Z", "Accepted: Two Sum (cpp) · 3 ms, 2.0 MB",
                        "two-sum/cpp/2026-03-02T100000Z.cpp", "int main() {}\n")));

        assertThat(attempts).containsExactly(1, 2);
        List<RevCommit> log = log("main");
        assertThat(log).extracting(RevCommit::getShortMessage).containsExactly(
                "Initial commit",
                "Accepted: Two Sum (live)",
                "Accepted: Two Sum (java) · 40 ms, 20.0 MB",
                "Accepted: Two Sum (cpp) · 3 ms, 2.0 MB");
        assertThat(log.get(0).getId()).isEqualTo(initial);
        // Nothing the live commit added is replaced: the batch's README is dropped, not written over.
        assertThat(addedFiles(log.get(2))).isEqualTo(Map.of("two-sum/java/2026-03-01T100000Z.java", "class A {}\n"));
        assertThat(files(log.get(3))).containsEntry("two-sum/README.md", "# Two Sum (live)\n")
                .containsEntry("two-sum/python/2026-10-24T090000Z.py", "print('live')\n");
        assertThat(pushed).extracting(CommittedFile::sha).containsExactly(log.get(2).name(), log.get(3).name());
    }

    @Test
    void emptyRepositoryGetsTheCommitsAsItsFirstHistory() throws Exception {
        List<CommittedFile> pushed = gateway().pushCommits(77, REPO, "main", List.of(
                commit("2026-03-01T10:00:00Z", "Accepted: Two Sum (java) · 40 ms, 20.0 MB",
                        "two-sum/README.md", "# Two Sum\n",
                        "two-sum/java/2026-03-01T100000Z.java", "class A {}\n")));

        List<RevCommit> log = log("main");
        assertThat(log).hasSize(1);
        assertThat(log.get(0).getParentCount()).isZero();
        assertThat(files(log.get(0))).containsOnlyKeys("two-sum/README.md", "two-sum/java/2026-03-01T100000Z.java");
        assertThat(pushed.get(0).sha()).isEqualTo(log.get(0).name());
    }

    @Test
    void commitWhoseFilesAreAllPresentIsNotMade() throws Exception {
        commitToRemote("main", Map.of("two-sum/java/2026-03-01T100000Z.java", "class A {}\n"), "Live commit");

        List<CommittedFile> pushed = gateway().pushCommits(77, REPO, "main", List.of(
                commit("2026-03-01T10:00:00Z", "Accepted: Two Sum (java) · 40 ms, 20.0 MB",
                        "two-sum/java/2026-03-01T100000Z.java", "class A {}\n")));

        assertThat(log("main")).extracting(RevCommit::getShortMessage).containsExactly("Live commit");
        assertThat(pushed).containsExactly(new CommittedFile(null, null));
    }

    @Test
    void missingRepositoryMeansTheInstallationNoLongerReachesIt() {
        assertThatThrownBy(() -> gateway().pushCommits(77, "octocat/deleted", "main", List.of(
                commit("2026-03-01T10:00:00Z", "m", "a/b.py", "x"))))
                .isInstanceOf(GitHubInstallationGoneException.class);
    }

    // --- helpers ---

    private void commitToRemoteUnchecked(Map<String, String> files, String message) {
        try {
            commitToRemote("main", files, message);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    private GitHubAppGateway gateway() {
        GitHubAppProperties properties = new GitHubAppProperties();
        properties.setAppId("12345");
        properties.setClientId("app-client-id");
        properties.setClientSecret("app-client-secret");
        properties.setSlug("codebite-test");
        properties.setPrivateKeyBase64(Base64.getEncoder().encodeToString(resource("github/test-app-key.pem")));
        properties.setApiBaseUrl(apiBaseUrl);
        properties.setWebBaseUrl("https://github.test");
        properties.setGitBaseUrl(temp.resolve("remotes").toUri().toString());
        return new GitHubAppGateway(properties, RestClient.builder());
    }

    /** A commit authored as octocat at {@code at}, adding path/content pairs. */
    private static BatchCommit commit(String at, String message, String... pathsAndContents) {
        List<BatchCommit.File> files = new ArrayList<>();
        for (int i = 0; i < pathsAndContents.length; i += 2) {
            files.add(new BatchCommit.File(pathsAndContents[i], pathsAndContents[i + 1]));
        }
        return new BatchCommit(files, message, OCTOCAT, Instant.parse(at));
    }

    /** Commits {@code files} to the remote's branch through an ordinary clone, as GitHub would. */
    private ObjectId commitToRemote(String branch, Map<String, String> files, String message) throws Exception {
        Path work = Files.createTempDirectory(temp, "clone");
        try (Git git = Git.cloneRepository().setURI(remote.toUri().toString()).setDirectory(work.toFile()).call()) {
            if (git.getRepository().findRef("refs/heads/" + branch) != null) {
                git.checkout().setName(branch).call();
            } else if (git.getRepository().resolve("origin/" + branch) != null) {
                git.checkout().setName(branch).setCreateBranch(true).setStartPoint("origin/" + branch).call();
            } else {
                git.checkout().setOrphan(true).setName(branch).call();
            }
            for (Map.Entry<String, String> file : files.entrySet()) {
                Path path = work.resolve(file.getKey());
                Files.createDirectories(path.getParent());
                Files.writeString(path, file.getValue());
            }
            git.add().addFilepattern(".").call();
            RevCommit commit = git.commit().setMessage(message)
                    .setAuthor("someone", "someone@example.com")
                    .setCommitter("someone", "someone@example.com").call();
            git.push().setRefSpecs(new RefSpec(branch + ":" + branch)).call();
            return commit.getId();
        }
    }

    /** The branch's history in the remote, oldest first. */
    private List<RevCommit> log(String branch) throws Exception {
        try (Git git = Git.open(remote.toFile())) {
            List<RevCommit> commits = new ArrayList<>();
            git.log().add(git.getRepository().resolve("refs/heads/" + branch)).call().forEach(commits::add);
            Collections.reverse(commits);
            return commits;
        }
    }

    /** Every file in the commit's tree, by path. */
    private Map<String, String> files(RevCommit commit) throws IOException {
        Map<String, String> files = new LinkedHashMap<>();
        try (Repository repository = Git.open(remote.toFile()).getRepository();
             ObjectReader reader = repository.newObjectReader();
             RevWalk walk = new RevWalk(reader);
             TreeWalk tree = new TreeWalk(reader)) {
            tree.addTree(walk.parseCommit(commit).getTree());
            tree.setRecursive(true);
            while (tree.next()) {
                files.put(tree.getPathString(),
                        new String(reader.open(tree.getObjectId(0)).getBytes(), StandardCharsets.UTF_8));
            }
        }
        return files;
    }

    /** The files this commit adds compared with its parent (or all of them for a root commit). */
    private Map<String, String> addedFiles(RevCommit commit) throws IOException {
        Map<String, String> after = files(commit);
        if (commit.getParentCount() == 0) {
            return after;
        }
        Map<String, String> before = files(commit.getParent(0));
        Map<String, String> added = new LinkedHashMap<>(after);
        before.keySet().forEach(added::remove);
        return added;
    }

    private static byte[] resource(String name) {
        try (var in = GitHubAppGatewayBatchPushTest.class.getClassLoader().getResourceAsStream(name)) {
            return in.readAllBytes();
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }
}
