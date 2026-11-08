package com.codebite.problem;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

/**
 * What one of StatementsMatchTestCasesTest's checks found, listed problems included: one block per
 * problem and language with its mismatch lines, written to {@code build/reports/statements/<check>.txt}
 * on every run so a listed problem's lines can be read without emptying the exemption set.
 */
final class StatementReport {

    /**
     * One statement's mismatch lines under the statement's name ({@code slug (locale)}, as the test's
     * failure message prints it); a statement with none has no Finding.
     */
    record Finding(String slug, String name, List<String> lines) {
    }

    /** Gradle runs the tests from the backend module, so this is {@code backend/build/reports/statements}. */
    static final Path DIRECTORY = Path.of("build", "reports", "statements");

    private StatementReport() {
    }

    /** Writes {@code <directory>/<check>.txt}, creating the directory, and returns it. */
    static Path write(Path directory, String check, Set<String> listed, Set<String> breaking, List<Finding> findings)
            throws IOException {
        Files.createDirectories(directory);
        Path file = directory.resolve(check + ".txt");
        Files.writeString(file, render(check, listed, breaking, findings));
        return file;
    }

    /** {@code breaking} is every slug the findings name, as the check already gathered it. */
    static String render(String check, Set<String> listed, Set<String> breaking, List<Finding> findings) {
        Set<String> breakingListed = new TreeSet<>(breaking);
        breakingListed.retainAll(listed);
        StringBuilder out = new StringBuilder();
        out.append(check).append(": ").append(breaking.size()).append(" problems break the check, ")
                .append(breakingListed.size()).append(" listed. A problem absent here passes.\n");
        for (Finding finding : findings) {
            out.append('\n').append(finding.name());
            if (listed.contains(finding.slug())) out.append(" [listed]");
            out.append('\n');
            for (String line : finding.lines()) out.append("  ").append(line).append('\n');
        }
        return out.toString();
    }
}
