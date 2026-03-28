package com.codebite.roadmap.service;

import com.codebite.problem.entity.Problem;
import com.codebite.roadmap.dto.RoadmapCategoryDto;
import com.codebite.roadmap.dto.RoadmapProblemDto;
import com.codebite.roadmap.dto.RoadmapResponse;
import com.codebite.roadmap.entity.RoadmapCategory;
import com.codebite.roadmap.repository.RoadmapCategoryRepository;
import com.codebite.submission.repository.SubmissionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RoadmapService {

    private final RoadmapCategoryRepository categoryRepository;
    private final SubmissionRepository submissionRepository;

    public RoadmapService(RoadmapCategoryRepository categoryRepository,
                          SubmissionRepository submissionRepository) {
        this.categoryRepository = categoryRepository;
        this.submissionRepository = submissionRepository;
    }

    @Transactional(readOnly = true)
    public RoadmapResponse getRoadmap(Long userId) {
        List<RoadmapCategory> categories = categoryRepository.findAllByOrderByDisplayOrderAsc();
        Map<Long, String> statusMap = userId != null ? buildStatusMap(userId) : Map.of();

        List<RoadmapCategoryDto> dtos = categories.stream()
                .map(cat -> toDto(cat, statusMap))
                .toList();

        return new RoadmapResponse(dtos);
    }

    private RoadmapCategoryDto toDto(RoadmapCategory category, Map<Long, String> statusMap) {
        List<String> prerequisiteSlugs = category.getPrerequisites().stream()
                .map(RoadmapCategory::getSlug)
                .sorted()
                .toList();

        List<RoadmapProblemDto> problems = category.getProblems().stream()
                .filter(Problem::isPublished)
                .map(p -> new RoadmapProblemDto(
                        p.getId(),
                        p.getTitle(),
                        p.getSlug(),
                        p.getDifficulty(),
                        statusMap.getOrDefault(p.getId(), null)
                ))
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

    private Map<Long, String> buildStatusMap(Long userId) {
        Map<Long, String> map = new HashMap<>();
        for (Object[] row : submissionRepository.findProblemStatusesByUserId(userId)) {
            map.put((Long) row[0], (String) row[1]);
        }
        return map;
    }
}
