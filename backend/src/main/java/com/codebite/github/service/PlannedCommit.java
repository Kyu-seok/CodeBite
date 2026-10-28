package com.codebite.github.service;

import com.codebite.github.gateway.BatchCommit;
import com.codebite.github.gateway.NewFile;

import java.util.List;

/**
 * One Solution Commit to make: its row, the commit to push (the problem folder's README first when
 * the folder is new through this link, then the solution), the path to fall back to if the plain
 * one is taken on GitHub, and whether an earlier delivery already tried it, so its solution file
 * may be on GitHub already.
 *
 * @param solutionCommitId  the Solution Commit row this commit is for
 * @param commit            the files to add, README (if any) before the solution
 * @param solutionPath      where the solution goes; the row's path
 * @param disambiguatedPath the solution's own path ({@link SolutionLayout#disambiguatedPath})
 * @param attemptedBefore   true when the row has been attempted before ({@code attempts > 0})
 */
record PlannedCommit(Long solutionCommitId, BatchCommit commit, String solutionPath,
                     String disambiguatedPath, boolean attemptedBefore) {

    /** Whether this commit starts the problem folder, adding its README with the solution. */
    boolean hasReadme() {
        return commit.files().size() == 2;
    }

    /** The solution alone, for the Contents API when there is no README to add. */
    NewFile asSingleFile() {
        return new NewFile(solutionPath, solutionContent(), commit.message(), commit.author(), commit.authorDate());
    }

    /**
     * The same commit writing the solution to {@code path} instead, without the README: its plain
     * path was found taken, so the folder exists.
     */
    PlannedCommit movedTo(String path) {
        BatchCommit moved = new BatchCommit(List.of(new BatchCommit.File(path, solutionContent())),
                commit.message(), commit.author(), commit.authorDate());
        return new PlannedCommit(solutionCommitId, moved, path, disambiguatedPath, attemptedBefore);
    }

    /** Whether the solution already goes to its own disambiguated path. */
    boolean disambiguated() {
        return solutionPath.equals(disambiguatedPath);
    }

    private String solutionContent() {
        return commit.files().get(commit.files().size() - 1).content();
    }
}
