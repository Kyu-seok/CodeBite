package com.codebite.problem;

import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * n-queens lets a solution return its boards in any order, so every driver sorts them
 * (row by row, '.' before 'Q') before printing, and the judge compares that output exactly.
 * Each expected output must therefore list its boards in that same order, or no language can
 * pass (#78: sample test case 1 listed them in backtracking order). That every driver still
 * sorts is checked with the other sorting drivers in UnpassableTestDataTest.
 */
@SpringBootTest
@ActiveProfiles("test")
class NQueensBoardOrderTest {

    private static final String SLUG = "n-queens";

    @Autowired private ProblemRepository problemRepository;
    @Autowired private TestCaseRepository testCaseRepository;

    @Test
    void sampleForFiveQueensListsBoardsInTheDriversOrder() throws Exception {
        TestCase five = testCases().stream()
                .filter(tc -> tc.isSample() && tc.getInput().trim().equals("5"))
                .findFirst().orElseThrow();
        List<List<String>> boards = parse(five.getExpectedOutput());
        assertEquals(10, boards.size());
        assertEquals(List.of("....Q", "..Q..", "Q....", "...Q.", ".Q..."), boards.get(0));
        assertEquals(List.of("Q....", "..Q..", "....Q", ".Q...", "...Q."), boards.get(9));
    }

    @Test
    void everyExpectedOutputListsBoardsInTheDriversOrder() throws Exception {
        List<String> unsorted = new ArrayList<>();
        for (TestCase tc : testCases()) {
            if (!ListOrder.isStrictlyAscending(parse(tc.getExpectedOutput()))) {
                unsorted.add("test case " + tc.getOrderIndex() + " (n=" + tc.getInput().trim() + ")");
            }
        }
        assertTrue(unsorted.isEmpty(), "Boards not in the drivers' order: " + unsorted);
    }

    private List<TestCase> testCases() {
        Long problemId = problemRepository.findBySlug(SLUG).orElseThrow().getId();
        List<TestCase> cases = testCaseRepository.findByProblemIdOrderByOrderIndexAsc(problemId);
        assertFalse(cases.isEmpty(), "No test cases for " + SLUG);
        return cases;
    }

    private static List<List<String>> parse(String json) throws Exception {
        return new ObjectMapper().readValue(json, new TypeReference<>() {});
    }
}
