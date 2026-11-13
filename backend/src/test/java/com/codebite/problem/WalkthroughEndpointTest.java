package com.codebite.problem;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * {@code GET /api/problems/{slug}/walkthrough} and {@code ProblemDetail.hasWalkthrough}, against the
 * committed {@code walkthroughs/} files: {@code rotting-donuts} has one. A problem without one is
 * {@code rotting-donuts} renamed in the test to a Slug no file is named for, since every problem is
 * meant to get a Walkthrough in time.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class WalkthroughEndpointTest {

    private static final String WITHOUT_WALKTHROUGH = "a-problem-with-no-walkthrough";

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JdbcTemplate jdbc;

    @Test
    void aProblemWithAWalkthroughServesItWithoutAToken() throws Exception {
        mockMvc.perform(get("/api/problems/rotting-donuts/walkthrough"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.format").value("walkthrough/1"))
                .andExpect(jsonPath("$.runs[0].label.en").value("Example 1"));
    }

    @Test
    void aFormerSlugServesTheCurrentSlugsWalkthrough() throws Exception {
        jdbc.update("INSERT INTO problem_former_slugs (slug, problem_id) "
                + "SELECT 'rotting-oranges-old', id FROM problems WHERE slug = 'rotting-donuts'");

        mockMvc.perform(get("/api/problems/rotting-oranges-old/walkthrough"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.format").value("walkthrough/1"));
    }

    private void renameRottingDonutsToASlugWithNoFile() {
        jdbc.update("UPDATE problems SET slug = ? WHERE slug = 'rotting-donuts'", WITHOUT_WALKTHROUGH);
    }

    @Test
    void aProblemWithoutAWalkthroughIs404() throws Exception {
        renameRottingDonutsToASlugWithNoFile();

        mockMvc.perform(get("/api/problems/" + WITHOUT_WALKTHROUGH + "/walkthrough"))
                .andExpect(status().isNotFound());
    }

    @Test
    void anUnknownSlugIs404() throws Exception {
        mockMvc.perform(get("/api/problems/nonexistent/walkthrough"))
                .andExpect(status().isNotFound());
    }

    @Test
    void anUnpublishedProblemIs404AsTheProblemReadIs() throws Exception {
        jdbc.update("UPDATE problems SET is_published = false WHERE slug = 'rotting-donuts'");

        mockMvc.perform(get("/api/problems/rotting-donuts"))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/problems/rotting-donuts/walkthrough"))
                .andExpect(status().isNotFound());
    }

    @Test
    void theDetailSaysAProblemHasAWalkthrough() throws Exception {
        mockMvc.perform(get("/api/problems/rotting-donuts"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.hasWalkthrough").value(true));
    }

    @Test
    void theDetailSaysAProblemHasNoWalkthrough() throws Exception {
        renameRottingDonutsToASlugWithNoFile();
        mockMvc.perform(get("/api/problems/" + WITHOUT_WALKTHROUGH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.hasWalkthrough").value(false));
    }
}
