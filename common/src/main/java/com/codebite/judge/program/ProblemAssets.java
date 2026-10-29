package com.codebite.judge.program;

import com.codebite.common.exception.NoDriverException;
import com.codebite.judge.Language;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Every problem's Drivers and Starter Code, read once from the classpath: {@code drivers/<slug>/},
 * the Libraries under {@code drivers/lib/<language>/}, and {@code starters/<slug>/}, each file
 * named {@code <language code>.<extension>}.
 *
 * <p>Library markers are resolved and every Driver is checked for its {@code {USER_CODE}}
 * placeholder at load, so a broken Driver fails startup rather than a request.
 */
@Service
public class ProblemAssets {

    private static final Logger log = LoggerFactory.getLogger(ProblemAssets.class);

    private static final String PLACEHOLDER = "{USER_CODE}";
    private static final Pattern LIB_MARKER_PATTERN =
            Pattern.compile("^(?://|#)\\s*\\{\\{LIB:(\\w+)}}$", Pattern.MULTILINE);

    private final PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
    private final String root;
    private final Map<Language, Map<String, Driver>> drivers = new EnumMap<>(Language.class);
    private final Map<Language, Map<String, String>> starters = new EnumMap<>(Language.class);

    /** A Driver with its Libraries spliced in, and the line its placeholder is on. */
    private record Driver(String template, int userCodeStartLine) {
    }

    public ProblemAssets() {
        this("classpath:");
    }

    /** Reads from {@code root} instead of the classpath root, e.g. {@code classpath:fixtures/}. */
    public ProblemAssets(String root) {
        this.root = root;
        try {
            for (Language language : Language.values()) {
                Map<String, String> libraries = scanLibraries(language);
                Map<String, Driver> bySlug = new HashMap<>();
                scan("drivers", language).forEach((slug, text) ->
                        bySlug.put(slug, toDriver(slug, language, resolveLibMarkers(text, language, libraries))));
                drivers.put(language, bySlug);
                starters.put(language, scan("starters", language));
            }
        } catch (IOException e) {
            throw new UncheckedIOException("Could not read problem assets under " + root, e);
        }
        log.info("Loaded {} drivers and {} starters",
                drivers.values().stream().mapToInt(Map::size).sum(),
                starters.values().stream().mapToInt(Map::size).sum());
    }

    /** The problem's Driver for {@code language} with {@code userCode} at its placeholder. */
    public Program assemble(String slug, Language language, String userCode) {
        Driver driver = drivers.get(language).get(slug);
        if (driver == null) {
            throw new NoDriverException(slug, language.code());
        }
        return Program.assembled(driver.template().replace(PLACEHOLDER, userCode), language,
                driver.userCodeStartLine(), userCode);
    }

    public boolean hasDriver(String slug, Language language) {
        return drivers.get(language).containsKey(slug);
    }

    /** The problem's Starter Code per Language; empty for a slug with none. */
    public Map<Language, String> starters(String slug) {
        Map<Language, String> result = new EnumMap<>(Language.class);
        starters.forEach((language, bySlug) -> {
            String code = bySlug.get(slug);
            if (code != null) {
                result.put(language, code);
            }
        });
        return result;
    }

    /** Every slug with a Driver for {@code language}, sorted. */
    public Set<String> slugsWithDriver(Language language) {
        return new TreeSet<>(drivers.get(language).keySet());
    }

    private Driver toDriver(String slug, Language language, String template) {
        int placeholderIdx = template.indexOf(PLACEHOLDER);
        if (placeholderIdx < 0) {
            throw new IllegalStateException(
                    "Driver template missing " + PLACEHOLDER + " placeholder: " + slug + ":" + language.code());
        }
        int newlines = 0;
        for (int i = 0; i < placeholderIdx; i++) {
            if (template.charAt(i) == '\n') newlines++;
        }
        return new Driver(template, newlines + 1);
    }

    /** {@code <dir>/<slug>/<language>.<ext>} by slug. */
    private Map<String, String> scan(String dir, Language language) throws IOException {
        Map<String, String> bySlug = new HashMap<>();
        String pattern = root + dir + "/*/" + language.code() + "." + language.extension();
        for (Resource resource : find(pattern)) {
            // .../<dir>/<slug>/<language>.<ext>
            String[] segments = resource.getURL().getPath().split("/");
            if (segments.length < 2) continue;
            String slug = segments[segments.length - 2];
            if ("lib".equals(slug)) continue;
            bySlug.put(slug, readResource(resource));
        }
        return bySlug;
    }

    /** {@code drivers/lib/<language>/<Name>.<ext>} by Name. */
    private Map<String, String> scanLibraries(Language language) throws IOException {
        Map<String, String> byName = new HashMap<>();
        String ext = "." + language.extension();
        for (Resource resource : find(root + "drivers/lib/" + language.code() + "/*" + ext)) {
            String filename = resource.getFilename();
            if (filename == null) continue;
            byName.put(filename.substring(0, filename.length() - ext.length()), readResource(resource));
        }
        return byName;
    }

    private Resource[] find(String pattern) {
        try {
            return resolver.getResources(pattern);
        } catch (IOException e) {
            // The directory does not exist (no Libraries for this language): nothing to load.
            log.debug("Nothing found at {}", pattern);
            return new Resource[0];
        }
    }

    private static String resolveLibMarkers(String template, Language language, Map<String, String> libraries) {
        Matcher matcher = LIB_MARKER_PATTERN.matcher(template);
        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            String className = matcher.group(1);
            String libCode = libraries.get(className);
            if (libCode == null) {
                throw new IllegalStateException("Library not found: " + language.code() + ":" + className);
            }
            matcher.appendReplacement(result, Matcher.quoteReplacement(libCode));
        }
        matcher.appendTail(result);
        return result.toString();
    }

    private static String readResource(Resource resource) throws IOException {
        try (InputStream is = resource.getInputStream()) {
            return new String(is.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
