package com.codebite.problem;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * English lives only on {@code problems}: {@code problem_translations} holds the other languages,
 * and refuses an {@code en} row, which nothing would read and which would drift from {@code problems}.
 */
class ProblemTranslationsTest {

    private static final MigratedDatabase DATABASE = new MigratedDatabase("problem-translations");
    /** The last migration before the {@code en} rows were deleted. */
    private static final String BEFORE_DELETION = "593";

    private static long koreanBefore;

    @BeforeAll
    static void migrate() throws SQLException {
        DATABASE.flyway(BEFORE_DELETION).migrate();
        assertTrue(count("en") > 0, "the migrations up to V" + BEFORE_DELETION + " should leave en rows to delete");
        koreanBefore = count("ko");
        DATABASE.migrate();
    }

    @Test
    void noEnglishRowIsLeft() throws SQLException {
        assertEquals(0, count("en"));
    }

    @Test
    void everyKoreanRowStays() throws SQLException {
        assertTrue(koreanBefore > 0);
        assertEquals(koreanBefore, count("ko"));
    }

    @Test
    void anEnglishRowIsRefused() {
        SQLException refused = assertThrows(SQLException.class, () -> DATABASE.execute("""
                INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
                SELECT id, 'en', title, description, constraints FROM problems WHERE slug = 'snack-drawer-pair'"""));
        assertTrue(refused.getMessage().toLowerCase().contains("problem_translations_locale_not_en"),
                "refused by something other than the locale check: " + refused.getMessage());
    }

    private static long count(String locale) throws SQLException {
        return Long.parseLong(DATABASE.strings(
                "SELECT COUNT(*) FROM problem_translations WHERE locale = ?", locale).get(0));
    }
}
