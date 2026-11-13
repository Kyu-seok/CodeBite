package com.codebite.problem.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Component;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.TreeSet;

/**
 * Every problem's Walkthrough, read once from {@code walkthroughs/<slug>.json} on the classpath
 * (ADR 0011) and kept as the file's JSON text, keyed by the Slug it is filed under. A file that
 * isn't valid JSON fails startup rather than a request.
 */
@Component
public class Walkthroughs {

    private static final Logger log = LoggerFactory.getLogger(Walkthroughs.class);
    private static final String SUFFIX = ".json";

    private final Map<String, String> bySlug = new HashMap<>();

    public Walkthroughs() {
        this("classpath:");
    }

    /** Reads from {@code root} instead of the classpath root, e.g. {@code classpath:fixtures/}. */
    public Walkthroughs(String root) {
        ObjectMapper json = new ObjectMapper();
        for (Resource resource : find(root + "walkthroughs/*" + SUFFIX)) {
            String filename = resource.getFilename();
            if (filename == null) continue;
            String text = read(resource);
            try {
                json.readTree(text);
            } catch (JsonProcessingException e) {
                throw new IllegalStateException("Walkthrough is not valid JSON: walkthroughs/" + filename
                        + ": " + e.getOriginalMessage(), e);
            }
            bySlug.put(filename.substring(0, filename.length() - SUFFIX.length()), text);
        }
        log.info("Loaded {} walkthroughs", bySlug.size());
    }

    public boolean has(String slug) {
        return bySlug.containsKey(slug);
    }

    /** The Walkthrough filed under {@code slug}, as its JSON text. */
    public Optional<String> of(String slug) {
        return Optional.ofNullable(bySlug.get(slug));
    }

    /** Every Slug a Walkthrough is filed under, in order. */
    public Set<String> slugs() {
        return new TreeSet<>(bySlug.keySet());
    }

    private static Resource[] find(String pattern) {
        try {
            return new PathMatchingResourcePatternResolver().getResources(pattern);
        } catch (FileNotFoundException e) {
            return new Resource[0]; // no walkthroughs/ directory: no Walkthroughs
        } catch (IOException e) {
            throw new UncheckedIOException("Could not list " + pattern, e);
        }
    }

    private static String read(Resource resource) {
        try (InputStream is = resource.getInputStream()) {
            return new String(is.readAllBytes(), StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new UncheckedIOException("Could not read walkthroughs/" + resource.getFilename(), e);
        }
    }
}
