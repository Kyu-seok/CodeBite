package com.codebite.review.schedule;

import com.codebite.review.entity.Confidence;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Replays the golden Review histories in {@code review-schedule-golden.csv} through
 * {@link ReviewSchedule#replay} and requires every field to match what the pre-refactor code
 * ({@code ProblemReviewState.applyReview} + {@code ReviewService.isMastered}, at commit 0d144e1)
 * wrote there. Existing users' intervals and due dates come from that code, so the file is not
 * regenerated: a deliberate change to the algorithm needs a new file and a decision on how the
 * stored rows are rebuilt (docs/SYSTEM_DESIGN.md, "Spaced-Repetition Reviews").
 */
class ReviewScheduleGoldenTest {

    private static final String GOLDEN_CSV = "/review-schedule-golden.csv";

    record Row(String name, List<Review> history, int reviewCount, String ease, int intervalDays,
               String lastConfidence, String lastReviewedAt, String nextDueAt, boolean mastered) {}

    @TestFactory
    Stream<DynamicTest> replayMatchesTheGoldenFile() throws IOException {
        List<Row> rows = rows();
        assertTrue(rows.size() >= 200, "golden file is suspiciously short: " + rows.size() + " rows");
        return rows.stream().map(row -> DynamicTest.dynamicTest(row.name(), () -> {
            ReviewSchedule s = ReviewSchedule.replay(row.history());
            assertAll(row.name(),
                    () -> assertEquals(row.reviewCount(), s.reviewCount(), "reviewCount"),
                    () -> assertEquals(row.ease(), s.ease().toPlainString(), "ease"),
                    () -> assertEquals(row.intervalDays(), s.intervalDays(), "intervalDays"),
                    () -> assertEquals(row.lastConfidence(), text(s.lastConfidence()), "lastConfidence"),
                    () -> assertEquals(row.lastReviewedAt(), text(s.lastReviewedAt()), "lastReviewedAt"),
                    () -> assertEquals(row.nextDueAt(), text(s.nextDueAt()), "nextDueAt"),
                    () -> assertEquals(row.mastered(), s.mastered(), "mastered"),
                    () -> assertEquals(row.history().isEmpty(), s.isEmpty(), "isEmpty"));
        }));
    }

    private static String text(Object value) {
        return value == null ? "" : value.toString();
    }

    static List<Row> rows() throws IOException {
        InputStream in = ReviewScheduleGoldenTest.class.getResourceAsStream(GOLDEN_CSV);
        assertNotNull(in, GOLDEN_CSV + " is missing from the test resources");
        List<Row> rows = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8))) {
            String header = reader.readLine();
            assertEquals("case,history,review_count,ease,interval_days,last_confidence,"
                    + "last_reviewed_at,next_due_at,mastered", header, "golden file header");
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.isBlank()) continue;
                String[] f = line.split(",", -1);
                assertEquals(9, f.length, "columns in: " + line);
                rows.add(new Row(f[0], history(f[1]), Integer.parseInt(f[2]), f[3], Integer.parseInt(f[4]),
                        f[5], f[6], f[7], Boolean.parseBoolean(f[8])));
            }
        }
        return rows;
    }

    private static List<Review> history(String field) {
        List<Review> reviews = new ArrayList<>();
        if (field.isEmpty()) return reviews;
        for (String entry : field.split("\\|")) {
            int at = entry.indexOf('@');
            reviews.add(new Review(Confidence.valueOf(entry.substring(0, at)),
                    Instant.parse(entry.substring(at + 1))));
        }
        return reviews;
    }
}
