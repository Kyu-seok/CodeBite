package com.codebite.problem;

import com.codebite.problem.service.Walkthroughs;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/** The Walkthrough files as the backend reads them once at startup (ADR 0011). */
class WalkthroughsTest {

    private final ObjectMapper json = new ObjectMapper();

    @Test
    void aSlugWithAFileHasItsWalkthroughAsWritten() throws Exception {
        Walkthroughs walkthroughs = new Walkthroughs("classpath:walkthrough-fixtures/valid/");

        assertThat(walkthroughs.has("pair-sum")).isTrue();
        assertThat(json.readTree(walkthroughs.of("pair-sum").orElseThrow()).path("title").path("en").asText())
                .isEqualTo("Pair");
    }

    @Test
    void aSlugWithoutAFileHasNone() {
        Walkthroughs walkthroughs = new Walkthroughs("classpath:walkthrough-fixtures/valid/");

        assertThat(walkthroughs.has("two-sum")).isFalse();
        assertThat(walkthroughs.of("two-sum")).isEmpty();
    }

    @Test
    void aFileThatIsNotJsonFailsStartup() {
        assertThatThrownBy(() -> new Walkthroughs("classpath:walkthrough-fixtures/broken/"))
                .hasMessageContaining("pair-sum.json");
    }

    @Test
    void noDirectoryMeansNoWalkthroughs() {
        assertThat(new Walkthroughs("classpath:walkthrough-fixtures/none/").has("pair-sum")).isFalse();
    }
}
