package com.codebite.judge.program;

import com.codebite.common.exception.NoDriverException;
import com.codebite.judge.Language;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.EnumSource;

import java.util.Map;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class ProblemAssetsTest {

    /** The real Drivers and Starter Code, as the backend and worker load them. */
    private static final ProblemAssets ASSETS = new ProblemAssets();

    private static final String[] SLUGS =
            {"snack-drawer-pair", "chat-log-codec", "top-espresso-machines", "valid-brackets", "spot-duplicate-locker"};

    // --- Drivers ---

    @ParameterizedTest
    @EnumSource(Language.class)
    void everyLanguageHasADriverForTheSampleProblems(Language language) {
        for (String slug : SLUGS) {
            assertThat(ASSETS.hasDriver(slug, language)).as(slug + ":" + language.code()).isTrue();
        }
    }

    @ParameterizedTest
    @EnumSource(Language.class)
    void everyProblemHasADriverInEveryLanguage(Language language) {
        assertThat(ASSETS.slugsWithDriver(language))
                .isEqualTo(ASSETS.slugsWithDriver(Language.JAVA))
                .doesNotContain("lib")
                .hasSizeGreaterThanOrEqualTo(200);
    }

    @Test
    void assemble_putsTheUserCodeAtThePlaceholder() {
        Program program = ASSETS.assemble("snack-drawer-pair", Language.JAVA, "class Solution { /* mine */ }");

        assertThat(program.source()).contains("class Solution { /* mine */ }").doesNotContain("{USER_CODE}");
        assertThat(program.language()).isEqualTo(Language.JAVA);
        assertThat(program.judge0Id()).isEqualTo(Language.JAVA.judge0Id());
    }

    @Test
    void hasDriver_isFalseForAnUnknownSlug() {
        assertThat(ASSETS.hasDriver("nonexistent", Language.JAVA)).isFalse();
    }

    @Test
    void assemble_throwsNoDriverForAnUnknownSlug() {
        assertThatThrownBy(() -> ASSETS.assemble("nonexistent", Language.JAVA, "code"))
                .isInstanceOf(NoDriverException.class)
                .hasMessageContaining("nonexistent")
                .hasMessageContaining("java");
    }

    @ParameterizedTest
    @CsvSource({
            "snack-drawer-pair,     java,       JsonOutput.intArray(",
            "chat-log-codec,        java,       JsonOutput.stringList(",
            "top-espresso-machines, java,       JsonOutput.intArray(",
            "snack-drawer-pair,     cpp,        JsonOutput::intVector(",
            "chat-log-codec,        cpp,        JsonOutput::stringVector(",
            "top-espresso-machines, cpp,        JsonOutput::intVector(",
    })
    void javaAndCppDriversHaveTheirJsonOutputLibrarySplicedIn(String slug, String code, String call) {
        String source = ASSETS.assemble(slug, Language.fromCode(code).orElseThrow(), "").source();

        assertThat(source).contains(call).contains("class JsonOutput").doesNotContain("{{LIB:");
    }

    @ParameterizedTest
    @CsvSource({
            "snack-drawer-pair,     python,     json.dumps(",
            "chat-log-codec,        python,     json.dumps(",
            "top-espresso-machines, python,     json.dumps(",
            "snack-drawer-pair,     javascript, JSON.stringify(",
            "chat-log-codec,        javascript, JSON.stringify(",
            "top-espresso-machines, javascript, JSON.stringify(",
    })
    void pythonAndJavaScriptDriversPrintJson(String slug, String code, String call) {
        assertThat(ASSETS.assemble(slug, Language.fromCode(code).orElseThrow(), "").source()).contains(call);
    }

    // --- Starter Code ---

    @Test
    void starters_haveEveryLanguage() {
        for (String slug : new String[]{"snack-drawer-pair", "valid-brackets", "zero-sum-trio", "group-anagrams",
                "merge-reservation-slots"}) {
            assertThat(ASSETS.starters(slug)).as(slug).containsOnlyKeys(Language.values());
        }
    }

    @ParameterizedTest
    @CsvSource({
            "snack-drawer-pair, findPairIndices",
            "valid-brackets,    verifyJobNesting",
            "zero-sum-trio,     triageZeroPriority",
    })
    void starters_defineTheMethodTheProblemCalls(String slug, String method) {
        assertThat(ASSETS.starters(slug).values()).hasSize(4).allMatch(code -> code.contains(method));
    }

    @Test
    void starters_isEmptyForAnUnknownSlug() {
        assertThat(ASSETS.starters("nonexistent")).isEmpty();
    }

    // --- Fixtures: what is read, and what fails at load ---

    @Test
    void fixture_readsDriversLibrariesAndStartersUnderItsRoot() {
        ProblemAssets assets = new ProblemAssets("classpath:problem-assets/valid/");

        assertThat(assets.slugsWithDriver(Language.JAVA)).isEqualTo(Set.of("two-line"));
        assertThat(assets.slugsWithDriver(Language.CPP)).isEmpty();
        assertThat(assets.assemble("two-line", Language.PYTHON, "x = 1").source())
                .isEqualTo("def helper():\n    return 1\n\nx = 1\nprint(helper())\n");
        assertThat(assets.starters("two-line")).isEqualTo(Map.of(Language.PYTHON, "class Solution:\n    pass\n"));
    }

    @Test
    void aDriverWithoutAPlaceholderFailsAtLoad() {
        assertThatThrownBy(() -> new ProblemAssets("classpath:problem-assets/no-placeholder/"))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("broken:java");
    }

    @Test
    void aMissingLibraryFailsAtLoad() {
        assertThatThrownBy(() -> new ProblemAssets("classpath:problem-assets/missing-library/"))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("java:Missing");
    }
}
