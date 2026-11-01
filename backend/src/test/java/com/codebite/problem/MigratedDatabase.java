package com.codebite.problem;

import org.flywaydb.core.Flyway;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * An H2 database in PostgreSQL mode that one test class runs the migrations on, apart from the
 * shared test database, which other tests empty. Each test class names its own.
 */
public final class MigratedDatabase {

    /** Reads one row of a query. */
    @FunctionalInterface
    public interface RowReader<T> {
        T read(ResultSet row) throws SQLException;
    }

    private final String url;

    public MigratedDatabase(String name) {
        this.url = "jdbc:h2:mem:" + name + ";MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
    }

    /** Flyway over every migration, or up to and including {@code target} when it is not null. */
    public Flyway flyway(String target) {
        var config = Flyway.configure().dataSource(url, "sa", "").locations("classpath:db/migration");
        return (target == null ? config : config.target(target)).load();
    }

    public MigratedDatabase migrate() {
        flyway(null).migrate();
        return this;
    }

    public <T> List<T> query(String sql, RowReader<T> reader, Object... params) throws SQLException {
        List<T> result = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(url, "sa", "");
             PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) statement.setObject(i + 1, params[i]);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) result.add(reader.read(rows));
            }
        }
        return result;
    }

    /** The first column of every row. */
    public List<String> strings(String sql, Object... params) throws SQLException {
        return query(sql, row -> row.getString(1), params);
    }

    /**
     * The text PostgreSQL stores for an {@code E'...'} literal, which H2 keeps unescaped: most
     * migrations write a multi-line Test Case input as {@code E'[1,3]\n10'}, which reaches H2 as
     * one line with a backslash in it.
     */
    public static String postgresText(String text) {
        if (text == null || text.indexOf('\\') < 0) return text;
        StringBuilder out = new StringBuilder(text.length());
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c != '\\' || i + 1 == text.length()) {
                out.append(c);
                continue;
            }
            char next = text.charAt(++i);
            switch (next) {
                case 'n' -> out.append('\n');
                case 't' -> out.append('\t');
                case 'r' -> out.append('\r');
                default -> out.append(next);
            }
        }
        return out.toString();
    }
}
