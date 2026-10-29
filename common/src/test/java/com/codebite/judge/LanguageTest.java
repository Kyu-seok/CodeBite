package com.codebite.judge;

import com.codebite.common.exception.UnsupportedValueException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
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
    void ofRequestReadsTheCodeAndAnswersAnUnacceptedOneWith400() {
        assertEquals(Language.CPP, Language.ofRequest("CPP"));
        UnsupportedValueException e = assertThrows(UnsupportedValueException.class, () -> Language.ofRequest("C"));
        assertEquals("error.language.unsupported", e.getMessageCode());
        assertArrayEquals(new Object[]{"c"}, e.getMessageArgs());
        assertThrows(UnsupportedValueException.class, () -> Language.ofRequest(null));
    }
}
