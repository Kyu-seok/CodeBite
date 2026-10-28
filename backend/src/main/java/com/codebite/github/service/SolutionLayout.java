package com.codebite.github.service;

import com.codebite.judge.Language;
import com.codebite.problem.entity.Problem;
import com.codebite.submission.entity.Submission;

import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * How Solution Commits lay out a Solution Repository: one folder per problem, a subfolder per
 * language, and one file per Accepted submission named by its UTC Accepted time. Paths never
 * repeat, so the repository is append-only.
 */
final class SolutionLayout {

    /** UTC, so the file name's day is the Streak Day (ADR 0001). No colons: they are awkward in paths. */
    private static final DateTimeFormatter FILE_TIME =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HHmmss'Z'").withZone(ZoneOffset.UTC);

    private SolutionLayout() {
    }

    /** {@code <slug>/<language>/<yyyy-MM-ddTHHmmssZ>.<ext>}, named by the UTC Accepted time. */
    static String solutionPath(Submission submission) {
        return solutionPath(submission, "");
    }

    /**
     * {@code <slug>/<language>/<yyyy-MM-ddTHHmmssZ>-<submission id>.<ext>}: the file for a
     * submission whose plain path is already taken, e.g. by another submission Accepted in the same
     * UTC second. Unique per submission, so nothing is ever overwritten.
     */
    static String disambiguatedPath(Submission submission) {
        return solutionPath(submission, "-" + submission.getId());
    }

    private static String solutionPath(Submission submission, String suffix) {
        String language = submission.getLanguage();
        String extension = Language.fromCode(language).map(Language::extension).orElse("txt");
        return submission.getProblem().getSlug() + "/" + language + "/"
                + FILE_TIME.format(submission.getCreatedAt()) + suffix + "." + extension;
    }

    /** {@code <slug>/README.md} */
    static String readmePath(Problem problem) {
        return problem.getSlug() + "/README.md";
    }

    /** Title, difficulty and a link back to CodeBite. Never the description, which is CodeBite's. */
    static String readme(Problem problem, String codebiteBaseUrl) {
        String difficulty = problem.getDifficulty().name().charAt(0)
                + problem.getDifficulty().name().substring(1).toLowerCase(Locale.ROOT);
        return "# " + problem.getTitle() + "\n\n"
                + "Difficulty: " + difficulty + "\n\n"
                + "[Solve it on CodeBite](" + codebiteBaseUrl + "/problems/" + problem.getSlug() + ")\n";
    }

    /** {@code Accepted: <title> (<language>) · <runtime> ms, <memory> MB} */
    static String commitMessage(Problem problem, Submission submission) {
        return "Accepted: " + problem.getTitle() + " (" + submission.getLanguage() + ") · "
                + orUnknown(submission.getRuntimeMs()) + " ms, " + megabytes(submission.getMemoryKb()) + " MB";
    }

    private static String megabytes(Integer kilobytes) {
        return kilobytes == null ? "?" : String.format(Locale.ROOT, "%.1f", kilobytes / 1024.0);
    }

    private static String orUnknown(Integer value) {
        return value == null ? "?" : value.toString();
    }
}
