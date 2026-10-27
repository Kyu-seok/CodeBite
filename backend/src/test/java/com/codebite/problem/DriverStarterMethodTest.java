package com.codebite.problem;

import com.codebite.judge.service.DriverCodeLoader;
import com.codebite.problem.service.StarterCodeLoader;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Every Python and JavaScript driver that uses {@code Solution} must call a method the problem's
 * starter defines; otherwise every Run and Submit ends in a runtime error. Java and C++ need no
 * check: a wrong name there fails to compile.
 */
class DriverStarterMethodTest {

    private DriverCodeLoader drivers;
    private StarterCodeLoader starters;

    @BeforeEach
    void setUp() throws Exception {
        drivers = new DriverCodeLoader();
        drivers.loadTemplates();
        starters = new StarterCodeLoader();
        starters.loadStarterCode();
    }

    @ParameterizedTest
    @CsvSource(delimiter = '|', value = {
            "python     | .py | (?<!\\w)Solution\\(\\)\\.(\\w+)\\( | def\\s+%s\\s*\\(",
            "javascript | .js | new Solution\\(\\)\\.(\\w+)\\(     | (?m)^\\s*%s\\s*\\(",
    })
    void everyDriverCallsAMethodItsStarterDefines(String language, String ext, String call, String definition)
            throws Exception {
        Pattern driverCall = Pattern.compile(call);
        List<String> mismatches = new ArrayList<>();
        int checked = 0;
        for (String slug : driverSlugs(language, ext)) {
            String driver = drivers.getDriverCode(slug, language);
            if (!driver.contains("Solution")) continue; // class-design problems construct their own class
            String starter = starters.getStarterCode(slug).get(language);
            if (starter == null) {
                mismatches.add(slug + " has no starter");
                continue;
            }
            Matcher calls = driverCall.matcher(driver);
            if (!calls.find()) {
                mismatches.add(slug + " uses Solution without a call this test recognises");
                continue;
            }
            do {
                checked++;
                String method = calls.group(1);
                if (!Pattern.compile(String.format(definition, method)).matcher(starter).find()) {
                    mismatches.add(slug + " calls " + method);
                }
            } while (calls.find());
        }
        assertTrue(checked > 0, "No " + language + " driver calls found");
        assertTrue(mismatches.isEmpty(), language + " drivers out of step with their starters: " + mismatches);
    }

    private List<String> driverSlugs(String language, String ext) throws Exception {
        List<String> slugs = new ArrayList<>();
        Resource[] resources = new PathMatchingResourcePatternResolver()
                .getResources("classpath:drivers/*/" + language + ext);
        for (Resource resource : resources) {
            String[] segments = resource.getURL().getPath().split("/");
            slugs.add(segments[segments.length - 2]);
        }
        assertFalse(slugs.isEmpty(), "No " + language + " drivers found");
        return slugs;
    }
}
