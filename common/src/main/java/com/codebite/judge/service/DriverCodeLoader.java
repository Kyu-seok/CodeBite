package com.codebite.judge.service;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class DriverCodeLoader {

    private static final Logger log = LoggerFactory.getLogger(DriverCodeLoader.class);

    private static final Map<String, String> LANGUAGE_EXTENSIONS = Map.of(
            "java", ".java",
            "python", ".py",
            "cpp", ".cpp",
            "javascript", ".js"
    );

    private static final Pattern LIB_MARKER_PATTERN = Pattern.compile("^(?://|#)\\s*\\{\\{LIB:(\\w+)}}$", Pattern.MULTILINE);

    private final Map<String, String> templateCache = new HashMap<>();
    private final Map<String, String> libCache = new HashMap<>();

    @PostConstruct
    public void loadTemplates() throws IOException {
        loadLibraries();
        loadDriverTemplates();
        log.info("Loaded {} driver templates", templateCache.size());
    }

    public String getDriverCode(String slug, String language) {
        String key = slug + ":" + language;
        String template = templateCache.get(key);
        if (template == null) {
            throw new IllegalArgumentException("No driver code available for " + slug + " in " + language);
        }
        return template;
    }

    public boolean hasDriverCode(String slug, String language) {
        return templateCache.containsKey(slug + ":" + language);
    }

    private void loadLibraries() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        for (Map.Entry<String, String> entry : LANGUAGE_EXTENSIONS.entrySet()) {
            String language = entry.getKey();
            String ext = entry.getValue();
            String pattern = "classpath:drivers/lib/" + language + "/*" + ext;
            try {
                Resource[] resources = resolver.getResources(pattern);
                for (Resource resource : resources) {
                    String filename = resource.getFilename();
                    if (filename == null) continue;
                    String className = filename.replace(ext, "");
                    String libKey = language + ":" + className;
                    libCache.put(libKey, readResource(resource));
                    log.debug("Loaded library: {}", libKey);
                }
            } catch (IOException e) {
                // No libraries for this language yet — that's fine
                log.debug("No libraries found for language: {}", language);
            }
        }
    }

    private void loadDriverTemplates() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        for (Map.Entry<String, String> entry : LANGUAGE_EXTENSIONS.entrySet()) {
            String language = entry.getKey();
            String ext = entry.getValue();
            String pattern = "classpath:drivers/*/" + language + ext;
            try {
                Resource[] resources = resolver.getResources(pattern);
                for (Resource resource : resources) {
                    String path = resource.getURL().getPath();
                    // Extract slug from path: .../drivers/{slug}/{language}.{ext}
                    String[] segments = path.split("/");
                    if (segments.length < 2) continue;
                    String slug = segments[segments.length - 2];
                    if ("lib".equals(slug)) continue;

                    String template = readResource(resource);
                    template = resolveLibMarkers(template, language);
                    templateCache.put(slug + ":" + language, template);
                    log.debug("Loaded driver template: {}:{}", slug, language);
                }
            } catch (IOException e) {
                log.debug("No driver templates found for language: {}", language);
            }
        }
    }

    public String resolveLibMarkers(String template, String language) {
        Matcher matcher = LIB_MARKER_PATTERN.matcher(template);
        StringBuilder result = new StringBuilder();
        while (matcher.find()) {
            String className = matcher.group(1);
            String libKey = language + ":" + className;
            String libCode = libCache.get(libKey);
            if (libCode == null) {
                throw new IllegalStateException("Library not found: " + libKey);
            }
            matcher.appendReplacement(result, Matcher.quoteReplacement(libCode));
        }
        matcher.appendTail(result);
        return result.toString();
    }

    private String readResource(Resource resource) throws IOException {
        try (InputStream is = resource.getInputStream()) {
            return new String(is.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
