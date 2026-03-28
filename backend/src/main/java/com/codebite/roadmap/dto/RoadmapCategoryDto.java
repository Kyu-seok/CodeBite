package com.codebite.roadmap.dto;

import java.util.List;

public record RoadmapCategoryDto(
        Long id,
        String name,
        String slug,
        String description,
        int displayOrder,
        List<String> prerequisiteSlugs,
        List<RoadmapProblemDto> problems
) {}
