package com.codebite.github.gateway;

import org.eclipse.jgit.api.Git;
import org.eclipse.jgit.api.errors.GitAPIException;
import org.eclipse.jgit.api.errors.TransportException;
import org.eclipse.jgit.dircache.DirCache;
import org.eclipse.jgit.dircache.DirCacheBuilder;
import org.eclipse.jgit.dircache.DirCacheEditor;
import org.eclipse.jgit.dircache.DirCacheEntry;
import org.eclipse.jgit.errors.NoRemoteRepositoryException;
import org.eclipse.jgit.lib.CommitBuilder;
import org.eclipse.jgit.lib.Constants;
import org.eclipse.jgit.lib.FileMode;
import org.eclipse.jgit.lib.ObjectId;
import org.eclipse.jgit.lib.ObjectInserter;
import org.eclipse.jgit.lib.ObjectReader;
import org.eclipse.jgit.lib.PersonIdent;
import org.eclipse.jgit.lib.Ref;
import org.eclipse.jgit.lib.RefUpdate;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.revwalk.RevWalk;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;
import org.eclipse.jgit.transport.CredentialsProvider;
import org.eclipse.jgit.transport.PushResult;
import org.eclipse.jgit.transport.RefSpec;
import org.eclipse.jgit.transport.RemoteRefUpdate;
import org.eclipse.jgit.util.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TimeZone;
import java.util.function.IntConsumer;

/**
 * One batch push over git: a shallow fetch of the branch tip into a throwaway bare repository,
 * one commit per {@link BatchCommit} built directly as git objects (no working tree), and a
 * single push. A non-fast-forward rejection means the branch moved meanwhile, so it fetches again
 * and rebuilds on the new tip. Commits only add files, so a rebuild can always fast-forward.
 */
final class GitBatchPush {

    private static final Logger log = LoggerFactory.getLogger(GitBatchPush.class);

    /** Each rejection means someone else pushed in the last second or two; a handful is plenty. */
    static final int MAX_ATTEMPTS = 5;

    private static final String LOCAL_REF = "refs/heads/codebite-import";
    private static final TimeZone UTC = TimeZone.getTimeZone("UTC");

    private final String remote;
    private final CredentialsProvider credentials;
    private final String branch;
    private final IntConsumer beforePush;

    GitBatchPush(String remote, CredentialsProvider credentials, String branch, IntConsumer beforePush) {
        this.remote = remote;
        this.credentials = credentials;
        this.branch = branch;
        this.beforePush = beforePush;
    }

    /**
     * @return the new commit id per input commit, in order; null where every file already existed
     */
    List<ObjectId> push(List<BatchCommit> commits) {
        Path dir = null;
        try {
            dir = Files.createTempDirectory("codebite-import-");
            try (Repository repository = FileRepositoryBuilder.create(dir.toFile());
                 Git git = Git.wrap(repository)) {
                repository.create(true);
                for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
                    ObjectId tip = fetchTip(git);
                    List<ObjectId> built = build(repository, tip, commits);
                    ObjectId head = built.stream().filter(id -> id != null).reduce((a, b) -> b).orElse(null);
                    if (head == null) {
                        return built;
                    }
                    beforePush.accept(attempt);
                    RemoteRefUpdate.Status status = pushHead(git, head);
                    if (status == RemoteRefUpdate.Status.OK) {
                        return built;
                    }
                    if (status != RemoteRefUpdate.Status.REJECTED_NONFASTFORWARD
                            && status != RemoteRefUpdate.Status.REJECTED_REMOTE_CHANGED) {
                        throw new GitHubGatewayException("push to " + branch + " refused: " + status);
                    }
                    log.info("Push to {} rejected ({}), rebuilding on the new tip (attempt {})",
                            branch, status, attempt);
                }
                throw new GitHubTransientException(
                        "push to " + branch + " still rejected after " + MAX_ATTEMPTS + " attempts");
            }
        } catch (NoRemoteRepositoryException e) {
            throw new GitHubInstallationGoneException("repository not found: " + e.getMessage());
        } catch (TransportException e) {
            throw transport(e);
        } catch (GitAPIException e) {
            throw new GitHubGatewayException("git " + e.getMessage(), e);
        } catch (IOException e) {
            throw new GitHubTransientException("git I/O failed: " + e.getMessage(), e);
        } finally {
            delete(dir);
        }
    }

    /** The branch tip after a depth-1 fetch, or null when the remote has no such branch yet. */
    private ObjectId fetchTip(Git git) throws GitAPIException {
        Collection<Ref> heads = Git.lsRemoteRepository().setRemote(remote).setCredentialsProvider(credentials)
                .setHeads(true).call();
        String remoteRef = Constants.R_HEADS + branch;
        if (heads.stream().noneMatch(r -> r.getName().equals(remoteRef))) {
            return null;
        }
        String tracking = Constants.R_REMOTES + "origin/" + branch;
        return git.fetch().setRemote(remote).setCredentialsProvider(credentials)
                .setRefSpecs(new RefSpec("+" + remoteRef + ":" + tracking))
                .setDepth(1)
                .call()
                .getAdvertisedRef(remoteRef)
                .getObjectId();
    }

    private static List<ObjectId> build(Repository repository, ObjectId tip, List<BatchCommit> commits)
            throws IOException {
        List<ObjectId> built = new ArrayList<>();
        try (ObjectInserter inserter = repository.newObjectInserter();
             ObjectReader reader = repository.newObjectReader();
             RevWalk walk = new RevWalk(reader)) {
            DirCache index = DirCache.newInCore();
            if (tip != null) {
                DirCacheBuilder builder = index.builder();
                builder.addTree(new byte[0], DirCacheEntry.STAGE_0, reader, walk.parseCommit(tip).getTree());
                builder.finish();
            }
            ObjectId parent = tip;
            for (BatchCommit commit : commits) {
                DirCacheEditor editor = index.editor();
                Set<String> added = new HashSet<>();
                for (BatchCommit.File file : commit.files()) {
                    // Append-only: whatever is already on the branch stays exactly as it is.
                    if (index.getEntry(file.path()) != null || !added.add(file.path())) {
                        continue;
                    }
                    ObjectId blob = inserter.insert(Constants.OBJ_BLOB,
                            file.content().getBytes(StandardCharsets.UTF_8));
                    editor.add(new DirCacheEditor.PathEdit(file.path()) {
                        @Override
                        public void apply(DirCacheEntry entry) {
                            entry.setFileMode(FileMode.REGULAR_FILE);
                            entry.setObjectId(blob);
                        }
                    });
                }
                if (added.isEmpty()) {
                    built.add(null);
                    continue;
                }
                editor.finish();

                CommitBuilder builder = new CommitBuilder();
                builder.setTreeId(index.writeTree(inserter));
                if (parent != null) {
                    builder.setParentId(parent);
                }
                GitHubAccount author = commit.author();
                builder.setAuthor(ident(author, commit.authorDate()));
                // Only the author date has to carry the Accepted time (ADR 0002).
                builder.setCommitter(ident(author, Instant.now()));
                builder.setMessage(commit.message());
                parent = inserter.insert(builder);
                built.add(parent);
            }
            inserter.flush();
        }
        return built;
    }

    private RemoteRefUpdate.Status pushHead(Git git, ObjectId head) throws GitAPIException, IOException {
        RefUpdate local = git.getRepository().updateRef(LOCAL_REF);
        local.setNewObjectId(head);
        local.setForceUpdate(true);
        local.update();

        String remoteRef = Constants.R_HEADS + branch;
        Iterable<PushResult> results = git.push().setRemote(remote).setCredentialsProvider(credentials)
                .setRefSpecs(new RefSpec(LOCAL_REF + ":" + remoteRef))
                .call();
        RemoteRefUpdate update = results.iterator().next().getRemoteUpdate(remoteRef);
        return update.getStatus();
    }

    private static PersonIdent ident(GitHubAccount account, Instant when) {
        return new PersonIdent(account.login(), account.noreplyEmail(), Date.from(when), UTC);
    }

    private static GitHubGatewayException transport(TransportException e) {
        String message = String.valueOf(e.getMessage());
        if (e.getCause() instanceof NoRemoteRepositoryException || message.contains("not found")
                || message.contains("not authorized")) {
            return new GitHubInstallationGoneException("repository not reachable: " + message);
        }
        return new GitHubTransientException("git transport failed: " + message, e);
    }

    private static void delete(Path dir) {
        if (dir == null) {
            return;
        }
        try {
            FileUtils.delete(dir.toFile(), FileUtils.RECURSIVE | FileUtils.SKIP_MISSING | FileUtils.RETRY);
        } catch (IOException e) {
            log.warn("Could not delete {}: {}", dir, e.getMessage());
        }
    }
}
