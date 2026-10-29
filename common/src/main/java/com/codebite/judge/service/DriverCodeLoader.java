package com.codebite.judge.service;

import com.codebite.judge.Language;
import com.codebite.judge.program.ProblemAssets;
import org.springframework.stereotype.Service;

/** The Drivers as {@link ProblemAssets} holds them, for callers not yet on {@code Program}. */
@Service
public class DriverCodeLoader {

    private static final String PLACEHOLDER = "{USER_CODE}";

    private final ProblemAssets assets;

    public DriverCodeLoader(ProblemAssets assets) {
        this.assets = assets;
    }

    public String getDriverCode(String slug, String language) {
        return assets.assemble(slug, toLanguage(slug, language), PLACEHOLDER).source();
    }

    public boolean hasDriverCode(String slug, String language) {
        return Language.fromCode(language).map(l -> assets.hasDriver(slug, l)).orElse(false);
    }

    /**
     * Line (1-based) in the combined source where the user's code begins.
     * Judge0 reports line numbers in the combined file; callers need this
     * offset to translate those back to user-buffer lines.
     */
    public int getUserCodeStartLine(String slug, String language) {
        String template = getDriverCode(slug, language);
        int placeholderIdx = template.indexOf(PLACEHOLDER);
        int newlines = 0;
        for (int i = 0; i < placeholderIdx; i++) {
            if (template.charAt(i) == '\n') newlines++;
        }
        return newlines + 1;
    }

    private static Language toLanguage(String slug, String language) {
        return Language.fromCode(language).orElseThrow(() -> new IllegalArgumentException(
                "No driver code available for " + slug + " in " + language));
    }
}
