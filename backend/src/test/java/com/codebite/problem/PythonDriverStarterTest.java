package com.codebite.problem;

import com.codebite.judge.service.DriverCodeLoader;
import com.codebite.problem.service.StarterCodeLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every Python driver that calls {@code Solution().method(...)} must call a method the
 * problem's Python starter defines; otherwise every Run and Submit ends in an AttributeError.
 */
class PythonDriverStarterTest {

    private static final Pattern DRIVER_CALL = Pattern.compile("Solution\\(\\)\\.(\\w+)\\(");

    private DriverCodeLoader drivers;
    private StarterCodeLoader starters;

    @BeforeEach
    void setUp() throws Exception {
        drivers = new DriverCodeLoader();
        drivers.loadTemplates();
        starters = new StarterCodeLoader();
        starters.loadStarterCode();
    }

    @Test
    void everyPythonDriverCallsAMethodItsStarterDefines() throws Exception {
        List<String> mismatches = new ArrayList<>();
        int checked = 0;
        for (String slug : pythonDriverSlugs()) {
            String starter = starters.getStarterCode(slug).get("python");
            if (starter == null) continue;
            Matcher call = DRIVER_CALL.matcher(drivers.getDriverCode(slug, "python"));
            while (call.find()) {
                checked++;
                String method = call.group(1);
                if (!Pattern.compile("def\\s+" + method + "\\s*\\(").matcher(starter).find()) {
                    mismatches.add(slug + " calls " + method);
                }
            }
        }
        assertTrue(checked > 0, "No Python driver calls found");
        assertTrue(mismatches.isEmpty(), "Python drivers call methods their starters don't define: " + mismatches);
    }

    @Test
    void everyPythonDriverHasAStarter() throws Exception {
        List<String> slugs = pythonDriverSlugs();
        assertFalse(slugs.isEmpty());
        for (String slug : slugs) {
            assertTrue(starters.getStarterCode(slug).containsKey("python"), slug + " has no Python starter");
        }
    }

    private List<String> pythonDriverSlugs() throws Exception {
        List<String> slugs = new ArrayList<>();
        for (Resource resource : new PathMatchingResourcePatternResolver().getResources("classpath:drivers/*/python.py")) {
            String[] segments = resource.getURL().getPath().split("/");
            slugs.add(segments[segments.length - 2]);
        }
        return slugs;
    }
}
