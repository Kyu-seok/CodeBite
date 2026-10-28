package com.codebite.review.service;

import com.codebite.review.entity.Confidence;
import com.codebite.review.entity.ProblemReviewState;
import com.codebite.submission.entity.Submission;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * The golden record of SM-2 lite as the pre-refactor code computes it:
 * {@link ProblemReviewState#applyReview} for the six schedule fields and
 * {@link ReviewService#isMastered} for the mastered flag, over a fixed set of Review histories.
 *
 * <p>The first run writes {@code common/src/test/resources/review-schedule-golden.csv}; every later
 * run regenerates the rows and requires the file to be byte-identical, so the arithmetic cannot
 * drift while it moves into {@code ReviewSchedule}. The common module's {@code ReviewScheduleGoldenTest}
 * replays the same file through the new value. Do not delete the file to "refresh" it: it must keep
 * describing the schedules existing users were given.
 *
 * <p>CSV columns: {@code case,history,review_count,ease,interval_days,last_confidence,
 * last_reviewed_at,next_due_at,mastered}. {@code history} is {@code CONFIDENCE@instant} entries
 * joined by {@code |}, in the order the repository would return them (reviewed_at ascending);
 * an empty history is the "no row" case.
 */
class ReviewScheduleGoldenCsvTest {

    static final Path GOLDEN_CSV = Path.of("..", "common", "src", "test", "resources",
            "review-schedule-golden.csv");

    private static final Instant T0 = Instant.parse("2026-01-01T00:00:00Z");
    private static final int RANDOM_CASES = 200;
    private static final int MAX_RANDOM_LENGTH = 40;
    private static final long SEED = 20261028L;

    @Test
    void theCurrentCodeReproducesTheGoldenCsv() throws IOException {
        String generated = render(cases());

        assertTrue(Files.isDirectory(GOLDEN_CSV.getParent()),
                "run from the backend module directory; missing " + GOLDEN_CSV.toAbsolutePath());
        if (!Files.exists(GOLDEN_CSV)) {
            Files.writeString(GOLDEN_CSV, generated, StandardCharsets.UTF_8);
            return;
        }
        String committed = Files.readString(GOLDEN_CSV, StandardCharsets.UTF_8);
        assertEquals(committed, generated,
                "the SM-2 lite arithmetic no longer reproduces " + GOLDEN_CSV);
    }

    // ---- cases ----

    record Review(Confidence confidence, Instant at) {}

    record Case(String name, List<Review> history) {}

    static List<Case> cases() {
        List<Case> out = new ArrayList<>();
        out.add(new Case("none", List.of()));

        for (Confidence c : Confidence.values()) {
            out.add(new Case("first-" + c, daily(c)));
        }
        for (Confidence a : Confidence.values()) {
            for (Confidence b : Confidence.values()) {
                out.add(new Case("second-" + a + "-" + b, daily(a, b)));
            }
        }
        for (Confidence a : Confidence.values()) {
            for (Confidence b : Confidence.values()) {
                out.add(new Case("third-after-GOOD-GOOD-" + a + "-" + b,
                        daily(Confidence.GOOD, Confidence.GOOD, a, b)));
            }
        }

        out.add(new Case("good-x3-not-yet-mastered", repeat(Confidence.GOOD, 3)));
        out.add(new Case("good-x4-mastered", repeat(Confidence.GOOD, 4)));
        out.add(new Case("easy-x3-mastered-at-35", repeat(Confidence.EASY, 3)));
        out.add(new Case("good-x4-then-hard-last-two-not-good",
                daily(Confidence.GOOD, Confidence.GOOD, Confidence.GOOD, Confidence.GOOD, Confidence.HARD)));
        out.add(new Case("good-x4-hard-good-last-two-not-both-good",
                daily(Confidence.GOOD, Confidence.GOOD, Confidence.GOOD, Confidence.GOOD,
                        Confidence.HARD, Confidence.GOOD)));
        out.add(new Case("good-x4-again-good-good-interval-too-short",
                daily(Confidence.GOOD, Confidence.GOOD, Confidence.GOOD, Confidence.GOOD,
                        Confidence.AGAIN, Confidence.GOOD, Confidence.GOOD)));
        out.add(new Case("again-x2-then-good-x6",
                concat(repeat(Confidence.AGAIN, 2), repeat(Confidence.GOOD, 6))));
        out.add(new Case("good-x6-again-hard-x3",
                concat(repeat(Confidence.GOOD, 6), repeat(Confidence.AGAIN, 1), repeat(Confidence.HARD, 3))));
        out.add(new Case("hard-x10-ease-floor-by-hard", repeat(Confidence.HARD, 10)));
        out.add(new Case("again-x25-ease-floor", repeat(Confidence.AGAIN, 25)));
        out.add(new Case("easy-x25-ease-ceiling", repeat(Confidence.EASY, 25)));
        out.add(new Case("easy-x45-interval-cap", repeat(Confidence.EASY, 45)));
        out.add(new Case("easy-x45-then-again", concat(repeat(Confidence.EASY, 45), repeat(Confidence.AGAIN, 1))));
        out.add(new Case("easy-x45-then-hard", concat(repeat(Confidence.EASY, 45), repeat(Confidence.HARD, 1))));
        out.add(new Case("easy-x45-then-good", concat(repeat(Confidence.EASY, 45), repeat(Confidence.GOOD, 1))));
        out.add(new Case("easy-x45-again-easy-x45", concat(repeat(Confidence.EASY, 45),
                repeat(Confidence.AGAIN, 1), repeat(Confidence.EASY, 45))));
        out.add(new Case("same-instant-good-hard-easy", List.of(
                new Review(Confidence.GOOD, T0), new Review(Confidence.HARD, T0), new Review(Confidence.EASY, T0))));
        out.add(new Case("millis-in-timestamps", List.of(
                new Review(Confidence.GOOD, Instant.parse("2026-03-04T05:06:07.123Z")),
                new Review(Confidence.EASY, Instant.parse("2026-03-09T10:11:12.456Z")),
                new Review(Confidence.GOOD, Instant.parse("2026-03-30T23:59:59.999Z")))));
        out.add(new Case("spread-at-one-day", daily(Confidence.GOOD, Confidence.GOOD, Confidence.AGAIN,
                Confidence.HARD, Confidence.GOOD, Confidence.EASY)));

        Random random = new Random(SEED);
        Profile[] profiles = Profile.values();
        for (int i = 0; i < RANDOM_CASES; i++) {
            Profile profile = profiles[i % profiles.length];
            int length = random.nextInt(MAX_RANDOM_LENGTH + 1);
            List<Review> history = new ArrayList<>();
            Instant at = T0.plus(random.nextInt(365), ChronoUnit.DAYS).plusSeconds(random.nextInt(86400));
            for (int k = 0; k < length; k++) {
                history.add(new Review(profile.pick(random), at));
                // Gaps from zero (same instant) to a few months; only the order matters to the
                // arithmetic, the moments only to last_reviewed_at and next_due_at.
                at = at.plus(random.nextInt(4) == 0 ? 0 : random.nextInt(120), ChronoUnit.DAYS)
                        .plusSeconds(random.nextInt(4) == 0 ? 0 : random.nextInt(86400));
            }
            out.add(new Case(String.format("random-%03d-%s", i, profile.name().toLowerCase()), history));
        }
        return out;
    }

    /** How a random history leans, so the fixtures reach ease and interval extremes. */
    enum Profile {
        UNIFORM(25, 25, 25, 25),
        EASY_HEAVY(5, 10, 25, 60),
        GOOD_HEAVY(5, 15, 65, 15),
        HARD_HEAVY(10, 60, 20, 10),
        AGAIN_HEAVY(55, 15, 20, 10);

        private final int[] weights;

        Profile(int again, int hard, int good, int easy) {
            this.weights = new int[] {again, hard, good, easy};
        }

        Confidence pick(Random random) {
            int roll = random.nextInt(100);
            Confidence[] values = Confidence.values();
            for (int i = 0; i < values.length; i++) {
                roll -= weights[i];
                if (roll < 0) return values[i];
            }
            return values[values.length - 1];
        }
    }

    private static List<Review> daily(Confidence... confidences) {
        List<Review> out = new ArrayList<>();
        for (int i = 0; i < confidences.length; i++) {
            out.add(new Review(confidences[i], T0.plus(i, ChronoUnit.DAYS)));
        }
        return out;
    }

    private static List<Review> repeat(Confidence c, int times) {
        Confidence[] cs = new Confidence[times];
        Arrays.fill(cs, c);
        return daily(cs);
    }

    @SafeVarargs
    private static List<Review> concat(List<Review>... parts) {
        List<Confidence> cs = new ArrayList<>();
        for (List<Review> part : parts) {
            for (Review r : part) cs.add(r.confidence());
        }
        return daily(cs.toArray(new Confidence[0]));
    }

    // ---- the pre-refactor computation ----

    static String render(List<Case> cases) {
        StringBuilder sb = new StringBuilder();
        sb.append("case,history,review_count,ease,interval_days,last_confidence,")
                .append("last_reviewed_at,next_due_at,mastered\n");
        for (Case c : cases) {
            ProblemReviewState state = ProblemReviewState.newFor(1L, 1L);
            List<Submission> rated = new ArrayList<>();
            for (Review r : c.history()) {
                state.applyReview(r.confidence(), r.at());
                Submission s = new Submission();
                s.setConfidence(r.confidence());
                s.setReviewedAt(r.at());
                rated.add(s);
            }
            boolean mastered = ReviewService.isMastered(Collections.unmodifiableList(rated), state);
            String history = c.history().stream()
                    .map(r -> r.confidence() + "@" + r.at())
                    .collect(Collectors.joining("|"));
            sb.append(c.name()).append(',')
                    .append(history).append(',')
                    .append(state.getReviewCount()).append(',')
                    .append(state.getEaseFactor().toPlainString()).append(',')
                    .append(state.getIntervalDays()).append(',')
                    .append(state.getLastConfidence() == null ? "" : state.getLastConfidence().name()).append(',')
                    .append(state.getLastReviewedAt() == null ? "" : state.getLastReviewedAt().toString()).append(',')
                    .append(state.getNextDueAt() == null ? "" : state.getNextDueAt().toString()).append(',')
                    .append(mastered).append('\n');
        }
        return sb.toString();
    }
}
