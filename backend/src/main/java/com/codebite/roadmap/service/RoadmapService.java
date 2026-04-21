package com.codebite.roadmap.service;

import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.ProblemTranslation;
import com.codebite.problem.repository.ProblemTranslationRepository;
import com.codebite.roadmap.dto.RoadmapCategoryDto;
import com.codebite.roadmap.dto.RoadmapProblemDto;
import com.codebite.roadmap.dto.RoadmapResponse;
import com.codebite.roadmap.entity.RoadmapCategory;
import com.codebite.roadmap.repository.RoadmapCategoryRepository;
import com.codebite.submission.repository.SubmissionRepository;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class RoadmapService {

    private final RoadmapCategoryRepository categoryRepository;
    private final SubmissionRepository submissionRepository;
    private final ProblemTranslationRepository translationRepository;

    public RoadmapService(RoadmapCategoryRepository categoryRepository,
                          SubmissionRepository submissionRepository,
                          ProblemTranslationRepository translationRepository) {
        this.categoryRepository = categoryRepository;
        this.submissionRepository = submissionRepository;
        this.translationRepository = translationRepository;
    }

    @Transactional(readOnly = true)
    public RoadmapResponse getRoadmap(Long userId) {
        List<RoadmapCategory> categories = categoryRepository.findAllByOrderByDisplayOrderAsc();
        Map<Long, String> statusMap = userId != null ? buildStatusMap(userId) : Map.of();

        // Collect all published problem IDs for translation lookup
        List<Long> allProblemIds = categories.stream()
                .flatMap(c -> c.getProblems().stream())
                .filter(Problem::isPublished)
                .map(Problem::getId)
                .toList();
        Map<Long, ProblemTranslation> translationMap = fetchTranslationMap(allProblemIds);

        List<RoadmapCategoryDto> dtos = categories.stream()
                .map(cat -> toDto(cat, statusMap, translationMap))
                .toList();

        return new RoadmapResponse(dtos);
    }

    private RoadmapCategoryDto toDto(RoadmapCategory category, Map<Long, String> statusMap,
                                     Map<Long, ProblemTranslation> translationMap) {
        List<String> prerequisiteSlugs = category.getPrerequisites().stream()
                .map(RoadmapCategory::getSlug)
                .sorted()
                .toList();

        List<RoadmapProblemDto> problems = category.getProblems().stream()
                .filter(Problem::isPublished)
                .map(p -> {
                    ProblemTranslation t = translationMap.get(p.getId());
                    String title = t != null ? t.getTitle() : p.getTitle();
                    return new RoadmapProblemDto(
                            p.getId(),
                            title,
                            p.getSlug(),
                            p.getDifficulty(),
                            statusMap.getOrDefault(p.getId(), null)
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

    private Map<Long, String> buildStatusMap(Long userId) {
        Map<Long, String> map = new HashMap<>();
        for (Object[] row : submissionRepository.findProblemStatusesByUserId(userId)) {
            map.put((Long) row[0], (String) row[1]);
        }
        return map;
    }
}
