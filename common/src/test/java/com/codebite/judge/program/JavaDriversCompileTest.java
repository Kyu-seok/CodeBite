package com.codebite.judge.program;

import com.codebite.judge.Language;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import javax.tools.Diagnostic;
import javax.tools.DiagnosticCollector;
import javax.tools.FileObject;
import javax.tools.ForwardingJavaFileManager;
import javax.tools.JavaCompiler;
import javax.tools.JavaFileManager;
import javax.tools.JavaFileObject;
import javax.tools.SimpleJavaFileObject;
import javax.tools.ToolProvider;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Every Java Driver compiles with its own untouched Starter Code in place of {@code {USER_CODE}},
 * assembled as the backend assembles it and built as Judge0 builds it ({@code --release 13}), in
 * memory. A Driver that doesn't is a problem no Java submission can pass: one that calls a method
 * its types lack, or one that puts a Library class above a starter that opens with an
 * {@code import} (#336).
 *
 * <p>Every Driver also compiles when the code in its place opens with an {@code import} of the
 * user's own: Java allows no import after a class, so nothing but the Driver's imports may come
 * before {@code {USER_CODE}}, and Libraries and helper classes go below it (#412).
 *
 * <p>A starter is a stub, so one javac error is expected and passed over: "missing return
 * statement" on the starter's own lines. The same error on a Driver line fails.
 */
class JavaDriversCompileTest {

    private static final String MISSING_RETURN = "compiler.err.missing.ret.stmt";

    /** What a user may type as their first line; no Driver or Starter Code needs it. */
    private static final String LEADING_IMPORT = "import java.util.stream.*;\n";

    /**
     * Judge0's release, and every class checked through flow analysis whatever errors came before:
     * left to itself javac stops at the stub's missing return and never reports a Driver's own
     * missing return, unassigned variable or uncaught checked exception.
     */
    private static final List<String> JAVAC_OPTIONS =
            List.of("--release", "13", "-proc:none", "-XDshould-stop.ifError=FLOW");

    private static final JavaCompiler COMPILER = ToolProvider.getSystemJavaCompiler();
    private static final JavaFileManager CLASS_FILES_DISCARDED = COMPILER == null ? null : discardingClassFiles();

    @AfterAll
    static void closeFileManager() throws IOException {
        if (CLASS_FILES_DISCARDED != null) {
            CLASS_FILES_DISCARDED.close();
        }
    }

    @Test
    void everyJavaDriverCompilesWithItsStarterCode() {
        ProblemAssets assets = new ProblemAssets();
        List<String> broken = new ArrayList<>();
        for (String slug : assets.slugsWithDriver(Language.JAVA)) {
            firstError(assets, slug).ifPresent(broken::add);
        }

        assertThat(assets.slugsWithDriver(Language.JAVA)).hasSizeGreaterThanOrEqualTo(200);
        assertThat(broken).as("Java Drivers that do not compile with their Starter Code").isEmpty();
    }

    @Test
    void everyJavaDriverCompilesWhenTheUsersCodeOpensWithAnImport() {
        ProblemAssets assets = new ProblemAssets();
        List<String> broken = new ArrayList<>();
        for (String slug : assets.slugsWithDriver(Language.JAVA)) {
            firstError(assets, slug, LEADING_IMPORT).ifPresent(broken::add);
        }

        assertThat(broken)
                .as("Java Drivers with a Library or a class above {USER_CODE}: move it below, "
                        + "or a submission that opens with an import does not compile")
                .isEmpty();
    }

    // --- What the check catches, on Drivers made for it ---

    private static final ProblemAssets FIXTURES = new ProblemAssets("classpath:problem-assets/java-drivers/");

    @Test
    void aStubStarterInAWorkingDriverPasses() {
        assertThat(firstError(FIXTURES, "stub-starter")).isEmpty();
    }

    @ParameterizedTest
    @CsvSource(delimiter = '|', value = {
            // kth-top-score-stream before #336: no submission could compile
            "driver-calls-a-missing-method        | line 22: cannot find symbol      | ops.record(\"names\");",
            // fizz-buzz before #336: the starter's import lands below the Library's class
            "library-above-the-starters-import    | line 10: class, interface, or enum expected | import java.util.List;",
            // just outside what is passed over: a missing return on a Driver line
            "driver-method-returns-nothing        | line 22: missing return statement | }",
            // and an error on a starter line that is not a missing return
            "starter-names-a-type-nothing-imports | line 2: cannot find symbol       | public List<String> names(int n) {",
    })
    void aDriverThatCannotCompileIsNamedWithJavacsFirstError(String slug, String error, String sourceLine) {
        assertThat(firstError(FIXTURES, slug)).get().asString()
                .startsWith(slug + ": ")
                .contains(error)
                .endsWith("| " + sourceLine);
    }

    @Test
    void aLibraryAboveTheUsersCodeBreaksOnlyCodeThatOpensWithAnImport() {
        assertThat(firstError(FIXTURES, "library-above-the-user-code")).isEmpty();
        assertThat(firstError(FIXTURES, "library-above-the-user-code", LEADING_IMPORT)).get().asString()
                .isEqualTo("library-above-the-user-code: line 10: class, interface, or enum expected"
                        + " | import java.util.stream.*;");
    }

    @Test
    void aLeadingImportAboveAStubStarterInAWorkingDriverPasses() {
        assertThat(firstError(FIXTURES, "stub-starter", LEADING_IMPORT)).isEmpty();
    }

    @Test
    void aDriverWithoutAStarterIsNamed() {
        assertThat(firstError(FIXTURES, "no-starter")).contains("no-starter: no Java Starter Code");
    }

    /**
     * {@code <slug>: line <n>: <javac's message> | <that line>} for the first error javac reports
     * in the slug's Driver with its Starter Code, the line counted in the assembled Program (its
     * Libraries are expanded, so it is not the Driver file's line); empty when it compiles.
     */
    private static Optional<String> firstError(ProblemAssets assets, String slug) {
        return firstError(assets, slug, "");
    }

    /** The same, with {@code leadingLines} typed above the Starter Code as a user might. */
    private static Optional<String> firstError(ProblemAssets assets, String slug, String leadingLines) {
        assertThat(COMPILER).as("javac: these tests need a JDK, not a JRE").isNotNull();
        String untouched = assets.starters(slug).get(Language.JAVA);
        if (untouched == null) {
            return Optional.of(slug + ": no Java Starter Code");
        }
        String starter = leadingLines + untouched;
        String source = assets.assemble(slug, Language.JAVA, starter).source();
        int starterAt = source.indexOf(starter);
        assertThat(starterAt).as(slug + ": its Starter Code, verbatim, in the assembled Program").isNotNegative();
        int starterFirstLine = Program.newlines(source, starterAt) + 1;
        int starterLastLine = starterFirstLine + Program.newlines(starter, starter.length());

        DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<>();
        COMPILER.getTask(null, CLASS_FILES_DISCARDED, diagnostics,
                JAVAC_OPTIONS, null, List.of(new MainSource(source))).call();

        return diagnostics.getDiagnostics().stream()
                .filter(d -> d.getKind() == Diagnostic.Kind.ERROR)
                .filter(d -> !(MISSING_RETURN.equals(d.getCode())
                        && d.getLineNumber() >= starterFirstLine && d.getLineNumber() <= starterLastLine))
                .findFirst()
                .map(d -> slug + ": line " + d.getLineNumber() + ": " + d.getMessage(Locale.ROOT)
                        + " | " + source.lines().skip(d.getLineNumber() - 1).findFirst().orElse("").strip());
    }

    /** The assembled Program as Judge0 names it, {@code Main.java}. */
    private static final class MainSource extends SimpleJavaFileObject {
        private final String source;

        MainSource(String source) {
            super(URI.create("string:///Main.java"), Kind.SOURCE);
            this.source = source;
        }

        @Override
        public CharSequence getCharContent(boolean ignoreEncodingErrors) {
            return source;
        }
    }

    /** One file manager for every compilation, so the JDK's classes are opened once; no class file is kept. */
    private static JavaFileManager discardingClassFiles() {
        return new ForwardingJavaFileManager<>(COMPILER.getStandardFileManager(null, null, null)) {
            @Override
            public JavaFileObject getJavaFileForOutput(Location location, String className,
                                                       JavaFileObject.Kind kind, FileObject sibling) {
                return new SimpleJavaFileObject(URI.create("discarded:///" + className.replace('.', '/') + kind.extension), kind) {
                    @Override
                    public OutputStream openOutputStream() {
                        return OutputStream.nullOutputStream();
                    }
                };
            }
        };
    }
}
