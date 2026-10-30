package com.codebite.problem;

import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.MigrationInfo;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every {@code slug = '…'} a migration names is a Slug when that migration runs. An UPDATE whose
 * {@code WHERE slug = …} matches nothing succeeds silently, e.g. a Restatement written against a
 * Slug another branch has since Restated, so this applies the migrations one at a time and checks
 * each one's references against the slugs that exist just before or just after it.
 *
 * <p>Slugs of tags and roadmap categories count too: the pattern can't tell the tables apart. Former
 * Slugs don't: naming one is exactly the mistake this catches.
 */
class MigrationSlugReferencesTest {

    private static final String URL =
            "jdbc:h2:mem:migration-slug-references;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
    private static final Pattern SLUG_REFERENCE =
            Pattern.compile("(?i)(?<![\\w])slug\\s*=\\s*(?:'([^']+)'|\\$\\$([^$]+)\\$\\$)");
    private static final List<String> SLUG_TABLES =
            List.of("problems", "tags", "roadmap_categories");
    /** Applied migrations that matched nothing; they can't be edited, so they are exempt by name. */
    private static final Map<String, String> KNOWN_NO_OPS = Map.of(
            "V140__restyle_design_narratives_dollar_quotes.sql",
            "re-quotes V127 after V134 renamed its problems; a no-op by its own header",
            "V177__diagram_poc_tree.sql",
            "named invert-binary-tree, by then mirror-menu-tree; V178 re-applied it");

    @Test
    void everySlugAMigrationNamesExistsWhenItRuns() throws Exception {
        MigrationInfo[] migrations = flyway(null).info().pending();
        List<String> missing = new ArrayList<>();
        for (MigrationInfo migration : migrations) {
            Set<String> known = slugs();
            flyway(migration.getVersion().getVersion()).migrate();
            known.addAll(slugs());
            if (KNOWN_NO_OPS.containsKey(migration.getScript())) continue;
            for (String slug : references(migration.getScript())) {
                if (!known.contains(slug)) missing.add(migration.getScript() + ": " + slug);
            }
        }
        assertTrue(missing.isEmpty(), "Migrations naming a slug no problem, tag or roadmap category has "
                + "when they run, so their statements match nothing (Restated on another branch?): " + missing);
    }

    private static Flyway flyway(String target) {
        var config = Flyway.configure().dataSource(URL, "sa", "").locations("classpath:db/migration");
        return (target == null ? config : config.target(target)).load();
    }

    private static Set<String> references(String script) throws IOException {
        Set<String> slugs = new HashSet<>();
        if (!script.endsWith(".sql")) return slugs; // a Java migration, e.g. V182
        try (InputStream in = MigrationSlugReferencesTest.class.getResourceAsStream("/db/migration/" + script)) {
            Matcher matcher = SLUG_REFERENCE.matcher(new String(in.readAllBytes(), StandardCharsets.UTF_8));
            while (matcher.find()) slugs.add(matcher.group(1) != null ? matcher.group(1) : matcher.group(2));
        }
        return slugs;
    }

    private static Set<String> slugs() throws SQLException {
        Set<String> slugs = new HashSet<>();
        try (Connection connection = DriverManager.getConnection(URL, "sa", "");
             Statement statement = connection.createStatement()) {
            for (String table : SLUG_TABLES) {
                try (ResultSet rows = statement.executeQuery("SELECT slug FROM " + table)) {
                    while (rows.next()) slugs.add(rows.getString(1));
                } catch (SQLException tableNotYetCreated) {
                    // the migration that creates it hasn't run yet
                }
            }
        }
        return slugs;
    }
}
