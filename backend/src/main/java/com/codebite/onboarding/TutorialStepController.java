package com.codebite.onboarding;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Where newcomers drop off in the Tutorial (GLOSSARY.md, Onboarding): the browser reports each
 * step as it happens, anonymously, and each step only increments its {@code codebite.tutorial.steps}
 * counter. Nothing per user is stored.
 */
@RestController
public class TutorialStepController {

    /** The steps the Tutorial reports, in funnel order. */
    static final List<String> STEPS = List.of("started", "ran", "submitted", "accepted", "skipped");

    private final Map<String, Counter> counters;

    public TutorialStepController(MeterRegistry meterRegistry) {
        this.counters = STEPS.stream().collect(Collectors.toUnmodifiableMap(Function.identity(),
                step -> Counter.builder("codebite.tutorial.steps")
                        .description("Tutorial steps reached, by step")
                        .tag("step", step)
                        .register(meterRegistry)));
    }

    /** 204 for a known step; 400 for any other. */
    @PostMapping("/api/tutorial/steps/{step}")
    public ResponseEntity<Void> report(@PathVariable String step) {
        Counter counter = counters.get(step);
        if (counter == null) {
            throw new IllegalArgumentException("Unknown Tutorial step: " + step);
        }
        counter.increment();
        return ResponseEntity.noContent().build();
    }
}
