package com.codebite.migrate;

import org.flywaydb.core.Flyway;

/**
 * Runs this checkout's Flyway migrations, SQL and Java, against one database and exits: what the
 * backend's Flyway does on start, without the backend. {@code scripts/dev-branch-servers.sh migrate}
 * runs it through {@code ./gradlew :common:migrateDatabase}. Its own source set, so no jar ships it.
 *
 * <p>Arguments: the JDBC URL, the user and the password.
 */
public final class MigrateBranchDatabase {

    private MigrateBranchDatabase() {
    }

    public static void main(String[] args) {
        if (args.length != 3 || args[0].isBlank()) {
            System.err.println("usage: MigrateBranchDatabase <jdbc-url> <user> <password>");
            System.exit(2);
        }
        // Spring Boot's defaults for the backend's Flyway are Flyway's own: classpath:db/migration,
        // which holds both the SQL files and the db.migration Java classes.
        var result = Flyway.configure()
                .dataSource(args[0], args[1], args[2])
                .load()
                .migrate();
        System.out.println("applied " + result.migrationsExecuted + " migration(s)");
    }
}
