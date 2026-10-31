package com.codebite.progress;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Only {@code progress/} spells out "non-admin" in a query. {@code UserProgress} owns what Solved and
 * Attempted mean and {@code ProblemPopularity} the Acceptance Rate (GLOSSARY.md), so a query elsewhere
 * that writes {@code adminSubmission = false} (JPQL) or {@code admin_submission = false} (SQL) is
 * usually a second copy of one of those rules, which drifts. This scans the main sources of every
 * module and fails with the file and line of each occurrence outside the owners.
 *
 * <p>Applied migrations are history and can't be edited, so {@code db/migration} isn't scanned.
 */
class ProgressOwnersTest {

    private static final Pattern NON_ADMIN =
            // a JPQL path (s.adminSubmission) or the SQL column, never the entity's field initializer
            Pattern.compile("(?i)(?:\\.adminSubmission|admin_submission)\\s*"
                    + "(?:(?:=|\\bis\\b)\\s*false|(?:<>|!=)\\s*true)\\b");
    private static final List<String> MODULES = List.of("backend", "common", "worker");
    /** Files allowed to write the condition, by path from the repository root, each with its reason. */
    private static final Map<String, String> OWNERS = Map.of(
            "backend/src/main/java/com/codebite/progress/UserProgress.java",
            "owns Solved and Attempted (Accepted/graded, non-admin)",
            "backend/src/main/java/com/codebite/progress/ProblemPopularity.java",
            "owns the Acceptance Rate (graded non-admin submissions)",
            "common/src/main/java/com/codebite/user/repository/UserRepository.java",
            "findAllOverviews counts each user's Solved problems live for the admin users page, since "
                    + "user_stats was never backfilled; a JPQL aggregate per user that UserProgress has no read for",
            "common/src/main/java/com/codebite/submission/repository/SubmissionRepository.java",
            "the admin dashboard's traffic figures (countSince, countDailySubmissions, findRecentGlobal) "
                    + "count every non-admin submission, not Solved, Attempted or the Acceptance Rate");

    @Test
    void onlyProgressOwnersWriteOutNonAdmin() throws IOException {
        Path root = Path.of("").toAbsolutePath().getParent();
        List<String> outside = new ArrayList<>();
        for (String module : MODULES) {
            Path main = root.resolve(module).resolve("src/main");
            if (!Files.isDirectory(main)) continue;
            try (Stream<Path> files = Files.walk(main)) {
                for (Path file : files.filter(Files::isRegularFile).toList()) {
                    String relative = root.relativize(file).toString().replace('\\', '/');
                    if (relative.contains("/db/migration/") || OWNERS.containsKey(relative)) continue;
                    String[] lines = new String(Files.readAllBytes(file), StandardCharsets.UTF_8).split("\\R", -1);
                    for (int i = 0; i < lines.length; i++) {
                        if (NON_ADMIN.matcher(lines[i]).find()) outside.add(relative + ":" + (i + 1));
                    }
                }
            }
        }
        assertTrue(outside.isEmpty(), "A query outside progress/ writes out \"non-admin\" (adminSubmission = false): "
                + "read Solved, Attempted or the Acceptance Rate through UserProgress or ProblemPopularity instead, "
                + "or, for a figure that isn't one of those, add the file to OWNERS with its reason: " + outside);
    }
}
