package com.codebite.problem;

import com.codebite.judge.service.DriverCodeLoader;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.ProblemTranslationRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Test data that contradicted its drivers or descriptions, so no correct solution could be
 * Accepted in any language (#90). Each problem's expected outputs must follow the order its
 * drivers print and the rules its description states, and the description's examples must
 * show the same outputs as the samples.
 */
@SpringBootTest
@ActiveProfiles("test")
class UnpassableTestDataTest {

    private static final ObjectMapper JSON = new ObjectMapper();

    @Autowired private ProblemRepository problemRepository;
    @Autowired private ProblemTranslationRepository translationRepository;
    @Autowired private TestCaseRepository testCaseRepository;

    // cafe-stop-orders: every driver sorts the permutations before printing.

    @Test
    void cafeStopOrdersSampleListsPermutationsInTheDriversOrder() {
        assertEquals("[[2,4,7],[2,7,4],[4,2,7],[4,7,2],[7,2,4],[7,4,2]]",
                sample("cafe-stop-orders", 1).getExpectedOutput());
    }

    @Test
    void everyCafeStopOrdersExpectedOutputIsSorted() throws Exception {
        List<String> unsorted = new ArrayList<>();
        for (TestCase tc : testCases("cafe-stop-orders")) {
            List<List<Integer>> orders = JSON.readValue(tc.getExpectedOutput(), new TypeReference<>() {});
            for (int i = 1; i < orders.size(); i++) {
                if (compareLists(orders.get(i - 1), orders.get(i)) >= 0) {
                    unsorted.add("test case " + tc.getOrderIndex());
                    break;
                }
            }
        }
        assertTrue(unsorted.isEmpty(), "Permutations not in the drivers' order: " + unsorted);
    }

    @Test
    void cafeStopOrdersExamplesShowTheSampleOutput() {
        String expected = sample("cafe-stop-orders", 1).getExpectedOutput();
        assertTrue(description("cafe-stop-orders").contains("Output: " + expected));
        assertTrue(korean("cafe-stop-orders").contains("출력: " + expected));
    }

    // merge-duplicate-contacts: every driver sorts each account's emails, then the accounts by
    // their first email.

    @Test
    void mergeDuplicateContactsSampleListsAccountsByFirstEmail() {
        assertEquals("[[\"Leo\",\"leo.grip@set.film\"],"
                        + "[\"Maya\",\"maya.dp@set.film\",\"mayalens@set.film\",\"mk.camera@set.film\"],"
                        + "[\"Maya\",\"maya.solo@set.film\"]]",
                sample("merge-duplicate-contacts", 1).getExpectedOutput());
    }

    @Test
    void everyMergeDuplicateContactsExpectedOutputIsInTheDriversOrder() throws Exception {
        List<String> unsorted = new ArrayList<>();
        for (TestCase tc : testCases("merge-duplicate-contacts")) {
            List<List<String>> accounts = JSON.readValue(tc.getExpectedOutput(), new TypeReference<>() {});
            boolean sorted = true;
            for (int i = 0; i < accounts.size(); i++) {
                List<String> emails = accounts.get(i).subList(1, accounts.get(i).size());
                for (int j = 1; j < emails.size(); j++) {
                    sorted &= emails.get(j - 1).compareTo(emails.get(j)) < 0;
                }
                if (i > 0) sorted &= accounts.get(i - 1).get(1).compareTo(accounts.get(i).get(1)) < 0;
            }
            if (!sorted) unsorted.add("test case " + tc.getOrderIndex());
        }
        assertTrue(unsorted.isEmpty(), "Accounts not in the drivers' order: " + unsorted);
    }

    @Test
    void mergeDuplicateContactsExamplesShowTheSampleOutput() {
        String expected = sample("merge-duplicate-contacts", 1).getExpectedOutput();
        assertTrue(description("merge-duplicate-contacts").contains("Output: " + expected));
        assertTrue(korean("merge-duplicate-contacts").contains("출력: " + expected));
    }

    // word-ladder: the answer counts both endpoints, so a one-letter step straight to endWord is 2.

    @Test
    void wordLadderSampleWithADirectStepExpectsTwoWords() {
        TestCase direct = sample("word-ladder", 1);
        // V124 wrote this input as E'pet\npot\n...'; H2 keeps the backslashes, PostgreSQL makes newlines.
        assertEquals("pet\npot\n[\"pit\",\"pot\",\"pat\"]", direct.getInput().strip().replace("\\n", "\n"));
        assertEquals("2", direct.getExpectedOutput().strip());
    }

    @Test
    void wordLadderDiagramDrawsExampleOnesShortestPath() {
        for (String text : List.of(description("word-ladder"), korean("word-ladder"))) {
            assertFalse(text.contains("\"pet\""), "diagram still draws pet -> pit -> pot");
            assertTrue(text.contains("highlight_path: [\"hit\",\"hot\",\"dot\",\"dog\",\"cog\"]"));
        }
    }

    // dog-street-walk: the description starts every walk at "HUB".

    @Test
    void dogStreetWalkSampleStartsAtHub() {
        TestCase tc = sample("dog-street-walk", 3);
        assertEquals("[[\"HUB\",\"KUL\"],[\"HUB\",\"NRT\"],[\"NRT\",\"HUB\"]]", tc.getInput().strip());
        assertEquals("[\"HUB\",\"NRT\",\"HUB\",\"KUL\"]", tc.getExpectedOutput().strip());
    }

    @Test
    void everyDogStreetWalkStartsAtHubAndUsesEverySegmentOnce() throws Exception {
        List<String> wrong = new ArrayList<>();
        for (TestCase tc : testCases("dog-street-walk")) {
            List<List<String>> routes = JSON.readValue(tc.getInput(), new TypeReference<>() {});
            List<String> walk = JSON.readValue(tc.getExpectedOutput(), new TypeReference<>() {});
            List<List<String>> unused = new ArrayList<>(routes);
            boolean ok = walk.get(0).equals("HUB") && walk.size() == routes.size() + 1;
            for (int i = 1; ok && i < walk.size(); i++) {
                ok = unused.remove(List.of(walk.get(i - 1), walk.get(i)));
            }
            if (!ok) wrong.add("test case " + tc.getOrderIndex());
        }
        assertTrue(wrong.isEmpty(), "Walks not starting at HUB or not using every segment once: " + wrong);
    }

    @ParameterizedTest
    @CsvSource({
            "merge-duplicate-contacts, python,   result.sort(key=lambda a: a[1])",
            "merge-duplicate-contacts, javascript, result.sort((a, b) => a[1] < b[1]",
            "merge-duplicate-contacts, java,       result.sort((a, b) -> a.get(1).compareTo(b.get(1)))",
            "merge-duplicate-contacts, cpp,        return a[1] < b[1];",
            "cafe-stop-orders, python,     result.sort()",
            "cafe-stop-orders, javascript, result.sort(",
            "cafe-stop-orders, java,       result.sort(",
            "cafe-stop-orders, cpp,        sort(result.begin(), result.end()",
    })
    void everyDriverSortsBeforePrinting(String slug, String language, String sortCall) throws Exception {
        DriverCodeLoader drivers = new DriverCodeLoader();
        drivers.loadTemplates();
        assertTrue(drivers.getDriverCode(slug, language).contains(sortCall),
                slug + " " + language + " driver no longer sorts");
    }

    private Problem problem(String slug) {
        return problemRepository.findBySlug(slug).orElseThrow();
    }

    private String description(String slug) {
        return problem(slug).getDescription();
    }

    private String korean(String slug) {
        return translationRepository.findByProblemIdAndLocale(problem(slug).getId(), "ko")
                .orElseThrow().getDescription();
    }

    private List<TestCase> testCases(String slug) {
        List<TestCase> cases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(problem(slug).getId());
        assertFalse(cases.isEmpty(), "No test cases for " + slug);
        return cases;
    }

    private TestCase sample(String slug, int orderIndex) {
        return testCases(slug).stream()
                .filter(tc -> tc.isSample() && tc.getOrderIndex() == orderIndex)
                .findFirst().orElseThrow();
    }

    private static <T extends Comparable<T>> int compareLists(List<T> a, List<T> b) {
        for (int i = 0; i < Math.min(a.size(), b.size()); i++) {
            int cmp = a.get(i).compareTo(b.get(i));
            if (cmp != 0) return cmp;
        }
        return Integer.compare(a.size(), b.size());
    }
}
