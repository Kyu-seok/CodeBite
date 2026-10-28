package com.codebite.judge;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class LanguageTest {

    @ParameterizedTest
    @CsvSource({"java, 62, java", "python, 100, py", "javascript, 63, js", "cpp, 54, cpp"})
    void eachCodeHasOneActiveJudge0IdAndOneExtension(String code, int judge0Id, String extension) {
        Language language = Language.fromCode(code).orElseThrow();

        assertEquals(code, language.code());
        assertEquals(judge0Id, language.judge0Id());
        assertEquals(extension, language.extension());
    }

    @Test
    void fromCodeIgnoresCase() {
        assertEquals(Optional.of(Language.JAVA), Language.fromCode("Java"));
        assertEquals(Optional.of(Language.PYTHON), Language.fromCode("PYTHON"));
    }

    @Test
    void fromCodeIsEmptyForNullAndForCodesCodeBiteDoesNotAccept() {
        assertTrue(Language.fromCode(null).isEmpty());
        assertTrue(Language.fromCode("c").isEmpty());
        assertTrue(Language.fromCode("rust").isEmpty());
        assertTrue(Language.fromCode("").isEmpty());
    }

    @Test
    void fromJudge0IdResolvesActiveIds() {
        assertEquals(Optional.of(Language.JAVA), Language.fromJudge0Id(62));
        assertEquals(Optional.of(Language.PYTHON), Language.fromJudge0Id(100));
        assertEquals(Optional.of(Language.JAVASCRIPT), Language.fromJudge0Id(63));
        assertEquals(Optional.of(Language.CPP), Language.fromJudge0Id(54));
    }

    /** Python moved from 71 (3.8) to 100 (3.12); events queued before the switch still say 71. */
    @Test
    void fromJudge0IdResolvesRetiredIdsToTheSameLanguage() {
        assertEquals(Optional.of(Language.PYTHON), Language.fromJudge0Id(71));
    }

    @Test
    void fromJudge0IdIsEmptyForUnknownIds() {
        assertTrue(Language.fromJudge0Id(999).isEmpty());
    }
}
