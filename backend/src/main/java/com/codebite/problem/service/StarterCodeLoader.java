package com.codebite.problem.service;

import com.codebite.judge.program.ProblemAssets;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/** The Starter Code as {@link ProblemAssets} holds it, keyed by language code. */
@Service
public class StarterCodeLoader {

    private final ProblemAssets assets;

    public StarterCodeLoader(ProblemAssets assets) {
        this.assets = assets;
    }

    public Map<String, String> getStarterCode(String slug) {
        Map<String, String> result = new HashMap<>();
        assets.starters(slug).forEach((language, code) -> result.put(language.code(), code));
        return result;
    }
}
