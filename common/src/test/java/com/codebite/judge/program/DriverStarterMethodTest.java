package com.codebite.judge.program;

import com.codebite.judge.Language;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

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

    private static final ProblemAssets ASSETS = new ProblemAssets();

    @ParameterizedTest
    @CsvSource(delimiter = '|', value = {
            "PYTHON     | (?<!\\w)Solution\\(\\)\\.(\\w+)\\( | def\\s+%s\\s*\\(",
            "JAVASCRIPT | new Solution\\(\\)\\.(\\w+)\\(     | (?m)^\\s*%s\\s*\\(",
    })
    void everyDriverCallsAMethodItsStarterDefines(Language language, String call, String definition) {
        Pattern driverCall = Pattern.compile(call);
        List<String> mismatches = new ArrayList<>();
        int checked = 0;
        assertFalse(ASSETS.slugsWithDriver(language).isEmpty(), "No " + language.code() + " drivers found");
        for (String slug : ASSETS.slugsWithDriver(language)) {
            String driver = ASSETS.assemble(slug, language, "").source();
            if (!driver.contains("Solution")) continue; // class-design problems construct their own class
            String starter = ASSETS.starters(slug).get(language);
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
        assertTrue(checked > 0, "No " + language.code() + " driver calls found");
        assertTrue(mismatches.isEmpty(),
                language.code() + " drivers out of step with their starters: " + mismatches);
    }
}
