package com.codebite.onboarding;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.EnumMap;
import java.util.Map;

/**
 * Where newcomers drop off in the Tutorial (GLOSSARY.md, Onboarding): the browser reports each
 * milestone as it happens, anonymously, and each milestone only increments its
 * {@code codebite.tutorial.milestones} counter. Nothing per user is stored.
 */
@RestController
public class TutorialMilestoneController {

    private final Map<TutorialMilestone, Counter> counters = new EnumMap<>(TutorialMilestone.class);

    public TutorialMilestoneController(MeterRegistry meterRegistry) {
        for (TutorialMilestone milestone : TutorialMilestone.values()) {
            counters.put(milestone, Counter.builder("codebite.tutorial.milestones")
                    .description("Tutorial milestones reached, by milestone")
                    .tag("milestone", milestone.tag())
                    .register(meterRegistry));
        }
    }

    /** 204 for a known milestone; 400 for any other. */
    @PostMapping("/api/tutorial/milestones/{milestone}")
    public ResponseEntity<Void> report(@PathVariable String milestone) {
        counters.get(TutorialMilestone.ofTag(milestone)).increment();
        return ResponseEntity.noContent().build();
    }
}
