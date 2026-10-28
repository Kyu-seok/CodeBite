package com.codebite.problem.service;

import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.TestCaseDto;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.ProblemTranslation;
import com.codebite.problem.entity.TestCase;
import com.codebite.progress.ProblemPopularity.Rate;
import com.codebite.progress.UserProgress;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/** The problem DTOs, as {@link ProblemCatalogue} and {@link ProblemAdminService} both build them. */
@Component
public class ProblemDtos {

    private final StarterCodeLoader starterCodeLoader;

    public ProblemDtos(StarterCodeLoader starterCodeLoader) {
        this.starterCodeLoader = starterCodeLoader;
    }

    ProblemListItem toListItem(Problem problem, Map<Long, UserProgress.Status> statusMap,
                                       Map<Long, Rate> acceptanceRates,
                                       Map<Long, ProblemTranslation> translationMap) {
        String title = problem.getTitle();
        ProblemTranslation t = translationMap.get(problem.getId());
        if (t != null) title = t.getTitle();

        List<String> tagNames = problem.getTags().stream()
                .map(com.codebite.problem.entity.Tag::getName)
                .sorted()
                .toList();
        return new ProblemListItem(
                problem.getId(),
                problem.getProblemNumber(),
                title,
                problem.getSlug(),
                problem.getDifficulty(),
                tagNames,
                statusMap.containsKey(problem.getId()) ? statusMap.get(problem.getId()).name() : null,
                acceptanceRates.getOrDefault(problem.getId(), Rate.NONE).percentIfGraded()
        );
    }

    ProblemDetail toDetail(Problem problem, List<TestCase> sampleCases, ProblemTranslation translation) {
        String title = problem.getTitle();
        String description = problem.getDescription();
        String constraints = problem.getConstraints();

        if (translation != null) {
            title = translation.getTitle();
            description = translation.getDescription();
            if (translation.getConstraints() != null) {
                constraints = translation.getConstraints();
            }
        }

        return new ProblemDetail(
                problem.getId(),
                problem.getProblemNumber(),
                title,
                problem.getSlug(),
                description,
                problem.getDifficulty(),
                starterCodeLoader.getStarterCode(problem.getSlug()),
                constraints,
                problem.isPublished(),
                sampleCases.stream().map(this::toTestCaseDto).toList(),
                problem.getCreatedAt(),
                problem.getUpdatedAt()
        );
    }

    TestCaseDto toTestCaseDto(TestCase tc) {
        return new TestCaseDto(
                tc.getId(),
                tc.getInput(),
                tc.getExpectedOutput(),
                tc.isSample(),
                tc.getOrderIndex()
        );
    }
}
