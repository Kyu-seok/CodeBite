package com.codebite.sitemap;

import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.repository.ProblemRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.matchesPattern;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class SitemapControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ProblemRepository problemRepository;

    @Test
    void listsTheStaticPagesAndEveryPublishedProblem_withoutSigningIn() throws Exception {
        String slug = problemRepository.findSitemapEntries().get(0).slug();

        mockMvc.perform(get("/api/sitemap.xml"))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Type", containsString("application/xml")))
                .andExpect(header().string("Cache-Control", containsString("max-age=3600")))
                .andExpect(content().string(containsString("<loc>https://code-bite.test/</loc>")))
                .andExpect(content().string(containsString("<loc>https://code-bite.test/problems</loc>")))
                .andExpect(content().string(containsString("<loc>https://code-bite.test/roadmap</loc>")))
                .andExpect(content().string(containsString("<loc>https://code-bite.test/problems/" + slug + "</loc>")))
                .andExpect(content().string(matchesPattern("(?s).*<lastmod>\\d{4}-\\d{2}-\\d{2}</lastmod>.*")));
    }

    @Test
    void leavesOutAnUnpublishedProblem() throws Exception {
        Problem draft = new Problem();
        draft.setTitle("Draft");
        draft.setSlug("sitemap-draft-problem");
        draft.setDescription("Not yet published");
        draft.setDifficulty(Difficulty.EASY);
        draft.setPublished(false);
        problemRepository.save(draft);

        mockMvc.perform(get("/api/sitemap.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("sitemap-draft-problem"))));
    }
}
