package com.codebite.roadmap.service;

import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.ProblemTranslation;
import com.codebite.problem.repository.ProblemTranslationRepository;
import com.codebite.progress.UserProgress;
import com.codebite.roadmap.dto.RoadmapCategoryDto;
import com.codebite.roadmap.dto.RoadmapProblemDto;
import com.codebite.roadmap.dto.RoadmapResponse;
import com.codebite.roadmap.entity.RoadmapCategory;
import com.codebite.roadmap.repository.RoadmapCategoryRepository;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class RoadmapService {

    private final RoadmapCategoryRepository categoryRepository;
    private final UserProgress userProgress;
    private final ProblemTranslationRepository translationRepository;

    public RoadmapService(RoadmapCategoryRepository categoryRepository,
                          UserProgress userProgress,
                          ProblemTranslationRepository translationRepository) {
        this.categoryRepository = categoryRepository;
        this.userProgress = userProgress;
        this.translationRepository = translationRepository;
    }

    @Transactional(readOnly = true)
    public RoadmapResponse getRoadmap(Long userId) {
        List<RoadmapCategory> categories = categoryRepository.findAllByOrderByDisplayOrderAsc();
        // Every problem the roadmap offers: the ones shown, translated and given a status.
        List<Long> allProblemIds = categories.stream()
                .flatMap(c -> c.offeredProblems().stream())
                .map(Problem::getId)
                .toList();
        Map<Long, UserProgress.Status> statusMap = userId != null
                ? userProgress.statusByProblem(userId, allProblemIds) : Map.of();
        Map<Long, ProblemTranslation> translationMap = fetchTranslationMap(allProblemIds);

        List<RoadmapCategoryDto> dtos = categories.stream()
                .map(cat -> toDto(cat, statusMap, translationMap))
                .toList();

        return new RoadmapResponse(dtos);
    }

    private RoadmapCategoryDto toDto(RoadmapCategory category, Map<Long, UserProgress.Status> statusMap,
                                     Map<Long, ProblemTranslation> translationMap) {
        List<String> prerequisiteSlugs = category.getPrerequisites().stream()
                .map(RoadmapCategory::getSlug)
                .sorted()
                .toList();

        List<RoadmapProblemDto> problems = category.offeredProblems().stream()
                .map(p -> {
                    ProblemTranslation t = translationMap.get(p.getId());
                    String title = t != null ? t.getTitle() : p.getTitle();
                    return new RoadmapProblemDto(
                            p.getId(),
                            title,
                            p.getSlug(),
                            p.getDifficulty(),
                            statusMap.containsKey(p.getId()) ? statusMap.get(p.getId()).name() : null
                    );
                })
                .toList();

        return new RoadmapCategoryDto(
                category.getId(),
                category.getName(),
                category.getSlug(),
                category.getDescription(),
                category.getDisplayOrder(),
                prerequisiteSlugs,
                problems
        );
    }

    private Map<Long, ProblemTranslation> fetchTranslationMap(List<Long> problemIds) {
        String locale = LocaleContextHolder.getLocale().getLanguage();
        if ("en".equals(locale) || problemIds.isEmpty()) return Map.of();
        return translationRepository.findByProblemIdInAndLocale(problemIds, locale)
                .stream().collect(Collectors.toMap(t -> t.getProblem().getId(), t -> t));
    }
}
