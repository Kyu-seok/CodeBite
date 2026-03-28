package com.codebite.roadmap.repository;

import com.codebite.roadmap.entity.RoadmapCategory;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RoadmapCategoryRepository extends JpaRepository<RoadmapCategory, Long> {

    @EntityGraph(attributePaths = {"prerequisites", "problems"})
    List<RoadmapCategory> findAllByOrderByDisplayOrderAsc();
}
