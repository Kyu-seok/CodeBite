package com.codebite.problem.service;

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

@Service
public class StarterCodeLoader {

    private static final Logger log = LoggerFactory.getLogger(StarterCodeLoader.class);

    private static final Map<String, String> LANGUAGE_EXTENSIONS = Map.of(
            "java", ".java",
            "python", ".py",
            "cpp", ".cpp",
            "javascript", ".js"
    );

    private final Map<String, String> cache = new HashMap<>();

    @PostConstruct
    public void loadStarterCode() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        for (Map.Entry<String, String> entry : LANGUAGE_EXTENSIONS.entrySet()) {
            String language = entry.getKey();
            String ext = entry.getValue();
            String pattern = "classpath:starters/*/" + language + ext;
            try {
                Resource[] resources = resolver.getResources(pattern);
                for (Resource resource : resources) {
                    String path = resource.getURL().getPath();
                    String[] segments = path.split("/");
                    if (segments.length < 2) continue;
                    String slug = segments[segments.length - 2];

                    cache.put(slug + ":" + language, readResource(resource));
                    log.debug("Loaded starter code: {}:{}", slug, language);
                }
            } catch (IOException e) {
                log.debug("No starter code found for language: {}", language);
            }
        }
        log.info("Loaded {} starter code entries", cache.size());
    }

    public Map<String, String> getStarterCode(String slug) {
        Map<String, String> result = new HashMap<>();
        for (String language : LANGUAGE_EXTENSIONS.keySet()) {
            String code = cache.get(slug + ":" + language);
            if (code != null) {
                result.put(language, code);
            }
        }
        return result;
    }

    private String readResource(Resource resource) throws IOException {
        try (InputStream is = resource.getInputStream()) {
            return new String(is.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
