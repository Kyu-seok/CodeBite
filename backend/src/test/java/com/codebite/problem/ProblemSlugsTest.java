package com.codebite.problem;

import com.codebite.judge.Language;
import com.codebite.judge.program.ProblemAssets;
import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * The Slugs every migration leaves behind against the Driver and Starter Code directories filed
 * under them, so a Restatement that moves one without the other fails here rather than in
 * production (a problem nobody can Run or Submit, or an editor with no Starter Code).
 *
 * <p>Runs the migrations on its own H2 database: the shared test database is emptied by other tests.
 */
class ProblemSlugsTest {

    private static final String URL =
            "jdbc:h2:mem:problem-slugs;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
    private static final ProblemAssets ASSETS = new ProblemAssets();

    private static Set<String> slugs;
    private static Set<String> formerSlugs;

    @BeforeAll
    static void migrate() throws SQLException {
        Flyway.configure().dataSource(URL, "sa", "").locations("classpath:db/migration").load().migrate();
        slugs = query("SELECT slug FROM problems");
        formerSlugs = query("SELECT slug FROM problem_former_slugs");
        assertFalse(slugs.isEmpty(), "No problems after the migrations");
    }

    @Test
    void everyProblemHasADriverAndStarterCodeInEveryLanguage() {
        List<String> missing = new ArrayList<>();
        for (String slug : slugs) {
            Set<Language> starters = ASSETS.starters(slug).keySet();
            for (Language language : Language.values()) {
                if (!ASSETS.hasDriver(slug, language)) missing.add(slug + ": no " + language.code() + " Driver");
                if (!starters.contains(language)) missing.add(slug + ": no " + language.code() + " Starter Code");
            }
        }
        assertTrue(missing.isEmpty(), "Assets missing for a problem's Slug (a Restatement without "
                + "the git mv of drivers/<slug>/ and starters/<slug>/?): " + missing);
    }

    @Test
    void everyDriverIsFiledUnderAProblemsSlug() {
        Set<String> orphans = new TreeSet<>();
        for (Language language : Language.values()) {
            ASSETS.slugsWithDriver(language).stream().filter(slug -> !slugs.contains(slug)).forEach(orphans::add);
        }
        assertTrue(orphans.isEmpty(), "Drivers no problem has as its Slug (a directory renamed "
                + "without its Restatement migration, or a Former Slug left behind?): " + orphans);
    }

    @Test
    void noFormerSlugIsACurrentSlug() {
        Set<String> clashes = new TreeSet<>(formerSlugs);
        clashes.retainAll(slugs);
        assertTrue(clashes.isEmpty(), "Former Slugs that are also a problem's Slug: " + clashes);
    }

    private static Set<String> query(String sql) throws SQLException {
        Set<String> result = new TreeSet<>();
        try (Connection connection = DriverManager.getConnection(URL, "sa", "");
             Statement statement = connection.createStatement();
             ResultSet rows = statement.executeQuery(sql)) {
            while (rows.next()) result.add(rows.getString(1));
        }
        return result;
    }
}
